import 'dart:convert';

import 'package:http/http.dart' as http;

class ChaptersFetch {
  static Future<List> fetchChapters(
      {required String bibleId, required String bookId}) async {
    final response = await http.get(
        Uri.parse(
            'https://api.scripture.api.bible/v1/bibles/$bibleId/books/$bookId/chapters'),
        headers: {
          "api-key": "655f5b8b156086bdc092c95e87ae3b23",
          "accept": "application/json"
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchGetChapter(
      {required String bibleId, required String chapterId}) async {
    final response = await http.get(
        Uri.parse(
            'https://api.scripture.api.bible/v1/bibles/$bibleId/chapters/$chapterId?content-type=html&include-notes=false&include-titles=true&include-chapter-numbers=false&include-verse-numbers=true&include-verse-spans=false'),
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
