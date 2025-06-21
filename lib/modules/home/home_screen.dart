import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/chapters_audios_fetch.dart';
import 'package:holy_bible/api/chapters_fetch.dart';
import 'package:holy_bible/modules/chapter/chapter_content_audio_screen.dart';
import 'package:holy_bible/modules/chapter/chapter_content_screen.dart';
import 'package:holy_bible/modules/search/search_screen.dart';
import 'package:holy_bible/widgets/animated_action_button.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  Map<String, dynamic> content = {};

  @override
  Widget build(BuildContext context) {
    final hasBible = CacheHelper.getData(key: 'bibleId') != null &&
        CacheHelper.getData(key: 'bibleId').toString().isNotEmpty;
    final hasChapter = CacheHelper.getData(key: 'chapterId') != null &&
        CacheHelper.getData(key: 'chapterId').toString().isNotEmpty;
    String token = dotenv.env['API_TOKEN'] ?? "";

    final hasBibleAudio = CacheHelper.getData(key: 'audioBibleId') != null &&
        CacheHelper.getData(key: 'audioBibleId').toString().isNotEmpty;
    final hasChapterAudio =
        CacheHelper.getData(key: 'audioChapterId') != null &&
            CacheHelper.getData(key: 'audioChapterId').toString().isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holy Bible'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: Hero(
          flightShuttleBuilder:
              (flightContext, animation, direction, fromContext, toContext) {
            return ScaleTransition(
              scale: animation.drive(Tween(begin: 0.8, end: 1.2)
                  .chain(CurveTween(curve: Curves.easeInOut))),
              child: Icon(Icons.star, size: 100, color: Colors.amber),
            );
          },
          placeholderBuilder: (context, size, child) {
            return Opacity(
              opacity: 0.3,
              child: child,
            );
          },
          createRectTween: (begin, end) {
            return MaterialRectArcTween(
                begin: begin, end: end); // حركة منحنية بدلاً من خط مستقيم
          },
          tag: 'holyBible',
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Animated header
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Column(
                    children: const [
                      Text(
                        'Welcome My Dear',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Icon(Icons.menu_book,
                          size: 100, color: Colors.purpleAccent),
                      SizedBox(height: 20),
                      Text(
                        'Holy Bible',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Explore the Word of God',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 16),

                hasBible || hasBibleAudio
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: hasChapter
                                ? AnimatedActionButton(
                                    icon: Icons.book,
                                    label: 'Read Bible',
                                    onPressed: () async {
                                      final data =
                                          await ChaptersFetch.fetchGetChapter(
                                        token: token,
                                        bibleId:
                                            CacheHelper.getData(key: 'bibleId'),
                                        chapterId: CacheHelper.getData(
                                            key: 'chapterId'),
                                      );
                                      content = data;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChapterContentScreen(
                                              content: content),
                                        ),
                                      );
                                    },
                                  )
                                : _buildDisabledMessage(
                                    "You can't use the quick read as you didn't read any chapter!"),
                          ),
                          const SizedBox(height: 16),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: hasBibleAudio && hasChapterAudio
                                ? AnimatedActionButton(
                                    icon: Icons.headphones,
                                    label: 'Listen Bible',
                                    onPressed: () async {
                                      final data = await ChaptersAudiosFetch
                                          .fetchGetChapter(
                                        token: token,
                                        bibleId: CacheHelper.getData(
                                            key: 'audioBibleId'),
                                        chapterId: CacheHelper.getData(
                                            key: 'audioChapterId'),
                                      );
                                      content = data;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              ChapterContentAudioScreen(
                                                  content: content),
                                        ),
                                      );
                                    },
                                  )
                                : _buildDisabledMessage(
                                    "You can't use the quick listen as you didn't listen any chapter!"),
                          ),
                          const SizedBox(height: 16),
                          if (hasBible)
                            AnimatedActionButton(
                              icon: Icons.search,
                              label: 'Search',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SearchScreen()),
                                );
                              },
                            ),
                        ],
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "No Actions\nYou should select any translation",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ],
            ),
          )),
    );
  }

  Widget _buildModernActionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          shadowColor: Colors.deepPurple.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildDisabledMessage(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Column(
        children: [
          Material(
            shape: const CircleBorder(),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: IconButton(
              icon: Icon(icon),
              iconSize: 40,
              color: Colors.purple,
              onPressed: onPressed,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
