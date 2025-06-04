import 'dart:async';
import 'package:fitnessapp/view/on_boarding/on_boarding_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to onboarding screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // or use Theme.of(context).colorScheme.background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 👇 Place your splash image or logo here
            Image.asset(
              'assets/images/spl_img.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            // 👇 Optional: App name or loading indicator
          ],
        ),
      ),
    );
  }
}
