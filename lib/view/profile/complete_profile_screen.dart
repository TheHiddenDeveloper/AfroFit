import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/services/database_service.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/your_goal/your_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';

enum HeightUnit { meters, feetInches }
enum WeightUnit { kg, lbs }

class CompleteProfileScreen extends StatefulWidget {
  static String routeName = "/CompleteProfileScreen";

  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String? selectedGender;

  HeightUnit selectedHeightUnit = HeightUnit.meters;
  WeightUnit selectedWeightUnit = WeightUnit.kg;

  bool isLoading = false;

  Future<void> _submitProfile() async {
    if (selectedGender == null ||
        dobController.text.isEmpty ||
        weightController.text.isEmpty ||
        heightController.text.isEmpty) {
      Get.snackbar("Error", "Please complete all fields",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => isLoading = true);
    try {
      final dbService = DatabaseService();
      await dbService.saveUserProfile(
        gender: selectedGender!,
        dateOfBirth: dobController.text.trim(),
        weight:
            "${weightController.text.trim()} ${selectedWeightUnit == WeightUnit.kg ? "kg" : "lbs"}",
        height:
            "${heightController.text.trim()} ${selectedHeightUnit == HeightUnit.meters ? "m" : "ft/in"}",
      );

      Get.snackbar("Success", "Profile Saved Successfully",
          snackPosition: SnackPosition.BOTTOM);

      if (mounted) {
        Get.toNamed(YourGoalScreen.routeName);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    setState(() => isLoading = false);
  }

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = "${picked.year}-${picked.month}-${picked.day}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Image.asset("assets/images/complete_profile.png",
                    width: media.width),
                const SizedBox(height: 15),
                const Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 5),
                const Text(
                  "It will help us to know more about you!",
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 25),
                // Gender Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrayColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Image.asset(
                          "assets/icons/gender_icon.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          color: AppColors.grayColor,
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedGender,
                            hint: const Text("Choose Gender",
                                style: TextStyle(
                                    color: AppColors.grayColor, fontSize: 12)),
                            isExpanded: true,
                            items: ["Male", "Female"]
                                .map((gender) => DropdownMenuItem(
                                      value: gender,
                                      child: Text(
                                        gender,
                                        style: const TextStyle(
                                            color: AppColors.grayColor,
                                            fontSize: 14),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => selectedGender = value),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // DOB
                RoundTextField(
                  hintText: "Date of Birth",
                  icon: "assets/icons/calendar_icon.png",
                  textInputType: TextInputType.datetime,
                  textEditingController: dobController,
                  rightIcon: IconButton(
                    icon: const Icon(Icons.calendar_today,
                        color: AppColors.grayColor, size: 18),
                    onPressed: _pickDateOfBirth,
                  ),
                ),
                const SizedBox(height: 15),
                // Weight + unit
                Row(
                  children: [
                    Expanded(
                      child: RoundTextField(
                        hintText: "Your Weight",
                        icon: "assets/icons/weight_icon.png",
                        textInputType: TextInputType.number,
                        textEditingController: weightController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<WeightUnit>(
                      value: selectedWeightUnit,
                      items: WeightUnit.values.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit == WeightUnit.kg ? "kg" : "lbs"),
                        );
                      }).toList(),
                      onChanged: (unit) {
                        setState(() => selectedWeightUnit = unit!);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Height + unit
                Row(
                  children: [
                    Expanded(
                      child: RoundTextField(
                        hintText: "Your Height",
                        icon: "assets/icons/swap_icon.png",
                        textInputType: TextInputType.number,
                        textEditingController: heightController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<HeightUnit>(
                      value: selectedHeightUnit,
                      items: HeightUnit.values.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child:
                              Text(unit == HeightUnit.meters ? "m" : "ft/in"),
                        );
                      }).toList(),
                      onChanged: (unit) {
                        setState(() => selectedHeightUnit = unit!);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                RoundGradientButton(
                  title: isLoading ? "Saving..." : "Next >",
                  onPressed: isLoading ? null : _submitProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
