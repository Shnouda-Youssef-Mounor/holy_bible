import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class SearchFetch {
  static Future<Map<String, String>> loadDictionary() async {
    String data = await rootBundle.loadString('assets/arabic.json');
    return Map<String, String>.from(json.decode(data));
  }

  static Future<String> shapeText(String text) async {
    Map<String, String> dictionary = await loadDictionary();
    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (dictionary.containsKey(words[i])) {
        words[i] = dictionary[words[i]]!;
      }
    }
    return words.join(' ');
  }

  static Future<Map<String, dynamic>> fetchForSearch(
      {required String bibleId, required String text}) async {
    String query = "";
    await SearchFetch.shapeText(text).then((data) {
      query = data;
    }).catchError((err) {
      debugPrint(err.toString());
    });
    final response = await http.get(
      Uri.parse(
          'https://api.scripture.api.bible/v1/bibles/$bibleId/search?query=$query&limit=10000&sort=relevance'),
      headers: {
        "api-key": "655f5b8b156086bdc092c95e87ae3b23",
        "accept": "application/json"
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load translations');
    }
  }
}
