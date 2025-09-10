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
// Import your UserController
import 'package:fitnessapp/controllers/user_controller.dart'; // Adjust import path as needed

class DashboardScreen extends StatefulWidget {
  static String routeName = "/DashboardScreen";

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectTab = 0;

  // Get the UserController instance
  late final UserController userController;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ActivityScreen(),
    const ProgressPhotoScreen(),
    const UserProfile()
  ];

  @override
  void initState() {
    super.initState();
    // Initialize or get existing UserController instance
    userController = Get.find<UserController>();

    // Load user profile when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayColor,
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              const SizedBox(height: 24),
              _buildStatsSection(),
              const SizedBox(height: 24),
              _buildGoalsSection(),
              const SizedBox(height: 24),
              _buildQuickActionsSection(),
              const SizedBox(height: 24),
              _buildRecommendationsSection(),
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.whiteColor,
      child: Column(
        children: [
          // Custom Drawer Header with dynamic user data
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.primaryG,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Avatar
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Dynamic User Name using Obx for reactive updates
                    Obx(() {
                      final user = userController.user;
                      String displayName = 'Welcome User';

                      if (user?.firstName != null || user?.lastName != null) {
                        displayName =
                            '${user?.firstName ?? ''} ${user?.lastName ?? ''}'
                                .trim();
                        if (displayName.isEmpty) {
                          displayName = 'Welcome User';
                        }
                      }

                      return Text(
                        displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }),

                    const SizedBox(height: 4),

                    // User Goal/Status - also dynamic
                    Obx(() {
                      final user = userController.user;
                      String status = 'Fitness Enthusiast';

                      if (user?.goal != null && user!.goal!.isNotEmpty) {
                        status = user.goal!;
                      }

                      return Text(
                        status,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // Menu Items (rest remains the same)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 16),

                _buildDrawerItem(
                  icon: Icons.home_outlined,
                  title: 'Dashboard',
                  isSelected: true,
                  onTap: () => Navigator.pop(context),
                ),

                _buildDrawerItem(
                  icon: Icons.fitness_center_outlined,
                  title: 'Workouts',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/workout');
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.restaurant_outlined,
                  title: 'Nutrition',
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(NutritionScreen.routeName);
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.video_library_outlined,
                  title: 'Videos',
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(VideoScreen.routeName);
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.photo_camera_outlined,
                  title: 'Progress Photos',
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(ProgressPhotoScreen.routeName);
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(UserProfile.routeName);
                  },
                ),

                const SizedBox(height: 16),

                // Divider
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 1,
                  color: Colors.grey.shade200,
                ),

                const SizedBox(height: 16),

                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to help
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  textColor: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog();
                  },
                ),
              ],
            ),
          ),

          // App Version
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'AfroFit v1.0.0',
              style: TextStyle(
                color: AppColors.grayColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor1.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isSelected
                ? AppColors.primaryColor1
                : textColor ?? AppColors.grayColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? AppColors.blackColor
                : textColor ?? AppColors.blackColor,
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: isSelected
            ? AppColors.primaryColor1.withOpacity(0.05)
            : Colors.transparent,
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.grayColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Perform logout logic
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
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
      title: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.primaryG),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'AfroFit',
            style: TextStyle(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none,
                color: AppColors.blackColor),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: AppColors.blackColor),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryG,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor1.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dynamic welcome message
                Obx(() {
                  final user = userController.user;
                  String welcomeName = 'User';

                  if (user?.firstName != null && user!.firstName!.isNotEmpty) {
                    welcomeName = user.firstName!;
                  }

                  return Text(
                    'Welcome back, $welcomeName!',
                    style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Text(
                  'Ready for today\'s workout?',
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.9),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.whiteColor.withOpacity(0.2),
              border:
                  Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
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
        const Text(
          'Today\'s Stats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 16),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grayColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grayColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grayColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Goals',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildGoalCard('Watch Fitness Videos',
            'Complete 3 workout videos today', 60, Icons.video_library),
        const SizedBox(height: 12),
        _buildGoalCard('Improve Shape', 'Target: Lose 5kg in 2 months', 75,
            Icons.trending_up),
        const SizedBox(height: 12),
        _buildGoalCard('Stay Hydrated', 'Drink 8 glasses of water daily', 40,
            Icons.water_drop),
      ],
    );
  }

  Widget _buildGoalCard(
      String title, String subtitle, int progress, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grayColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.primaryG),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.whiteColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.grayColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: AppColors.lightGrayColor,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor1),
                  minHeight: 6,
                ),
                const SizedBox(height: 6),
                Text(
                  '$progress% Complete',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.grayColor,
                    fontWeight: FontWeight.w500,
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
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 16),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.whiteColor,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
        const Text(
          'Recommendations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildRecommendationCard(
          'Stay Hydrated!',
          'Drink at least 2L of water daily for optimal performance',
          Icons.water_drop,
          AppColors.primaryG,
        ),
        const SizedBox(height: 12),
        _buildRecommendationCard(
          'Post-Meal Walk',
          'Try a 30-minute walk after meals to aid digestion',
          Icons.directions_walk,
          AppColors.secondaryG,
        ),
        const SizedBox(height: 12),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grayColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.whiteColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.grayColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
