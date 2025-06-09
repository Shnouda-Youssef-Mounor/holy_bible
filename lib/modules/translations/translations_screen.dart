import 'package:flutter/material.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/bibles_fetch.dart';
import 'package:holy_bible/modules/bible_books_screen/book_content_screen.dart';

class TranslationsScreen extends StatefulWidget {
  final List<dynamic> translations;
  const TranslationsScreen({super.key, required this.translations});

  @override
  State<TranslationsScreen> createState() => _TranslationsScreenState();
}

class _TranslationsScreenState extends State<TranslationsScreen> {
  List<dynamic> _translations = []; // List to store translations
  List<dynamic> filterList = [];
  Map<String, dynamic> _bookContent = {}; // List to store books
  var languageSet = Set<String>();
  String? selectedLanguage;
  List<String> languages = [];
  // ignore: unused_field
  Map<String, dynamic> _translation = {
    "identifier": "",
    "name": "",
    "language": "",
    "language_code": "",
    "license": ""
  }; // Map to store selected translation details

  @override
  void initState() {
    super.initState();
    _translations = widget.translations;
    for (var item in _translations) {
      var languageName = item["language"]["name"];
      languageSet.add(languageName);
    }
    languages = languageSet.toList()..sort();
    filterDataByLanguage(selectedLanguage);
  }

  void filterDataByLanguage(String? selectedLanguage) {
    if (selectedLanguage == null || selectedLanguage.isEmpty) {
      setState(() {
        filterList = _translations; // If no language is selected, show all data
      });
    } else {
      setState(() {
        filterList = _translations
            .where((item) => item["language"]["name"] == selectedLanguage)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translations'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "Languages : ${filterList.length}",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              icon: selectedLanguage != null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          selectedLanguage = null;
                          filterDataByLanguage(selectedLanguage);
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        size: 14,
                      ))
                  : null,
              elevation: 5,
              borderRadius: BorderRadius.circular(12),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple), // Red border
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.deepPurple), // Red border when focused
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.purple), // Default red border
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              hint: Text(
                "Select a Language",
                style: TextStyle(color: Colors.grey),
              ),
              value: selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue;
                  filterDataByLanguage(selectedLanguage);
                });
              },
              items: languages.map<DropdownMenuItem<String>>((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(
                    language,
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }).toList(),
            ),
          ),
          if (selectedLanguage != null)
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'You selected: $selectedLanguage',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          Expanded(
              child: ListView.builder(
            itemCount: filterList.length,
            itemBuilder: (context, index) {
              final translation = filterList[index];
              final language = translation['language']['name'] ?? "";
              final description = translation['description'] ?? "";
              final abbreviation = translation['abbreviation'] ?? "";

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 1,
                color: Colors.white,
                child: InkWell(
                  onTap: () async {
                    await BiblesFetch.fetchBibleByBibleId(
                            bibleId: translation['id'])
                        .then((data) {
                      setState(() {
                        _bookContent = data;
                      });
                    });
                    CacheHelper.saveData(
                        key: "bibleId", value: translation['id'].toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookContentScreen(
                          content: _bookContent,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Icon or Image for the translation
                        Icon(
                          Icons.book,
                          size: 40,
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Translation Name
                              Text(
                                translation['name'] ?? "",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple),
                              ),
                              const SizedBox(height: 4),
                              // Language
                              Text(
                                'Language: $language',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Abbreviation
                              Text(
                                'Abbreviation: $abbreviation',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Description
                              Text(
                                description ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
