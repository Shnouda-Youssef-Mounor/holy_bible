import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:holy_bible/api/book_fetch_audio.dart';
import 'package:holy_bible/modules/bible_books_screen/bible_books_audios_screen.dart';

class BookContentAudioScreen extends StatelessWidget {
  final Map<String, dynamic> content;
  BookContentAudioScreen({super.key, required this.content});

  final List<dynamic> _books = [];
  String token = dotenv.env['API_TOKEN'] ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(content['nameLocal'].toString()),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderInfo(),
            const SizedBox(height: 16),
            _buildSectionTitle("Description"),
            Text(
              content['descriptionLocal'].toString(),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Language"),
            _buildInfoTile("Language", content['language']?['name']),
            _buildInfoTile(
                "Native Language", content['language']?['nameLocal']),
            _buildInfoTile("Script", content['language']?['script']),
            _buildInfoTile(
                "Script Direction", content['language']?['scriptDirection']),
            const SizedBox(height: 24),
            _buildSectionTitle("Countries Available"),
            ..._buildList(content['countries'], "name"),
            const SizedBox(height: 24),
            _buildSectionTitle("Copyright"),
            Text(
              content['copyright'].toString(),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Audio Bibles"),
            ..._buildList(content['audioBibles'], "nameLocal"),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await BookFetchAudio.fetchBooksByBibleId(
                          bibleId: content['id'], token: token)
                      .then((data) {
                    _books.addAll(data);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BibleBooksAudiosScreen(
                        books: _books,
                        translation: content,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_circle_fill),
                label: const Text("Play Audio Bible"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content['name'].toString(),
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                content['nameLocal'].toString(),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Abbreviation: ${content['abbreviation'] ?? "No Abbreviation"}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildInfoTile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(fontSize: 16, color: Colors.black),
          children: [
            TextSpan(
              text: value ?? "Not available",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildList(List? list, String key) {
    if (list == null || list.isEmpty) {
      return [
        const Text("None available",
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      ];
    }

    return list.map<Widget>((item) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          "- ${item[key] ?? "Unknown"}",
          style: const TextStyle(fontSize: 16),
        ),
      );
    }).toList();
  }
}
