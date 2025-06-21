import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  static Future<List> fetchTranslations() async {
    String token = await dotenv.env['API_TOKEN'] ?? "";
    final response = await http.get(
        Uri.parse(
            'https://api.scripture.api.bible/v1/bibles?include-full-details=true'),
        headers: {"api-key": token, "accept": "application/json"});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      return [];
    }
  }

  static Future<List> fetchUrlGetBook({required String url}) async {
    final response = await http.get(Uri.parse(url.toString()));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['books'];
    } else {
      return [];
    }
  }

  static Future<List> fetchUrlGetChapters({required String url}) async {
    final response = await http.get(Uri.parse(url.toString()));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['chapters'];
    } else {
      return [];
    }
  }

  static Future<List> fetchUrlGetChapterContent({required String url}) async {
    final response = await http.get(Uri.parse(url.toString()));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['verses'];
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchUrlGetTranslation(
      {required String url}) async {
    final response = await http.get(Uri.parse(url.toString()));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['translation'];
    } else {
      return {};
    }
  }
}
