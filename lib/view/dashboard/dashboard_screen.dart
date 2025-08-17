import 'dart:io';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/activity/activity_screen.dart';
import 'package:fitnessapp/view/progress_tracker/progress_photo_screen.dart';
import 'package:fitnessapp/view/profile/user_profile.dart';
import 'package:fitnessapp/view/videos/video_screen.dart' hide AppColors;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitnessapp/routes.dart';
import '../home/home_screen.dart';
import 'package:fitnessapp/view/workout/workout_screen.dart';
import 'package:fitnessapp/view/nutrition/nutrition_screen.dart';
//import 'package:fitnessapp/view/goals/goals_screen.dart';

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
    const ProgressPhotoScreen(),
    const UserProfile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayColor,
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 20),
            _buildStatsSection(),
            const SizedBox(height: 20),
            _buildGoalsSection(),
            const SizedBox(height: 20),
            _buildQuickActionsSection(),
            const SizedBox(height: 20),
            _buildRecommendationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
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
              Get.toNamed(NutritionScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('Videos'),
            onTap: () {
              Get.toNamed(VideoScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Progress Photo'),
            onTap: () {
              Get.toNamed(ProgressPhotoScreen.routeName);
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
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: AppColors.blackColor),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Text(
        'FitTracker',
        style: TextStyle(
          color: AppColors.blackColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon:
              const Icon(Icons.notifications_none, color: AppColors.blackColor),
          onPressed: () {
            // Navigate to notifications
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: AppColors.blackColor),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryG,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Alex!',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ready for today\'s workout?',
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.whiteColor.withOpacity(0.2),
            child: const Icon(
              Icons.person,
              size: 30,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Stats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildStatCard('Calories Burned', '450', 'kcal',
                    Icons.local_fire_department, AppColors.secondaryG)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildStatCard('Exercise Time', '45', 'min', Icons.timer,
                    AppColors.primaryG)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildStatCard('Steps Taken', '8,432', 'steps',
                    Icons.directions_walk, AppColors.secondaryG)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildStatCard('Water Intake', '1.2', 'L',
                    Icons.water_drop, AppColors.primaryG)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String unit, IconData icon,
      List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grayColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.whiteColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grayColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grayColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Goals',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 12),
        _buildGoalCard('Watch Fitness Videos',
            'Complete 3 workout videos today', 60, Icons.video_library),
        const SizedBox(height: 8),
        _buildGoalCard('Improve Shape', 'Target: Lose 5kg in 2 months', 75,
            Icons.trending_up),
        const SizedBox(height: 8),
        _buildGoalCard('Stay Hydrated', 'Drink 8 glasses of water daily', 40,
            Icons.water_drop),
      ],
    );
  }

  Widget _buildGoalCard(
      String title, String subtitle, int progress, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grayColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.primaryG),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.whiteColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grayColor,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: AppColors.lightGrayColor,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryColor1),
                ),
                const SizedBox(height: 4),
                Text(
                  '$progress% Complete',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.grayColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildActionButton(
                    'Start Workout', Icons.play_arrow, AppColors.primaryG)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildActionButton(
                    'Log Meal', Icons.restaurant_menu, AppColors.secondaryG)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildActionButton(
                    'Track Weight', Icons.monitor_weight, AppColors.primaryG)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildActionButton(
                    'View Progress', Icons.analytics, AppColors.secondaryG)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, List<Color> gradient) {
    return GestureDetector(
      onTap: () {
        // Handle button tap
        print('$title tapped');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.whiteColor,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 12),
        _buildRecommendationCard(
          'Stay Hydrated!',
          'Drink at least 2L of water daily for optimal performance',
          Icons.water_drop,
          AppColors.primaryG,
        ),
        const SizedBox(height: 8),
        _buildRecommendationCard(
          'Post-Meal Walk',
          'Try a 30-minute walk after meals to aid digestion',
          Icons.directions_walk,
          AppColors.secondaryG,
        ),
        const SizedBox(height: 8),
        _buildRecommendationCard(
          'Quality Sleep',
          'Get 7-8 hours of sleep for better recovery',
          Icons.bedtime,
          AppColors.primaryG,
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
      String title, String description, IconData icon, List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grayColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.whiteColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grayColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
