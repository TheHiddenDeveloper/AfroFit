import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/welcome/welcome_screen.dart';
import 'package:fitnessapp/controllers/user_controller.dart';
import 'package:fitnessapp/services/sharedPref_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../services/database_service.dart';

class YourGoalScreen extends StatefulWidget {
  static String routeName = "/YourGoalScreen";

  const YourGoalScreen({Key? key}) : super(key: key);

  @override
  State<YourGoalScreen> createState() => _YourGoalScreenState();
}

class _YourGoalScreenState extends State<YourGoalScreen> {
  // Fitness goal options with descriptions and images
  final List<Map<String, String>> pageList = [
    {
      "title": "Improve Shape",
      "subtitle":
          "I have a low amount of body fat\nand need / want to build more\nmuscle",
      "image": "assets/images/goal_1.png"
    },
    {
      "title": "Lean & Tone",
      "subtitle":
          "I'm skinny fat. look thin but have\nno shape. I want to add lean\nmuscle in the right way",
      "image": "assets/images/goal_2.png"
    },
    {
      "title": "Lose Fat",
      "subtitle":
          "I have over 20 lbs to lose. I want to\ndrop all this fat and gain muscle\nmass",
      "image": "assets/images/goal_3.png"
    }
  ];

  // Carousel controller for goal selection
  final CarouselSliderController carouselController =
      CarouselSliderController();

  // Current selected goal index
  int currentIndex = 0;

  // Loading state during save operation
  bool isSaving = false;

  /// Save selected goal and complete profile setup
  Future<void> _saveGoalAndNavigate() async {
    final goalTitle = pageList[currentIndex]["title"];
    if (goalTitle == null) return;

    setState(() => isSaving = true);

    try {
      // Save to legacy DatabaseService for backward compatibility
      final dbService = DatabaseService();
      await dbService.saveUserGoal(goalTitle);

      // Initialize UserController if not already done
      if (!Get.isRegistered<UserController>()) {
        Get.put(UserController(), permanent: true);
      }

      final userController = Get.find<UserController>();
      final currentUser = userController.user;

      if (currentUser != null) {
        // Update existing user profile with the selected goal
        final updatedUser = AppUser(
          firstName: currentUser.firstName,
          lastName: currentUser.lastName,
          goal: goalTitle, // Add the selected goal
          weight: currentUser.weight,
          height: currentUser.height,
          age: currentUser.age,
        );

        // Save complete profile to UserController (updates both Firestore and SharedPreferences)
        await userController.updateUserProfile(updatedUser);
      } else {
        // Fallback: If UserController doesn't have user data,
        // load from SharedPreferences and create complete profile
        final sharedPrefs = SharedPrefsService();
        final firstName = await sharedPrefs.getFirstName();
        final lastName = await sharedPrefs.getLastName();
        final weight = await sharedPrefs.getWeight();
        final height = await sharedPrefs.getHeight();
        final age = await sharedPrefs.getAge();

        if (firstName != null && lastName != null) {
          // Create complete user profile with goal
          final completeUser = AppUser(
            firstName: firstName,
            lastName: lastName,
            goal: goalTitle,
            weight: weight,
            height: height,
            age: age,
          );

          // Save to UserController
          await userController.updateUserProfile(completeUser);
        }
      }

      // Also update SharedPreferences directly to ensure consistency
      final sharedPrefs = SharedPrefsService();
      final firstName = await sharedPrefs.getFirstName();
      final lastName = await sharedPrefs.getLastName();
      final weight = await sharedPrefs.getWeight();
      final height = await sharedPrefs.getHeight();
      final age = await sharedPrefs.getAge();

      // Save complete profile with goal to SharedPreferences
      if (firstName != null &&
          lastName != null &&
          weight != null &&
          height != null &&
          age != null) {
        await sharedPrefs.saveUserProfile(
          firstName: firstName,
          lastName: lastName,
          height: height,
          weight: weight,
          age: age,
          goal: goalTitle, // Include the selected goal
        );
      }

      // Show success message
      Get.snackbar("Success", "Profile setup completed successfully!",
          snackPosition: SnackPosition.BOTTOM);

      // Navigate to main app (WelcomeScreen or Home)
      Get.offAllNamed(WelcomeScreen.routeName);
    } catch (e) {
      // Handle and display errors
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      print("Error saving goal: $e");
    }

    setState(() => isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Carousel slider for goal selection
            Center(
              child: CarouselSlider(
                carouselController: carouselController,
                items: pageList.map((obj) {
                  return Container(
                    // Gradient background for each goal card
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        colors: AppColors.primaryG,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      vertical: media.width * 0.01,
                      horizontal: 25,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Goal illustration image
                        Image.asset(
                          obj["image"]!,
                          width: media.width * 0.5,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(height: 10),

                        // Goal title
                        Text(
                          obj["title"]!,
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),

                        // Divider line
                        Container(
                            width: 50, height: 1, color: AppColors.whiteColor),
                        const SizedBox(height: 8),

                        // Goal description
                        Text(
                          obj["subtitle"]!,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: media.height * 0.55,
                  enlargeCenterPage: true, // Make center card bigger
                  enableInfiniteScroll: false, // Don't loop infinitely
                  initialPage: 0, // Start with first goal
                  viewportFraction: 0.75, // Show parts of adjacent cards
                  // Update current index when user swipes
                  onPageChanged: (index, reason) =>
                      setState(() => currentIndex = index),
                ),
              ),
            ),

            // Header and confirmation button overlay
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  // Screen title
                  const Text(
                    "What is your goal?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Screen subtitle
                  const Text(
                    "It will help us to choose the best\nprogram for you",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grayColor,
                      fontSize: 12,
                      fontFamily: "Poppins",
                    ),
                  ),

                  // Push confirmation button to bottom
                  const Spacer(),

                  // Confirm goal selection button
                  RoundGradientButton(
                    title: isSaving ? "Saving..." : "Confirm",
                    onPressed: isSaving ? null : _saveGoalAndNavigate,
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
