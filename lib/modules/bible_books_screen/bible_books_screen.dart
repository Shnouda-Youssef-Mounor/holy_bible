import 'package:flutter/material.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/chapters_fetch.dart';
import 'package:holy_bible/api/sections_fetch.dart';
import 'package:holy_bible/modules/chapter/chapter_screen.dart';

class BibleBooksScreen extends StatefulWidget {
  final List<dynamic> books;
  final Map<String, dynamic> translation;

  const BibleBooksScreen({
    super.key,
    required this.books,
    required this.translation,
  });

  @override
  State<BibleBooksScreen> createState() => _BibleBooksScreenState();
}

class _BibleBooksScreenState extends State<BibleBooksScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> chapters = [];
  List<dynamic> sections = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward(); // Starts animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToChapters(Map<String, dynamic> book) async {
    if (book['bibleId'] != null && book['id'] != null) {
      final bibleId = book['bibleId'];
      final bookId = book['id'];

      chapters = await ChaptersFetch.fetchChapters(
        bibleId: bibleId,
        bookId: bookId,
      );
      await CacheHelper.saveData(key: "bookId", value: bookId);
      sections = await SectionsFetch.fetchChapterSection(
        bibleId: bibleId,
        bookId: bookId,
      );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChapterScreen(
            sections: sections,
            chapters: chapters,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please try again later.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final books = widget.books;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(books[0]['name']),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[50],
      body: books.isEmpty
          ? const Center(child: Text("No Data"))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];

                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _controller,
                    curve: Interval((index / books.length), 1.0,
                        curve: Curves.easeOutBack),
                  ),
                  child: GestureDetector(
                    onTap: () => _navigateToChapters(book),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu_book,
                              color: Colors.deepPurple, size: 36),
                          const SizedBox(height: 12),
                          Text(
                            book["name"] ?? "No Name",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            book["abbreviation"] ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
