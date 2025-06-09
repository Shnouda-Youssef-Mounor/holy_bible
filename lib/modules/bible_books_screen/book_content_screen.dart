import 'package:flutter/material.dart';
import 'package:holy_bible/api/books_fetch.dart';
import 'package:holy_bible/modules/bible_books_screen/bible_books_screen.dart';

class BookContentScreen extends StatelessWidget {
  final Map<String, dynamic> content;
  BookContentScreen({super.key, required this.content});
  // Sample book data
  List<dynamic> _books = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(content['nameLocal'].toString()),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Abbreviation
              Text(
                content['name'].toString(), // Null check for 'name'
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  textAlign: TextAlign.end,
                  content['nameLocal'].toString(), // Null check for 'name'
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Abbreviation: ${content['abbreviation'] ?? "No Abbreviation"}', // Null check for 'abbreviation'
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),

              // Description
              Text(
                'Description:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(content['descriptionLocal'].toString(),
                  style: TextStyle(fontSize: 16)), // Null check for description
              SizedBox(height: 20),

              // Language Info
              Text(
                'Language:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Language: ${content['language']!['name'] ?? "No Language"} (${content['language']?['nameLocal'] ?? "No Language Local"})', // Null-safe access for nested fields
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Script: ${content['language']?['script'] ?? "No Script"}', // Null-safe access for script
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Script Direction: ${content['language']?['scriptDirection'] ?? "No Script Direction"}', // Null-safe access for scriptDirection
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Country Info
              Text(
                'Countries Available:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (content['countries'] !=
                  null) // Check if 'countries' is not null
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (content['countries'] as List)
                      .map<Widget>((country) => Text(
                            country['name'] ??
                                "No Country", // Null check for 'name' in country
                            style: TextStyle(fontSize: 16),
                          ))
                      .toList(),
                ),
              SizedBox(height: 20),

              // Copyright Info
              Text(
                'Copyright Information:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(content['copyright'].toString(),
                  style: TextStyle(fontSize: 16)), // Null check for copyright
              SizedBox(height: 20),
              // Audio Bible Info
              Text(
                'Audio Bible Available:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (content['audioBibles'] !=
                  null) // Check if 'audioBibles' is not null
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (content['audioBibles'] as List)
                      .map<Widget>((audio) => Text(
                            audio['nameLocal'] ??
                                "No Audio", // Null check for 'nameLocal' in audio
                            style: TextStyle(fontSize: 16),
                          ))
                      .toList(),
                ),
              SizedBox(height: 64),
              ElevatedButton(
                onPressed: () async {
                  await BooksFetch.fetchBooksByBibleId(bibleId: content['id'])
                      .then((data) {
                    _books = data;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BibleBooksScreen(
                        books: _books,
                        translation: content,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14), // Adjust padding
                  textStyle: const TextStyle(fontSize: 18), // Adjust font size
                  backgroundColor: Colors.orange, // Or any color you prefer
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  elevation: 5, // Add a subtle shadow
                ),
                child: const Text("Read"),
              ),
              SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }
}
