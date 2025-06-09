import 'package:flutter/material.dart';
import 'package:holy_bible/Helper/cache_helper.dart';
import 'package:holy_bible/modules/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await CacheHelper.init(); // Initialize SharedPreferences
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Holy Bible', // Default to system theme
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const WelcomeScreen(),
    );
  }
}
