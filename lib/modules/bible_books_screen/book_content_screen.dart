import 'package:flutter/material.dart';
import 'package:holy_bible/api/books_fetch.dart';
import 'package:holy_bible/modules/bible_books_screen/bible_books_screen.dart';

class BookContentScreen extends StatelessWidget {
  final Map<String, dynamic> content;
  BookContentScreen({super.key, required this.content});

  List<dynamic> _books = [];

  @override
  Widget build(BuildContext context) {
    final language = content['language'] ?? {};
    final countries = content['countries'] ?? [];
    final audioBibles = content['audioBibles'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(content['nameLocal'] ?? ''),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    content['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    content['nameLocal'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Abbreviation: ${content['abbreviation'] ?? "N/A"}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            /// Description
            _buildSectionTitle("Description"),
            Text(
              content['descriptionLocal'] ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            /// Language
            _buildSectionTitle("Language"),
            Text(
              '${language['name'] ?? 'Unknown'} (${language['nameLocal'] ?? 'Local'})',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Script: ${language['script'] ?? "Unknown"}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Direction: ${language['scriptDirection'] ?? "Unknown"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            /// Countries
            _buildSectionTitle("Countries Available"),
            if (countries.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: countries
                    .map<Widget>((country) => Chip(
                          label: Text(country['name'] ?? "Unknown"),
                          backgroundColor: Colors.grey.shade100,
                        ))
                    .toList(),
              )
            else
              const Text("No country information available."),
            const SizedBox(height: 20),

            /// Copyright
            _buildSectionTitle("Copyright"),
            Text(
              content['copyright']?.toString() ?? "No copyright info.",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            /// Audio Bibles
            _buildSectionTitle("Audio Bibles"),
            if (audioBibles.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: audioBibles
                    .map<Widget>((audio) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            audio['nameLocal'] ?? "Unnamed",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ))
                    .toList(),
              )
            else
              const Text("No audio Bibles available."),

            const SizedBox(height: 40),

            /// Read Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final data = await BooksFetch.fetchBooksByBibleId(
                      bibleId: content['id']);
                  _books = data;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BibleBooksScreen(
                        books: _books,
                        translation: content,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.menu_book),
                label: const Text("Read"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Helper method for consistent section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
