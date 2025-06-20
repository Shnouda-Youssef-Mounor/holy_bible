import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:holy_bible/api/api_response.dart';
import 'package:holy_bible/api/audio_bibles_fetch.dart';
import 'package:holy_bible/audios/audios_languages_screen.dart';
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
  List<dynamic> audios = [];
  bool isLoading = true;
  List<Widget> _screens = [
    HomeScreen(),
    TranslationsScreen(translations: []),
    AudiosLanguagesScreen(audios: []),
  ]; // Define the screens list
  String token = dotenv.env['API_TOKEN'] ?? "";

  @override
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final translationsData = await ApiResponse.fetchTranslations();
    final audiosData = await AudioBiblesFetch.fetchBible(token);

    setState(() {
      translations = translationsData;
      audios = audiosData;
      isLoading = false;
      _screens = [
        HomeScreen(),
        TranslationsScreen(translations: translations),
        AudiosLanguagesScreen(audios: audios),
      ];
    });
  }

  void _onItemTapped(int index) {
    if (isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.hourglass_bottom, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text("Please wait, data is still loading...")),
            ],
          ),
          backgroundColor: Colors.deepPurple,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        iconSize: 26,
        showUnselectedLabels: true,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey.shade400,
        items: [
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.home_outlined, 0),
            activeIcon: _buildActiveNavIcon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.language_outlined, 1),
            activeIcon: _buildActiveNavIcon(Icons.language),
            label: 'Translations',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.headphones_outlined, 2),
            activeIcon: _buildActiveNavIcon(Icons.headphones),
            label: 'Audios',
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return Icon(
      icon,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildActiveNavIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.deepPurple,
        size: 26,
      ),
    );
  }
}
