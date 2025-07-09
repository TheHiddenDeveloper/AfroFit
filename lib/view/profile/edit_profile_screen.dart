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
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<UserController>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController goalController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController ageController;

  @override
  void initState() {
    final user = _controller.user;

    firstNameController = TextEditingController(text: user?.firstName ?? '');
    lastNameController = TextEditingController(text: user?.lastName ?? '');
    goalController = TextEditingController(text: user?.goal ?? '');
    weightController = TextEditingController(text: user?.weight?.toString() ?? '');
    heightController = TextEditingController(text: user?.height?.toString() ?? '');
    ageController = TextEditingController(text: user?.age?.toString() ?? '');

    super.initState();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedUser = AppUser(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        goal: goalController.text.trim(),
        weight: double.tryParse(weightController.text.trim()),
        height: double.tryParse(heightController.text.trim()),
        age: int.tryParse(ageController.text.trim()),
      );

      await _controller.updateUserProfile(updatedUser);

      Get.snackbar("Success", "Profile updated successfully",
          snackPosition: SnackPosition.BOTTOM);
      Get.back(); // navigate back to UserProfile
    }
  }

  Widget _buildInputField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            filled: true,
            fillColor: AppColors.lightGrayColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: AppColors.blackColor)),
        backgroundColor: AppColors.whiteColor,
        iconTheme: const IconThemeData(color: AppColors.blackColor),
        elevation: 1,
      ),
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInputField("First Name", firstNameController),
              _buildInputField("Last Name", lastNameController),
              _buildInputField("Goal", goalController),
              _buildInputField("Weight (kg)", weightController, keyboardType: TextInputType.number),
              _buildInputField("Height (cm)", heightController, keyboardType: TextInputType.number),
              _buildInputField("Age", ageController, keyboardType: TextInputType.number),
              const SizedBox(height: 20),
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
