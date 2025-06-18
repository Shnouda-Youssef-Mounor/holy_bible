import 'dart:convert';

import 'package:http/http.dart' as http;

class BookFetchAudio {
  static Future<List> fetchBooksByBibleId({required String bibleId}) async {
    final response = await http.get(
        Uri.parse(
            'https://api.scripture.api.bible/v1/audio-bibles/$bibleId/books'),
        headers: {
          "api-key": "655f5b8b156086bdc092c95e87ae3b23",
          "accept": "application/json"
        });
    print(bibleId);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      return [];
    }
  }

  static Future<List> fetchBookByBibleIdAndBookId(
      {required String bibleId, required String bookId}) async {
    final response = await http.get(
        Uri.parse(
            'https://api.scripture.api.bible/v1/audio-bibles/$bibleId/books/$bookId'),
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
}
