import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/audio_bibles_fetch.dart';
import 'package:holy_bible/modules/bible_books_screen/book_content_audio_screen.dart';

class AudiosLanguagesScreen extends StatefulWidget {
  final List<dynamic> audios;

  const AudiosLanguagesScreen({super.key, required this.audios});

  @override
  State<AudiosLanguagesScreen> createState() => _AudiosLanguagesScreenState();
}

class _AudiosLanguagesScreenState extends State<AudiosLanguagesScreen> {
  List<dynamic> _audios = [];
  List<dynamic> filterList = [];
  Map<String, dynamic> _bookContent = {};
  Set<String> languageSet = {};
  String? selectedLanguage;
  List<String> languages = [];
  String token = dotenv.env['API_TOKEN'] ?? "";

  @override
  void initState() {
    super.initState();
    _audios = widget.audios;
    for (var item in _audios) {
      languageSet.add(item["language"]["name"]);
    }
    languages = languageSet.toList()..sort();
    filterDataByLanguage(selectedLanguage);
  }

  void filterDataByLanguage(String? selectedLanguage) {
    setState(() {
      filterList = selectedLanguage == null || selectedLanguage.isEmpty
          ? _audios
          : _audios
              .where((item) => item["language"]["name"] == selectedLanguage)
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Bibles'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
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
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue;
                  filterDataByLanguage(selectedLanguage);
                });
              },
              icon: selectedLanguage != null
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        setState(() {
                          selectedLanguage = null;
                          filterDataByLanguage(null);
                        });
                      },
                    )
                  : const Icon(Icons.arrow_drop_down),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                filled: true,
                fillColor: Colors.white,
                hintText: "Select a language",
                hintStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: languages.map((language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(
                    language,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ),
          ),
          if (selectedLanguage != null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Selected: $selectedLanguage',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Available Audio Bibles",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Expanded(
            child: filterList.isEmpty
                ? const Center(child: Text("No Audio Bibles Found"))
                : ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (context, index) {
                      final audio = filterList[index];
                      final language = audio['language']['name'] ?? "";
                      final description = audio['description'] ?? "";
                      final abbreviation = audio['abbreviation'] ?? "";

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0.5,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            final data =
                                await AudioBiblesFetch.fetchBibleByBibleId(
                                    bibleId: audio['id'], token: token);
                            CacheHelper.saveData(
                                key: "audioBibleId", value: audio['id']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookContentAudioScreen(content: data),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const Icon(Icons.library_music,
                                    size: 40, color: Colors.purple),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        audio['name'] ?? "",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Language: $language',
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14),
                                      ),
                                      Text(
                                        'Abbreviation: $abbreviation',
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14),
                                      ),
                                      if (description.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          description,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
