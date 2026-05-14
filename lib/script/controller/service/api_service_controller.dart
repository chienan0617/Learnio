import 'package:learnio/base.dart';
import 'package:http/http.dart' as http;

/// Controller to manage API calls between the server and client.
class ApiServiceController {
  static const String _baseUrl = 'https://cas.cas617.workers.dev/learnio/chat';

  /// Sends chat context to the server and returns a stream of responses.
  /// 
  /// [messages] is a list of maps containing 'role' and 'content'.
  /// [model] is the AI model to use.
  /// [images] is an optional list of base64 encoded images.
  Stream<String> streamChat({
    required List<Map<String, dynamic>> messages,
    String? model,
    List<String>? images,
  }) async* {
    final client = http.Client();
    
    try {
      final request = http.Request('POST', Uri.parse(_baseUrl));
      request.headers['Content-Type'] = 'application/json';
      
      final body = {
        'messages': messages,
        if (model != null) 'model': model,
        if (images != null && images.isNotEmpty) 'images': images,
      };
      
      request.body = jsonEncode(body);

      final response = await client.send(request);

      if (response.statusCode != 200) {
        yield 'Error: ${response.statusCode}';
        return;
      }

      // Read the stream
      await for (final chunk in response.stream.transform(utf8.decoder)) {
        // Handle SSE (Server-Sent Events) or raw text
        final lines = chunk.split('\n');
        for (var line in lines) {
          if (line.trim().isEmpty) continue;
          
          if (line.startsWith('data: ')) {
            final data = line.substring(6).trim();
            if (data == '[DONE]') break;
            
            try {
              // Try to parse as JSON if it looks like JSON
              if (data.startsWith('{')) {
                final json = jsonDecode(data);
                // Common formats: {"text": "..."}, {"content": "..."}, {"choices": [{"delta": {"content": "..."}}]}
                if (json['text'] != null) {
                  yield json['text'];
                } else if (json['content'] != null) {
                  yield json['content'];
                } else if (json['choices'] != null && json['choices'] is List) {
                  final choices = json['choices'] as List;
                  if (choices.isNotEmpty && choices[0]['delta'] != null && choices[0]['delta']['content'] != null) {
                    yield choices[0]['delta']['content'];
                  }
                }
              } else {
                // If it's data: but not JSON, just yield the data
                yield data;
              }
            } catch (e) {
              // If JSON parsing fails, just yield the raw data
              yield data;
            }
          } else {
            // Raw text chunk
            yield line;
          }
        }
      }
    } catch (e) {
      yield 'Error: $e';
    } finally {
      client.close();
    }
  }
}
