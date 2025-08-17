import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitnessapp/controllers/user_controller.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/common_widgets/round_gradient_button.dart';

class EditProfileScreen extends StatefulWidget {
  static String routeName = "/EditProfileScreen";

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Get UserController instance to access current user data
  final _controller = Get.find<UserController>();

  // Text controllers for form fields
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController goalController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController ageController;

  @override
  void initState() {
    super.initState();

    // Get current user data from controller
    final user = _controller.user;

    // Initialize text controllers with current user data
    // Use null-aware operators to handle missing data gracefully
    firstNameController = TextEditingController(text: user?.firstName ?? '');
    lastNameController = TextEditingController(text: user?.lastName ?? '');
    goalController = TextEditingController(text: user?.goal ?? '');
    weightController =
        TextEditingController(text: user?.weight?.toString() ?? '');
    heightController =
        TextEditingController(text: user?.height?.toString() ?? '');
    ageController = TextEditingController(text: user?.age?.toString() ?? '');
  }

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    firstNameController.dispose();
    lastNameController.dispose();
    goalController.dispose();
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  /// Save updated profile data
  Future<void> _saveProfile() async {
    // Validate form before saving
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Create updated user object with form data
        final updatedUser = AppUser(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          goal: goalController.text.trim(),
          // Parse numeric fields with error handling
          weight: double.tryParse(weightController.text.trim()),
          height: double.tryParse(heightController.text.trim()),
          age: int.tryParse(ageController.text.trim()),
        );

        // Update profile through UserController
        // This will save to both Firestore and SharedPreferences
        await _controller.updateUserProfile(updatedUser);

        // Show success message
        Get.snackbar("Success", "Profile updated successfully",
            snackPosition: SnackPosition.BOTTOM);

        // Navigate back to profile screen
        Get.back();
      } catch (e) {
        // Handle and display errors
        Get.snackbar("Error", "Failed to update profile: $e",
            snackPosition: SnackPosition.BOTTOM);
        print("Error updating profile: $e");
      }
    }
  }

  /// Build input field widget with consistent styling
  Widget _buildInputField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),

        // Input field with validation
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            filled: true,
            fillColor: AppColors.lightGrayColor,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
          // Basic validation - field is required
          validator: (value) =>
              value == null || value.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(
        title: const Text("Edit Profile",
            style: TextStyle(color: AppColors.blackColor)),
        backgroundColor: AppColors.whiteColor,
        iconTheme: const IconThemeData(color: AppColors.blackColor),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: AppColors.whiteColor,

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // First Name input
              _buildInputField("First Name", firstNameController),

              // Last Name input
              _buildInputField("Last Name", lastNameController),

              // Goal input
              _buildInputField("Goal", goalController),

              // Weight input (numeric)
              _buildInputField("Weight (kg)", weightController,
                  keyboardType: TextInputType.number),

              // Height input (numeric)
              _buildInputField("Height (cm)", heightController,
                  keyboardType: TextInputType.number),

              // Age input (numeric)
              _buildInputField("Age", ageController,
                  keyboardType: TextInputType.number),

              const SizedBox(height: 20),

              // Save button
              RoundGradientButton(
                title: "Save",
                onPressed: _saveProfile,
              )
            ],
          ),
        ),
      ),
    );
  }
}
