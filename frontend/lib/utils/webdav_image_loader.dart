import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WebDAVImageLoader {
  /// Carrega uma imagem do WebDAV com autenticação básica
  static Future<Widget> load({
    required String url,
    required String username,
    required String password,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$username:$password'))}',
        },
      );

      if (response.statusCode == 200) {
        return Image.memory(
          response.bodyBytes,
          fit: fit,
          width: width,
          height: height,
        );
      } else {
        return const Icon(Icons.broken_image, color: Colors.grey);
      }
    } catch (e) {
      return const Icon(Icons.error, color: Colors.red);
    }
  }
}