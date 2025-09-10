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
          "I have a low amount of body fat and need / want to build more muscle",
      "image": "assets/images/goal_1.png",
      "color": "primary"
    },
    {
      "title": "Lean & Tone",
      "subtitle":
          "I'm skinny fat. Look thin but have no shape. I want to add lean muscle in the right way",
      "image": "assets/images/goal_2.png",
      "color": "secondary"
    },
    {
      "title": "Lose Fat",
      "subtitle":
          "I have over 20 lbs to lose. I want to drop all this fat and gain muscle mass",
      "image": "assets/images/goal_3.png",
      "color": "primary"
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
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);

      // Navigate to main app (WelcomeScreen or Home)
      Get.offAllNamed(WelcomeScreen.routeName);
    } catch (e) {
      // Handle and display errors
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      print("Error saving goal: $e");
    }

    setState(() => isSaving = false);
  }

  List<Color> _getGradientColors(String colorType) {
    switch (colorType) {
      case "secondary":
        return AppColors.secondaryG;
      default:
        return AppColors.primaryG;
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: media.height - MediaQuery.of(context).padding.top,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // Header section
                  Column(
                    children: [
                      // Screen title
                      const Text(
                        "What is your goal?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Screen subtitle
                      Text(
                        "It will help us choose the best program for you",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Carousel slider for goal selection - FIXED UI
                  SizedBox(
                    height:
                        media.height * 0.55, // Fixed height to prevent overflow
                    child: CarouselSlider(
                      carouselController: carouselController,
                      items: pageList.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, String> obj = entry.value;
                        bool isSelected = currentIndex == index;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                colors: _getGradientColors(
                                    obj["color"] ?? "primary"),
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _getGradientColors(
                                          obj["color"] ?? "primary")[0]
                                      .withOpacity(isSelected ? 0.4 : 0.2),
                                  blurRadius: isSelected ? 20 : 10,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Stack(
                                children: [
                                  // Background image - covers entire card
                                  Positioned.fill(
                                    child: Image.asset(
                                      obj["image"]!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey.shade300,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                            size: 50,
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // Gradient overlay for better text readability
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.3),
                                            Colors.black.withOpacity(0.6),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Text content overlay - positioned at bottom
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Goal title
                                          Text(
                                            obj["title"]!,
                                            style: const TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),

                                          // Divider line
                                          Container(
                                            width: 60,
                                            height: 2,
                                            decoration: BoxDecoration(
                                              color: AppColors.whiteColor
                                                  .withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          const SizedBox(height: 12),

                                          // Goal description - with proper overflow handling
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxHeight: media.height * 0.12,
                                            ),
                                            child: SingleChildScrollView(
                                              child: Text(
                                                obj["subtitle"]!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppColors.whiteColor
                                                      .withOpacity(0.95),
                                                  fontSize: 13,
                                                  height: 1.4,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: media.height * 0.55,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.25,
                        enableInfiniteScroll: false,
                        initialPage: 0,
                        viewportFraction: 0.8,
                        autoPlay: false,
                        onPageChanged: (index, reason) {
                          setState(() => currentIndex = index);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pageList.asMap().entries.map((entry) {
                      int index = entry.key;
                      bool isSelected = currentIndex == index;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isSelected ? 24 : 8,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor1
                              : AppColors.grayColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Selected goal info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Selected Goal:",
                          style: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pageList[currentIndex]["title"]!,
                          style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Confirm goal selection button
                  RoundGradientButton(
                    title: isSaving
                        ? "Setting up your profile..."
                        : "Let's Get Started!",
                    onPressed: isSaving ? null : _saveGoalAndNavigate,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
