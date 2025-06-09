import 'package:flutter/material.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/chapters_fetch.dart';
import 'package:holy_bible/modules/chapter/chapter_content_screen.dart';
import 'package:holy_bible/modules/search/search_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Map<String, dynamic> content = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holy Bible'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            const Text(
              'Welcome My Dear',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Bible Verse of the Day
            const Icon(
              Icons.menu_book,
              size: 100,
              color: Colors.purpleAccent,
            ),
            const SizedBox(height: 20),
            const Text(
              textAlign: TextAlign.center,
              'Holy Bible',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              textAlign: TextAlign.center,
              'Explore the Word of God',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions Section
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            (CacheHelper.getData(key: 'bibleId') != null &&
                    CacheHelper.getData(key: 'bibleId').toString().isNotEmpty)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      (CacheHelper.getData(key: 'chapterId') != null &&
                              CacheHelper.getData(key: 'chapterId')
                                  .toString()
                                  .isNotEmpty)
                          ? _buildActionButton(
                              context,
                              icon: Icons.book,
                              label: 'Read Bible',
                              onPressed: () async {
                                await ChaptersFetch.fetchGetChapter(
                                        bibleId:
                                            CacheHelper.getData(key: 'bibleId'),
                                        chapterId: CacheHelper.getData(
                                            key: 'chapterId'))
                                    .then((data) {
                                  content = data;
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChapterContentScreen(
                                      content: content,
                                    ),
                                  ),
                                );
                              },
                            )
                          : SizedBox(
                              width: 200,
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.start,
                                  "You can't use the quick read as you didn't read any chapter!",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )),
                      _buildActionButton(
                        context,
                        icon: Icons.search,
                        label: 'Search',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "No Actions\nYou should select any translation",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // Helper method to build action buttons
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          iconSize: 40,
          color: Theme.of(context).colorScheme.primary,
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  // Helper method to build recent activity items
  Widget _buildRecentActivityItem(
    BuildContext context, {
    required String book,
    required int chapter,
    required int verse,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.bookmark, color: Colors.brown),
        title: Text('$book $chapter:$verse'),
        subtitle: const Text('Last read 2 days ago'),
        onTap: () {
          // Navigate to the specific verse
        },
      ),
    );
  }
}
