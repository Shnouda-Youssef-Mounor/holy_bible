import 'dart:convert';

import 'package:http/http.dart' as http;

class BooksFetch {
  static Future<List> fetchBooksByBibleId(
      {required String bibleId, required String token}) async {
    print("SSSS : $bibleId");
    final response = await http.get(
        Uri.parse(
            'https://api.scripture.api.bible/v1/bibles/$bibleId/books?include-chapters=true&include-chapters-and-sections=true'),
        headers: {"api-key": token, "accept": "application/json"});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      return [];
    }
  }

  static Future<List> fetchBookByBibleIdAndBookId(
      {required String bibleId,
      required String bookId,
      required String token}) async {
    final response = await http.get(
        Uri.parse(
            'https://api.scripture.api.bible/v1/bibles/$bibleId/books/$bookId?include-chapters=false'),
        headers: {"api-key": token, "accept": "application/json"});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      return [];
    }
  }
}
