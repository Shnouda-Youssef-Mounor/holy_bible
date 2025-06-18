import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiResponse {
  static Future<List> fetchTranslations() async {
    final response = await http.get(
        Uri.parse(
            'https://api.scripture.api.bible/v1/bibles?include-full-details=true'),
        headers: {
          "api-key": "655f5b8b156086bdc092c95e87ae3b23",
          "accept": "application/json"
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
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
