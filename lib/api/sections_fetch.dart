import 'dart:convert';

import 'package:http/http.dart' as http;

class SectionsFetch {
  static Future<List> fetchChapterSection(
      {required String bibleId,
      required String bookId,
      required String token}) async {
    final response = await http.get(
        Uri.parse(
            'https://api.scripture.api.bible/v1/bibles/$bibleId/books/$bookId/sections'),
        headers: {"api-key": token, "accept": "application/json"});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      return [];
    }
  }
}
