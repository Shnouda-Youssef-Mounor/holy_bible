import 'package:flutter/material.dart';
import 'package:holy_bible/api/api_response.dart';
import 'package:holy_bible/modules/home/home_screen.dart';
import 'package:holy_bible/modules/translations/translations_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Track the selected navigation bar index
  List<dynamic> translations = []; // List to store translations
  bool isLoading = true;
  List<Widget> _screens = [
    HomeScreen(),
    TranslationsScreen(translations: []),
  ]; // Define the screens list

  @override
  void initState() {
    super.initState();
    // Fetch translations data
    ApiResponse.fetchTranslations().then((data) {
      setState(() {
        isLoading = false;
        translations = data;
        // Initialize the screens after translations are fetched
        _screens = [
          HomeScreen(),
          TranslationsScreen(translations: translations),
        ];
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.purple,
              semanticsValue: "Loading",
              strokeAlign: 2,
              strokeWidth: 10,
              semanticsLabel: "Loading",
              backgroundColor: Colors.black,
            ))
          : _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: 'Translations',
          ),
        ],
      ),
    );
  }
}
