import 'package:flutter/material.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/chapters_fetch.dart';
import 'package:holy_bible/api/sections_fetch.dart';
import 'package:holy_bible/modules/chapter/chapter_screen.dart';

class BibleBooksScreen extends StatelessWidget {
  final List<dynamic> books;
  final Map<String, dynamic> translation;
  BibleBooksScreen({super.key, required this.books, required this.translation});

  @override
  Widget build(BuildContext context) {
    List<dynamic> chapters = [];
    List<dynamic> sections = [];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Books of the Bible"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: (books.isEmpty)
          ? Center(
              child: Text("No Data"),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220, // Maximum width of each grid item
                crossAxisSpacing: 1.0, // Space between cards horizontally
                mainAxisSpacing: 4.0, // Space between cards vertically
                childAspectRatio:
                    1, // Adjust this based on your desired aspect ratio
              ),
              padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 1,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      book["name"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      book["abbreviation"]!,
                      textAlign: TextAlign.center,
                    ),
                    onTap: () async {
                      // Handle translation selection
                      await ChaptersFetch.fetchChapters(
                              bibleId: book['bibleId'], bookId: book['id'])
                          .then((data) {
                        chapters = data;
                      });
                      CacheHelper.saveData(key: "bookId", value: book['id']);
                      await SectionsFetch.fetchChapterSection(
                              bibleId: book['bibleId'], bookId: book['id'])
                          .then((data) {
                        sections = data;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterScreen(
                            sections: sections,
                            chapters: chapters,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
