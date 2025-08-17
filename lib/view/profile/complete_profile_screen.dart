import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/services/database_service.dart';
import 'package:fitnessapp/services/sharedPref_service.dart';
import 'package:fitnessapp/controllers/user_controller.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/your_goal/your_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';

// Enums for unit selection
enum HeightUnit { meters, feetInches }

enum WeightUnit { kg, lbs }

class CompleteProfileScreen extends StatefulWidget {
  static String routeName = "/CompleteProfileScreen";

  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  // Form controllers for user input
  final TextEditingController dobController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  // Form state variables
  String? selectedGender;
  HeightUnit selectedHeightUnit = HeightUnit.meters;
  WeightUnit selectedWeightUnit = WeightUnit.kg;
  bool isLoading = false;

  /// Calculate age from birth date
  int _calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;

    // Adjust age if birthday hasn't occurred this year
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  /// Convert weight to kilograms (standard unit for storage)
  double _convertWeightToKg(double weight, WeightUnit unit) {
    if (unit == WeightUnit.lbs) {
      return weight * 0.453592; // Convert pounds to kilograms
    }
    return weight; // Already in kg
  }

  /// Convert height to centimeters (standard unit for storage)
  double _convertHeightToCm(double height, HeightUnit unit) {
    if (unit == HeightUnit.feetInches) {
      // Assuming input is in decimal feet (e.g., 5.8 feet)
      return height * 30.48; // Convert feet to centimeters
    }
    return height * 100; // Convert meters to centimeters
  }

  /// Handle profile submission and save to all storage locations
  Future<void> _submitProfile() async {
    // Validate all required fields are filled
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
      // Parse and calculate age from date of birth
      final dobParts = dobController.text.split('-');
      final dateOfBirth = DateTime(
        int.parse(dobParts[0]), // year
        int.parse(dobParts[1]), // month
        int.parse(dobParts[2]), // day
      );
      final age = _calculateAge(dateOfBirth);

      // Convert user input to standard units
      final weightInput = double.tryParse(weightController.text.trim()) ?? 0.0;
      final heightInput = double.tryParse(heightController.text.trim()) ?? 0.0;

      final weightInKg = _convertWeightToKg(weightInput, selectedWeightUnit);
      final heightInCm = _convertHeightToCm(heightInput, selectedHeightUnit);

      // Retrieve existing user names from SharedPreferences
      final sharedPrefs = SharedPrefsService();
      final firstName = await sharedPrefs.getFirstName() ?? '';
      final lastName = await sharedPrefs.getLastName() ?? '';

      // Create complete user profile object
      final completeUser = AppUser(
        firstName: firstName,
        lastName: lastName,
        goal: '', // Will be set in the next screen (YourGoalScreen)
        weight: weightInKg,
        height: heightInCm,
        age: age,
      );

      // Save to legacy DatabaseService (maintains backward compatibility)
      final dbService = DatabaseService();
      await dbService.saveUserProfile(
        gender: selectedGender!,
        dateOfBirth: dobController.text.trim(),
        weight:
            "${weightController.text.trim()} ${selectedWeightUnit == WeightUnit.kg ? "kg" : "lbs"}",
        height:
            "${heightController.text.trim()} ${selectedHeightUnit == HeightUnit.meters ? "m" : "ft/in"}",
      );

      // Save complete profile to SharedPreferences (offline storage)
      await sharedPrefs.saveUserProfile(
        firstName: firstName,
        lastName: lastName,
        height: heightInCm,
        weight: weightInKg,
        age: age,
        goal: '', // Will be updated in next screen
      );

      // Initialize UserController if not already done
      if (!Get.isRegistered<UserController>()) {
        Get.put(UserController(), permanent: true);
      }

      // Update UserController with complete profile (saves to Firestore)
      final userController = Get.find<UserController>();
      await userController.updateUserProfile(completeUser);

      // Show success message
      Get.snackbar("Success", "Profile Saved Successfully",
          snackPosition: SnackPosition.BOTTOM);

      // Navigate to goal selection screen
      if (mounted) {
        Get.toNamed(YourGoalScreen.routeName);
      }
    } catch (e) {
      // Handle and display errors
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      print("Error saving profile: $e");
    }

    setState(() => isLoading = false);
  }

  /// Show date picker for date of birth selection
  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000), // Default to year 2000
      firstDate: DateTime(1900), // Allow birth years from 1900
      lastDate: DateTime.now(), // Don't allow future dates
    );

    if (picked != null) {
      // Format date as YYYY-MM-DD with zero padding
      dobController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
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
                // Header image
                Image.asset("assets/images/complete_profile.png",
                    width: media.width),
                const SizedBox(height: 15),

                // Header text
                const Text(
                  "Let's complete your profile",
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

                // Gender selection dropdown
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrayColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      // Gender icon
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
                      // Gender dropdown
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

                // Date of Birth input with date picker
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

                // Weight input with unit selector
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
                    // Weight unit dropdown
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

                // Height input with unit selector
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
                    // Height unit dropdown
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

                // Submit button with loading state
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
