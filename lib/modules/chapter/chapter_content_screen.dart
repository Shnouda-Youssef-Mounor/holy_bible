import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/chapters_fetch.dart';

class ChapterContentScreen extends StatefulWidget {
  final Map<String, dynamic> content;

  const ChapterContentScreen({
    super.key,
    required this.content,
  });

  @override
  _ChapterContentScreenState createState() => _ChapterContentScreenState();
}

class _ChapterContentScreenState extends State<ChapterContentScreen> {
  late Map<String, dynamic> content;
  double _fontSize = 16.0; // Default font size
  double _lineHeight = 1.5; // Default line height
  TextDirection _textDirection = TextDirection.rtl; // Default text direction

  @override
  void initState() {
    super.initState();
    content = widget.content;
  }

  void _increaseFontSize() {
    setState(() {
      _fontSize += 2.0;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      _fontSize -= 2.0;
    });
  }

  void _increaseLineHeight() {
    if (_lineHeight < 2.8) {
      setState(() {
        _lineHeight += 0.1;
      });
    }
  }

  void _decreaseLineHeight() {
    if (_lineHeight > 1.2) {
      setState(() {
        _lineHeight -= 0.1;
      });
    }
  }

  void _toggleTextDirection() {
    setState(() {
      _textDirection = _textDirection == TextDirection.rtl
          ? TextDirection.ltr
          : TextDirection.rtl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: _increaseFontSize,
          ),
          IconButton(
            icon: const Icon(Icons.text_decrease),
            onPressed: _decreaseFontSize,
          ),
          IconButton(
            icon: const Icon(Icons.format_line_spacing),
            onPressed: _increaseLineHeight,
          ),
          IconButton(
            icon: const Icon(Icons.format_line_spacing_outlined),
            onPressed: _decreaseLineHeight,
          ),
          IconButton(
            icon: const Icon(Icons.text_rotation_none),
            onPressed: _toggleTextDirection,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: content.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(
              children: [
                Center(
                  heightFactor: 2,
                  child: Text(
                    "${content['reference']}",
                    style: TextStyle(color: Colors.black45, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Directionality(
                      textDirection: _textDirection,
                      child: Html(
                        data: content['content'],
                        style: {
                          "body": Style(
                            fontSize: FontSize(_fontSize),
                            color: Colors.black,
                            lineHeight:
                                LineHeight(_lineHeight), // Apply line height
                          ),
                          "p": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          ".v": Style(
                            color: Colors.red, // Color for verse numbers
                            fontWeight: FontWeight.bold,
                          ),
                          ".s1": Style(
                            color: Colors.red, // Color for verse numbers
                            fontWeight: FontWeight.bold,
                          )
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: content['previous'] == null
                            ? null
                            : () async {
                                await ChaptersFetch.fetchGetChapter(
                                        bibleId: content['bibleId'],
                                        chapterId: content['previous']['id'])
                                    .then((data) {
                                  setState(() {
                                    content = data;
                                    CacheHelper.saveData(
                                        key: "chapterId",
                                        value: content['previous']['id']);
                                    CacheHelper.saveData(
                                        key: "bibleId",
                                        value: content['bibleId']);
                                  });
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12), // Adjust padding
                          textStyle:
                              const TextStyle(fontSize: 16), // Adjust font size
                          backgroundColor:
                              Colors.blue, // Customize background color
                          foregroundColor: Colors.white, // Customize text color
                          shape: RoundedRectangleBorder(
                            // Add rounded corners
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Previous"),
                      ),
                      ElevatedButton(
                        onPressed: content['next'] == null
                            ? null
                            : () async {
                                await ChaptersFetch.fetchGetChapter(
                                        bibleId: content['bibleId'],
                                        chapterId: content['next']['id'])
                                    .then((data) {
                                  setState(() {
                                    content = data;
                                    CacheHelper.saveData(
                                        key: "chapterId",
                                        value: content['next']['id']);
                                    CacheHelper.saveData(
                                        key: "bibleId",
                                        value: content['bibleId']);
                                  });
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          textStyle: const TextStyle(fontSize: 16),
                          backgroundColor:
                              Colors.green, // Different color for "Next"
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _lineHeight,
                  min: 1.0, // Minimum line height
                  max: 3.0, // Maximum line height
                  divisions: 20, // Number of steps
                  label: _lineHeight.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _lineHeight = value;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
