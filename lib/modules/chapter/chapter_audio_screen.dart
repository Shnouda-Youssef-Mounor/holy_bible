import 'package:flutter/material.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/chapters_audios_fetch.dart';
import 'package:holy_bible/modules/chapter/chapter_content_audio_screen.dart';

class ChapterAudioScreen extends StatefulWidget {
  final List<dynamic> chapters;
  const ChapterAudioScreen({super.key, required this.chapters});

  @override
  State<ChapterAudioScreen> createState() => _ChapterAudioScreenState();
}

class _ChapterAudioScreenState extends State<ChapterAudioScreen>
    with TickerProviderStateMixin {
  List<dynamic> dataChapters = [];
  Map<String, dynamic> verses = {};

  @override
  void initState() {
    super.initState();
    dataChapters = widget.chapters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "${widget.chapters[0]["reference"]}",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chapters",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[800],
              ),
            ),
            const SizedBox(height: 16),
            dataChapters.isEmpty
                ? const Center(
                    child: Text(
                      "No Data",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dataChapters.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisExtent: 200,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final chapter = dataChapters[index];
                      final AnimationController controller =
                          AnimationController(
                        vsync: this,
                        duration: const Duration(milliseconds: 500),
                      )..forward();

                      final Animation<double> animation = CurvedAnimation(
                          parent: controller, curve: Curves.easeOut);

                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: Card(
                            color: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () async {
                                await ChaptersAudiosFetch.fetchGetChapter(
                                  bibleId: chapter['bibleId'],
                                  chapterId: chapter['id'],
                                ).then((data) {
                                  verses = data;
                                });

                                CacheHelper.saveData(
                                  key: "audioChapterId",
                                  value: chapter['id'],
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChapterContentAudioScreen(
                                      content: verses,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.library_music_rounded,
                                      size: 40,
                                      color: Colors.purple,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${chapter["reference"]}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'ID: ${chapter["id"]}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
