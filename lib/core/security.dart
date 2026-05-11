import 'dart:convert' as convert;
import 'package:crypto/crypto.dart' as crypto;

class Security {
  static String salt = 'I\'m not a seasick puppy.';

  static String encryption(Object key) {
    final bytes = convert.utf8.encode("${Security.salt}:${key.toString()}}");
    final digest = crypto.sha256.convert(bytes);
    return digest.toString();
  }
}
