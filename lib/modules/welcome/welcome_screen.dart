import 'package:flutter/material.dart';
import 'package:holy_bible/modules/main/main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.deepPurple],
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 256,
              ),
              Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.menu_book,
                        size: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Holy Bible',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Explore the Word of God',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Center(
                      child: Text(
                    "Developed By Shino",
                    style: TextStyle(
                      fontSize: 10.0, // Larger font size
                      fontWeight: FontWeight.bold, // Bold text for emphasis
                      color: Colors.white60, // Text color
                      letterSpacing: 0.5, // Slight letter spacing
                    ),
                  )))
            ],
          ),
        ),
      ),
    );
  }
}
