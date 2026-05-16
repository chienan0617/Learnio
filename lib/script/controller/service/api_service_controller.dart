import 'package:learnio/base.dart';
import 'package:http/http.dart' as http;

/// Controller to manage API calls between the server and client.
class ApiServiceController {
  static const String _baseUrl = 'http://cas.cas617.workers.dev/learnio/chat';

  /// Sends chat context to the server and returns a stream of responses.
  ///
  /// [messages] is a list of maps containing 'role' and 'content'.
  /// [model] is the AI model to use.
  /// [images] is an optional list of base64 encoded images.
  Stream<String> streamChat({
    required List<Map<String, dynamic>> messages,
    String? model,
    String? gateway,
    List<String>? images,
    List<String>? files,
    List<String>? links,
  }) async* {
    final filteredMessages = messages.where((msg) {
      final content = msg['content'];
      final hasContent =
          content != null && content.toString().trim().isNotEmpty;
      final hasImages =
          msg['images'] != null && (msg['images'] as List).isNotEmpty;
      final hasFiles =
          msg['files'] != null && (msg['files'] as List).isNotEmpty;
      final hasLinks =
          msg['links'] != null && (msg['links'] as List).isNotEmpty;

      return hasContent || hasImages || hasFiles || hasLinks;
    }).toList();

    logE(filteredMessages); // 確認過濾後的結果

    final client = http.Client();
    try {
      final request = http.Request('POST', Uri.parse(_baseUrl));
      request.headers['Content-Type'] = 'application/json';

      final body = {
        'messages': filteredMessages, // 🛠️ 2. 改用過濾後的訊息
        if (model != null) 'model': model,
        if (gateway != null) 'gateway': gateway,
        if (images != null && images.isNotEmpty) 'images': images,
        if (files != null && files.isNotEmpty) 'files': files,
        if (links != null && links.isNotEmpty) 'links': links,
      };

      request.body = jsonEncode(body);

      final response = await client.send(request);

      if (response.statusCode != 200) {
        yield 'Error: ${response.statusCode}';
        return;
      }

      // Read the stream
      String buffer = '';
      await for (final chunk in response.stream.transform(utf8.decoder)) {
        buffer += chunk;

        // Process complete lines from the buffer
        while (buffer.contains('\n')) {
          final lineEnd = buffer.indexOf('\n');
          final line = buffer.substring(0, lineEnd).trim();
          buffer = buffer.substring(lineEnd + 1);

          if (line.isEmpty) continue;

          // 1. Handle SSE data prefix
          String content = line;
          if (line.startsWith('data: ')) {
            content = line.substring(6).trim();
          }

          if (content == '[DONE]') return;

          // 2. Try to parse as JSON (handles concatenated JSONs like {"text":"A"}{"text":"B"})
          if (content.startsWith('{')) {
            final jsonParts = content.split('}{');
            for (var i = 0; i < jsonParts.length; i++) {
              var part = jsonParts[i];
              if (i > 0) part = '{$part';
              if (i < jsonParts.length - 1) part = '$part}';

              try {
                final json = jsonDecode(part);
                final text = _extractTextFromJson(json);
                if (text != null) yield text;
              } catch (e) {
                // If it's not valid JSON despite starting with {, ignore it
                // unless it's the last part which might be incomplete
                if (i == jsonParts.length - 1 && !part.endsWith('}')) {
                  // Put it back in buffer for next chunk
                  buffer = part + (buffer.isEmpty ? "" : "\n$buffer");
                }
              }
            }
          } else {
            // 3. Raw text that doesn't look like JSON or SSE metadata
            // We only yield it if it doesn't look like system noise
            if (!_isSystemNoise(content)) {
              yield content;
            }
          }
        }
      }
    } catch (e) {
      yield 'Error: $e';
    } finally {
      client.close();
    }
  }

  /// Extracts text from common AI response JSON formats.
  String? _extractTextFromJson(Map<String, dynamic> json) {
    if (json['text'] != null) return json['text'].toString();
    if (json['content'] != null) return json['content'].toString();
    if (json['choices'] != null && json['choices'] is List) {
      final choices = json['choices'] as List;
      if (choices.isNotEmpty) {
        final choice = choices[0];
        if (choice['delta'] != null && choice['delta']['content'] != null) {
          return choice['delta']['content'].toString();
        }
        if (choice['message'] != null && choice['message']['content'] != null) {
          return choice['message']['content'].toString();
        }
        if (choice['text'] != null) return choice['text'].toString();
      }
    }
    return null;
  }

  /// Checks if a string looks like system diagnostic noise (e.g., from wrangler).
  bool _isSystemNoise(String text) {
    final noisePatterns = [
      r'memory\s+/auth',
      r'\d+\.\d+\s+MB',
      r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', // Email
      r'▀+', // Block characters
    ];
    for (final pattern in noisePatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(text)) {
        return true;
      }
    }
    return false;
  }
}
