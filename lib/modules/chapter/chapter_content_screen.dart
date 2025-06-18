import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/api/chapters_fetch.dart';

class ChapterContentScreen extends StatefulWidget {
  final Map<String, dynamic> content;

  const ChapterContentScreen({super.key, required this.content});

  @override
  State<ChapterContentScreen> createState() => _ChapterContentScreenState();
}

class _ChapterContentScreenState extends State<ChapterContentScreen> {
  late Map<String, dynamic> content;
  double _fontSize = 18.0;
  double _lineHeight = 1.6;
  TextDirection _textDirection = TextDirection.rtl;

  @override
  void initState() {
    super.initState();
    content = widget.content;
  }

  void _updateContent(String chapterId) async {
    final data = await ChaptersFetch.fetchGetChapter(
      bibleId: content['bibleId'],
      chapterId: chapterId,
    );
    setState(() {
      content = data;
      CacheHelper.saveData(key: "chapterId", value: chapterId);
      CacheHelper.saveData(key: "bibleId", value: content['bibleId']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          child: Text(content['reference'] ?? ""),
        ),
        actions: [
          Tooltip(
              message: "Increase font",
              child: IconButton(
                  icon: const Icon(Icons.text_increase),
                  onPressed: () => setState(() => _fontSize += 2))),
          Tooltip(
              message: "Decrease font",
              child: IconButton(
                  icon: const Icon(Icons.text_decrease),
                  onPressed: () => setState(() => _fontSize -= 2))),
          Tooltip(
              message: "Increase line height",
              child: IconButton(
                  icon: const Icon(Icons.format_line_spacing),
                  onPressed: () => setState(() => _lineHeight =
                      (_lineHeight < 2.8) ? _lineHeight + 0.1 : _lineHeight))),
          Tooltip(
              message: "Decrease line height",
              child: IconButton(
                  icon: const Icon(Icons.format_line_spacing_outlined),
                  onPressed: () => setState(() => _lineHeight =
                      (_lineHeight > 1.2) ? _lineHeight - 0.1 : _lineHeight))),
          Tooltip(
              message: "Toggle direction",
              child: IconButton(
                  icon: const Icon(Icons.text_rotation_none),
                  onPressed: () => setState(() => _textDirection =
                      _textDirection == TextDirection.rtl
                          ? TextDirection.ltr
                          : TextDirection.rtl))),
        ],
      ),
      body: content.isEmpty
          ? const Center(child: Text("No Data"))
          : Column(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      child: Directionality(
                        textDirection: _textDirection,
                        child: Html(
                          data: content['content'],
                          style: {
                            "body": Style(
                              fontSize: FontSize(_fontSize),
                              color: Colors.black,
                              lineHeight: LineHeight(_lineHeight),
                              fontWeight: FontWeight.w500,
                            ),
                            "p": Style(
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                            ),
                            ".v": Style(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                            ".s1": Style(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: content['previous'] == null
                          ? null
                          : () => _updateContent(content['previous']['id']),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Previous"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: content['next'] == null
                          ? null
                          : () => _updateContent(content['next']['id']),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Next"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text("Adjust Line Height",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold)),
                      Slider(
                        value: _lineHeight,
                        min: 1.0,
                        max: 3.0,
                        divisions: 20,
                        label: _lineHeight.toStringAsFixed(1),
                        activeColor: Colors.purple,
                        onChanged: (value) =>
                            setState(() => _lineHeight = value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
