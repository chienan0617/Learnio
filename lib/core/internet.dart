import 'package:learnio/base.dart';
import 'package:http/http.dart' as http;

class Internet implements Initialable {
  @initial
  static Future<void> initialize() async {
    // track();
  }

  static Future<void> track() async {
    try {
      // final v = await fetch<Map>("https://note-do.cas617.workers.dev/v/active");
      // Data.internet.put(DateTime.now().toIso8601String(), v);
    } catch (e) {
      none();
    }
  }

  @functional
  static Future<T> fetch<T>(String url, [Map? params]) async {
    var req = '?';
    if (params != null) params.forEach((k, v) => req += '$k=$v');
    final res = await http.get(Uri.parse(params == null ? url : url + req));

    if (res.statusCode != 200) {
      Debug.log('fetch failed: ${res.statusCode}, ${res.body}');
      throw InternetError('fetch failed: ${res.statusCode}, ${res.body}');
    }

    return res.body as T;
  }

  static Future<T> getFile<T>(String url) async {
    final res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) {
      Debug.log('fetch failed: ${res.statusCode}, ${res.body}');
      throw InternetError('fetch failed: ${res.statusCode}, ${res.body}');
    }

    return res.body as T;
  }

  @functional
  static Future<T> postJson<T>(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final headers0 = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      if (headers != null) ...headers,
    };

    final res = await http.post(
      Uri.parse(url),
      headers: headers0,
      body: body == null ? null : jsonEncode(body),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      Debug.log('postJson failed: ${res.statusCode}, ${res.body}');
      throw InternetError('postJson failed: ${res.statusCode}, ${res.body}');
    }

    // 這裡假設 T 是 String 或你要解析 JSON 的型態
    return res.body as T;
  }
}
