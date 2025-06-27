import 'dart:convert';
import 'package:crypto/crypto.dart';

/// 加密
String encryption(String value) {
  final context = utf8.encode(value);

  /// base64 格式
  // final secretKey = utf8.encode('aGVsbG8gd29ybGQ=');
  return sha512.convert(context).toString();

  // return Hmac(sha256, secretKey).convert(context).toString();
}
