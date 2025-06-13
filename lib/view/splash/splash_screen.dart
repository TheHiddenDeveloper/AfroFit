import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/view/on_boarding/on_boarding_screen.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/services/sharedPref_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkInitialRoute();
  }

  Future<void> _checkInitialRoute() async {
    // Add splash screen delay
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Check if onboarding was completed
    final bool isOnboardingComplete =
        await SharedPrefsService().isOnboardingComplete();

    // Check if user is logged in
    final currentUser = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (!isOnboardingComplete) {
      // If onboarding not complete, show onboarding
      Navigator.pushReplacementNamed(context, OnBoardingScreen.routeName);
    } else if (currentUser == null) {
      // If onboarding complete but not logged in, show signup
      Navigator.pushReplacementNamed(context, SignupScreen.routeName);
    } else {
      // If logged in, go to dashboard
      Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // or use Theme.of(context).colorScheme.background
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
