import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  List<dynamic> _translations = [];
  List<dynamic> filterList = [];
  Map<String, dynamic> _bookContent = {};
  var languageSet = <String>{};
  String? selectedLanguage;
  List<String> languages = [];

  @override
  void initState() {
    super.initState();
    _translations = widget.translations;
    for (var item in _translations) {
      languageSet.add(item["language"]["name"]);
    }
    languages = languageSet.toList()..sort();
    filterDataByLanguage(selectedLanguage);
  }

  void filterDataByLanguage(String? selectedLanguage) {
    setState(() {
      filterList = selectedLanguage == null || selectedLanguage.isEmpty
          ? _translations
          : _translations
              .where((item) => item["language"]["name"] == selectedLanguage)
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translations'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.language, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  "Languages: ${filterList.length}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              icon: selectedLanguage != null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          selectedLanguage = null;
                          filterDataByLanguage(null);
                        });
                      },
                      icon: const Icon(Icons.close, size: 18))
                  : const Icon(Icons.arrow_drop_down),
              decoration: InputDecoration(
                labelText: 'Select a Language',
                labelStyle: const TextStyle(color: Colors.purple),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              value: selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue;
                  filterDataByLanguage(newValue);
                });
              },
              items: languages
                  .map((language) => DropdownMenuItem(
                        value: language,
                        child: Text(language,
                            style: const TextStyle(color: Colors.grey)),
                      ))
                  .toList(),
            ),
          ),
          if (selectedLanguage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Selected: $selectedLanguage',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: filterList.length,
              itemBuilder: (context, index) {
                final translation = filterList[index];
                final language = translation['language']['name'] ?? "";
                final description = translation['description'] ?? "";
                final abbreviation = translation['abbreviation'] ?? "";

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        String token = dotenv.env['API_TOKEN'] ?? "";

                        final data = await BiblesFetch.fetchBibleByBibleId(
                            bibleId: translation['id'], token: token);
                        setState(() {
                          _bookContent = data;
                        });
                        CacheHelper.saveData(
                          key: "bibleId",
                          value: translation['id'].toString(),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookContentScreen(content: _bookContent),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.menu_book_rounded,
                                size: 36, color: Colors.purple),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translation['name'] ?? "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Language: $language',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Abbreviation: $abbreviation',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
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
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
