import 'package:flutter/material.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/chapters_fetch.dart';
import 'package:holy_bible/modules/chapter/chapter_content_screen.dart';

class ChapterScreen extends StatelessWidget {
  final List<dynamic> chapters;
  final List<dynamic> sections;
  const ChapterScreen(
      {super.key, required this.chapters, required this.sections});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> verses = {};
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${chapters[0]["reference"]}",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chapters Grid
            Text(
              "Chapters",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[800],
              ),
            ),
            const SizedBox(height: 16),
            chapters.isEmpty
                ? const Center(
                    child: Text(
                      "No Data",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: chapters.length,
                    itemBuilder: (context, index) {
                      final chapter = chapters[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () async {
                            await ChaptersFetch.fetchGetChapter(
                                    bibleId: chapter['bibleId'],
                                    chapterId: chapter['id'])
                                .then((data) {
                              verses = data;
                            });
                            CacheHelper.saveData(
                                key: "chapterId", value: chapter['id']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChapterContentScreen(content: verses),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${chapter["reference"]}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Book: ${chapter["id"]}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 24),
            // Sections List
            Text(
              "Sections",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[800],
              ),
            ),
            const SizedBox(height: 16),
            sections.isEmpty
                ? const Center(
                    child: Text(
                      "No Sections",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sections.length,
                    itemBuilder: (context, index) {
                      final section = sections[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          leading: Icon(
                            Icons.list,
                            size: 30,
                            color: Colors.deepPurple[300],
                          ),
                          title: Text(
                            section["title"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${section["firstVerseId"]} - ${section["lastVerseId"]}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              List<String> parts =
                                  section['firstVerseId'].split('.');
                              String text = '${parts[0]}.${parts[1]}';
                              await ChaptersFetch.fetchGetChapter(
                                      bibleId: section['bibleId'],
                                      chapterId: text)
                                  .then((data) {
                                verses = data;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChapterContentScreen(content: verses),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward_rounded),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
