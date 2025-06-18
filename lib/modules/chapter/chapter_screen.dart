import 'package:flutter/material.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/chapters_fetch.dart';
import 'package:holy_bible/modules/chapter/chapter_content_screen.dart';

class ChapterScreen extends StatefulWidget {
  final List<dynamic> chapters;
  final List<dynamic> sections;

  const ChapterScreen({
    super.key,
    required this.chapters,
    required this.sections,
  });

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  Map<String, dynamic> verses = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToChapterContent({
    required String bibleId,
    required String chapterId,
  }) async {
    verses = await ChaptersFetch.fetchGetChapter(
      bibleId: bibleId,
      chapterId: chapterId,
    );
    await CacheHelper.saveData(key: "chapterId", value: chapterId);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChapterContentScreen(content: verses),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chapters = widget.chapters;
    final sections = widget.sections;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${chapters[0]["reference"]}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Chapters"),
              const SizedBox(height: 12),
              _buildChaptersGrid(chapters),
              const SizedBox(height: 32),
              _buildSectionTitle("Sections"),
              const SizedBox(height: 12),
              _buildSectionsList(sections),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple[800],
      ),
    );
  }

  Widget _buildChaptersGrid(List<dynamic> chapters) {
    if (chapters.isEmpty) {
      return const Center(
        child: Text(
          "No Data",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chapters.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: 200,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return AnimatedScale(
          duration: const Duration(milliseconds: 400),
          scale: 1,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () => _navigateToChapterContent(
                bibleId: chapter['bibleId'],
                chapterId: chapter['id'],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book, size: 28, color: Colors.purple[300]),
                    const SizedBox(height: 10),
                    Text(
                      chapter["reference"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${chapter["id"]}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionsList(List<dynamic> sections) {
    if (sections.isEmpty) {
      return const Center(
        child: Text(
          "No Sections",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sections.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final section = sections[index];
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500 + index * 100),
          opacity: 1,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Icon(Icons.list_alt_rounded,
                  size: 30, color: Colors.deepPurple[400]),
              title: Text(
                section["title"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${section["firstVerseId"]} - ${section["lastVerseId"]}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () async {
                final parts = section['firstVerseId'].split('.');
                final chapterId = '${parts[0]}.${parts[1]}';

                await _navigateToChapterContent(
                  bibleId: section['bibleId'],
                  chapterId: chapterId,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
