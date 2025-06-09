import 'package:flutter/material.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/chapters_fetch.dart';
import 'package:holy_bible/api/search_fetch.dart';
import 'package:holy_bible/modules/chapter/chapter_content_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  Map<String, dynamic> searchData = {};
  bool isLoading = false;
  bool isEmpty = true;
  List<dynamic> verses = [];
  Map<String, dynamic> content = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFormField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  isEmpty = value.isEmpty ? true : false;
                });
              },
              maxLines: 1,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                      borderRadius: BorderRadius.circular(12)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.deepPurple,
                  ),
                  suffixIcon: isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              _searchController.text = '';
                              isEmpty = true;
                              searchData = {};
                              verses = [];
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.purple,
                          ))),
            ),
            const SizedBox(
              height: 16,
            ),
            if (isLoading == false)
              Center(
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await SearchFetch.fetchForSearch(
                            bibleId:
                                CacheHelper.getData(key: "bibleId").toString(),
                            text: _searchController.text)
                        .then((data) {
                      setState(() {
                        isLoading = false;
                        searchData = data;
                        verses = searchData['verses'];
                      });
                    }).catchError((err) {
                      isLoading = false;
                      debugPrint(err);
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.purple, // Background color
                    padding: EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 12.0), // Padding
                    shape: RoundedRectangleBorder(
                      // Rounded corners
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5, // Shadow/elevation for depth
                  ),
                  child: Text(
                    "Go",
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 18.0, // Font size
                      fontWeight: FontWeight.bold, // Font weight
                    ),
                  ),
                ),
              ),
            Center(
              heightFactor: 3,
              child: Text(
                "Search Information",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple)),
              child: searchData.isEmpty
                  ? Center(
                      child: Text(
                        "No Search Information",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "For ${searchData['query']}",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Limit",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    "${searchData['limit']}",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Total",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    "${searchData['total']}",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Verses",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    "${searchData['verseCount']}",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              height: 8,
              color: Colors.purple,
            ),
            const SizedBox(
              height: 16,
            ),
            Center(
              heightFactor: 1,
              child: Text(
                "Verses",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800],
                ),
              ),
            ),
            const SizedBox(height: 16),
            verses.isEmpty
                ? const Center(
                    child: Text(
                      "No results",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: verses.length,
                    itemBuilder: (context, index) {
                      final section = verses[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          title: Text(
                            section["text"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${section["reference"]}}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await ChaptersFetch.fetchGetChapter(
                                      bibleId: section['bibleId'],
                                      chapterId: section['chapterId'])
                                  .then((data) {
                                content = data;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChapterContentScreen(content: content),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward_rounded),
                          ),
                        ),
                      );
                    },
                  ),
          ])),
    );
  }
}
