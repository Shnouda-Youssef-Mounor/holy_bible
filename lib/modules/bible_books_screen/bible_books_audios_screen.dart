import 'package:flutter/material.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/chapters_audios_fetch.dart';
import 'package:holy_bible/modules/chapter/chapter_audio_screen.dart';

class BibleBooksAudiosScreen extends StatelessWidget {
  final List<dynamic> books;
  final Map<String, dynamic> translation;

  BibleBooksAudiosScreen({
    super.key,
    required this.books,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> chapters = [];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(translation['nameLocal']),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: books.isEmpty
          ? const Center(
              child: Text(
                "No books available.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: GridView.builder(
                itemCount: books.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final book = books[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1),
                    duration: Duration(milliseconds: 300 + (index * 40)),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: GestureDetector(
                      onTap: () async {
                        if (book['bibleId'] != null && book['id'] != null) {
                          final data = await ChaptersAudiosFetch.fetchChapters(
                            bibleId: book['bibleId'],
                            bookId: book['id'],
                          );
                          chapters = data;
                          CacheHelper.saveData(
                              key: "audioBookId", value: book['id']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChapterAudioScreen(
                                chapters: chapters,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please try again later."),
                            ),
                          );
                        }
                      },
                      child: Card(
                        elevation: 4,
                        shadowColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.menu_book_rounded,
                                size: 40,
                                color: Colors.deepPurple,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                book["name"] ?? "Unknown Book",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book["abbreviation"] ?? "",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
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
            ),
    );
  }
}
