import 'dart:io';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/activity/activity_screen.dart';
import 'package:fitnessapp/view/progress/progress_photo_screen.dart';
import 'package:fitnessapp/view/profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitnessapp/routes.dart';
import '../home/home_screen.dart';
import 'package:fitnessapp/view/workout/workout_screen.dart';
import 'package:fitnessapp/view/nutrition/nutrition_screen.dart';
import 'package:fitnessapp/view/goals/goals_screen.dart';

class DashboardScreen extends StatefulWidget {
  static String routeName = "/DashboardScreen";

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectTab = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ActivityScreen(),
    const CameraScreen(),
    const UserProfile()
  ];

  void _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppColors.primaryG),
              ),
              child: const Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Workout'),
              onTap: () {
                Navigator.pushNamed(context, '/workout');
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text('Nutrition'),
              onTap: () {
                Navigator.pushNamed(context, '/nutrition');
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Goals'),
              onTap: () {
                Navigator.pushNamed(context, '/goals');
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Progress Photo'),
              onTap: () {
                Navigator.pushNamed(context, '/progress_photo');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
               Get.offAllNamed(UserProfile.routeName);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Recommendations Section
          Text(
            "Recommendations Based on Your Lifestyle",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.lightbulb_outline, color: Colors.orange),
              title: Text("Stay hydrated! Drink at least 2L of water daily."),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.directions_run, color: Colors.blue),
              title: Text("Try a 30-minute walk after meals."),
            ),
          ),
          const SizedBox(height: 16),
          // Tips Section
          Text(
            "Tips",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text("Set realistic goals and track your progress."),
            ),
          ),
          // ...add more tips as needed...
        ],
      ),
      // No bottomNavigationBar
    );
  }
}
