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

  bool isLoading = false;

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
      setState(() => isLoading = true);

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
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);

        // Navigate back to profile screen
        Get.back();
      } catch (e) {
        // Handle and display errors
        Get.snackbar("Error", "Failed to update profile: $e",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
        print("Error updating profile: $e");
      }

      setState(() => isLoading = false);
    }
  }

  /// Build input field widget with consistent styling
  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? suffix,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 8),

        // Input field with validation
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor,
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: AppColors.lightGrayColor,
            suffixText: suffix,
            suffixStyle: const TextStyle(
              color: AppColors.grayColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            hintStyle: const TextStyle(
              color: AppColors.grayColor,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.primaryColor1,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
          ),
          // Basic validation - field is required
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }

            // Additional validation for numeric fields
            if (keyboardType == TextInputType.number) {
              if (double.tryParse(value.trim()) == null) {
                return 'Please enter a valid number';
              }

              final numValue = double.parse(value.trim());
              if (label.toLowerCase().contains('weight') &&
                  (numValue <= 0 || numValue > 500)) {
                return 'Please enter a valid weight (1-500)';
              }
              if (label.toLowerCase().contains('height') &&
                  (numValue <= 0 || numValue > 300)) {
                return 'Please enter a valid height (1-300)';
              }
              if (label.toLowerCase().contains('age') &&
                  (numValue < 10 || numValue > 120)) {
                return 'Please enter a valid age (10-120)';
              }
            }

            return null;
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.whiteColor,
        iconTheme: const IconThemeData(color: AppColors.blackColor),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: AppColors.whiteColor,

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Profile section header
            const Text(
              "Personal Information",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 20),

            // First Name and Last Name in a row
            Row(
              children: [
                Expanded(
                  child: _buildInputField("First Name", firstNameController),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildInputField("Last Name", lastNameController),
                ),
              ],
            ),

            // Goal input - larger text area
            _buildInputField("Goal", goalController, maxLines: 3),

            // Physical measurements section
            const Text(
              "Physical Measurements",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 20),

            // Weight and Age in a row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    "Weight",
                    weightController,
                    keyboardType: TextInputType.number,
                    suffix: "kg",
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildInputField(
                    "Age",
                    ageController,
                    keyboardType: TextInputType.number,
                    suffix: "years",
                  ),
                ),
              ],
            ),

            // Height input
            _buildInputField(
              "Height",
              heightController,
              keyboardType: TextInputType.number,
              suffix: "cm",
            ),

            const SizedBox(height: 10),

            // Save button with loading state
            RoundGradientButton(
              title: isLoading ? "Saving..." : "Save Changes",
              onPressed: isLoading ? null : _saveProfile,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
