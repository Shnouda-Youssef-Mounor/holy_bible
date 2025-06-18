import 'package:flutter/material.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/chapters_audios_fetch.dart';
import 'package:holy_bible/widgets/audio_player_screen.dart';

class ChapterContentAudioScreen extends StatefulWidget {
  final Map<String, dynamic> content;

  const ChapterContentAudioScreen({
    super.key,
    required this.content,
  });

  @override
  _ChapterContentAudioScreenState createState() =>
      _ChapterContentAudioScreenState();
}

class _ChapterContentAudioScreenState extends State<ChapterContentAudioScreen> {
  late Map<String, dynamic> content;

  @override
  void initState() {
    super.initState();
    content = widget.content;
  }

  Future<void> loadChapter(String chapterId) async {
    final bibleId = content['bibleId'];
    try {
      final data = await ChaptersAudiosFetch.fetchGetChapter(
        bibleId: bibleId,
        chapterId: chapterId,
      );
      setState(() {
        content = data;
      });
      CacheHelper.saveData(key: "audioChapterId", value: chapterId);
      CacheHelper.saveData(key: "audioBibleId", value: bibleId);
    } catch (e) {
      // optional: handle error
      print("Failed to load chapter: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final reference = content['reference'] ?? "Reference not found";
    final copyright = content['copyright'] ?? "";
    final chapterNumber = content['number'] ?? "";
    final bookId = content['bookId'] ?? "";
    final nextChapter = content['next']?['number'];
    final audioUrl = content['resourceUrl'];

    return Scaffold(
      appBar: AppBar(
        title: Text("$reference"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: content.isEmpty
          ? const Center(child: Text("No Data"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Audio Player
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      height: 500,
                      color: Colors.purple.shade50,
                      child: AudioPlayerScreen(
                        content: content,
                        onNavigate: (chapterId) => loadChapter(chapterId),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Copyright Footer
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        copyright,
                        style: const TextStyle(
                          fontSize: 5,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
