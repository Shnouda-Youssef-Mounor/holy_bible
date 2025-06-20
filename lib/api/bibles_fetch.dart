import 'dart:convert';

import 'package:http/http.dart' as http;

class BiblesFetch {
  static Future<List> fetchBible(String token) async {
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

  static Future<Map<String, dynamic>> fetchBibleByBibleId(
      {required String bibleId, required String token}) async {
    final response = await http.get(
        Uri.parse('https://api.scripture.api.bible/v1/bibles/$bibleId'),
        headers: {
          "api-key": "655f5b8b156086bdc092c95e87ae3b23",
          "accept": "application/json"
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      return {};
    }
  }
}
