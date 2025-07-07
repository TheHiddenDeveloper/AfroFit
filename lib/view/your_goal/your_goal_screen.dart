import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/welcome/welcome_screen.dart';
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
          "I’m “skinny fat”. look thin but have\nno shape. I want to add lean\nmuscle in the right way",
      "image": "assets/images/goal_2.png"
    },
    {
      "title": "Lose Fat",
      "subtitle":
          "I have over 20 lbs to lose. I want to\ndrop all this fat and gain muscle\nmass",
      "image": "assets/images/goal_3.png"
    }
  ];

  final CarouselSliderController carouselController =
      CarouselSliderController();
  int currentIndex = 0;
  bool isSaving = false;

  Future<void> _saveGoalAndNavigate() async {
    final goalTitle = pageList[currentIndex]["title"];
    if (goalTitle == null) return;

    setState(() => isSaving = true);
    try {
      final dbService = DatabaseService();
      await dbService.saveUserGoal(goalTitle);

      Get.snackbar("Success", "Goal saved",
          snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed(WelcomeScreen.routeName);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
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
            Center(
              child: CarouselSlider(
                carouselController: carouselController,
                items: pageList.map((obj) {
                  return Container(
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
                        Image.asset(
                          obj["image"]!,
                          width: media.width * 0.5,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          obj["title"]!,
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                            width: 50, height: 1, color: AppColors.whiteColor),
                        const SizedBox(height: 8),
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
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  initialPage: 0,
                  viewportFraction: 0.75,
                  onPageChanged: (index, reason) =>
                      setState(() => currentIndex = index),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 15),
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
                  const Text(
                    "It will help us to choose the best\nprogram for you",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grayColor,
                      fontSize: 12,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const Spacer(),
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
