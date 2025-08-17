import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/services/sharedPref_service.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:fitnessapp/view/profile/complete_profile_screen.dart';
import 'package:fitnessapp/view/welcome/welcome_screen.dart';
import 'package:fitnessapp/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import '../../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  static String routeName = "/SignupScreen";

  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Service instances
  final AuthService authService = AuthService();

  // Form controllers for user input
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  // UI state variables
  bool isCheck = false; // Terms and conditions checkbox
  bool isLoading = false; // Loading state during registration

  /// Handle user registration process
  void _register() async {
    // Validate terms and conditions acceptance
    if (!isCheck) {
      Get.snackbar("Terms", "Please accept Privacy Policy and Terms of Use");
      return;
    }

    // Show loading state
    setState(() => isLoading = true);

    try {
      // Create user account with Firebase Auth
      final User? user = await authService.signUpWithEmail(
        emailCtrl.text.trim(),
        passwordCtrl.text.trim(),
      );

      if (user != null) {
        // Extract user input data
        final firstName = firstNameCtrl.text.trim();
        final lastName = lastNameCtrl.text.trim();

        // Save user names to SharedPreferences (offline storage)
        // This ensures data is available even if cloud storage fails
        await SharedPrefsService().saveUserName(
          firstName: firstName,
          lastName: lastName,
        );

        // Initialize UserController if not already done
        // This controller manages user data across the app
        if (!Get.isRegistered<UserController>()) {
          Get.put(UserController(), permanent: true);
        }

        // Save user names to Firestore via UserController
        // This ensures data is available in cloud storage
        final userController = Get.find<UserController>();
        await userController.saveUserNamesAfterSignup(firstName, lastName);

        // Show success message
        Get.snackbar("Success", "Registration Successful",
            snackPosition: SnackPosition.BOTTOM);

        // Navigate to profile completion screen
        // This continues the onboarding flow
        Get.offAllNamed(CompleteProfileScreen.routeName);
      }
    } catch (e) {
      // Show error message if registration fails
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }

    // Hide loading state
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 15),

              // Header text
              const Text("Hey there,",
                  style: TextStyle(color: AppColors.blackColor, fontSize: 16)),
              const Text("Create an Account",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),

              const SizedBox(height: 15),

              // First Name input field
              RoundTextField(
                  hintText: "First Name",
                  icon: "assets/icons/profile_icon.png",
                  textInputType: TextInputType.name,
                  textEditingController: firstNameCtrl),
              const SizedBox(height: 15),

              // Last Name input field
              RoundTextField(
                  hintText: "Last Name",
                  icon: "assets/icons/profile_icon.png",
                  textInputType: TextInputType.name,
                  textEditingController: lastNameCtrl),

              const SizedBox(height: 15),

              // Email input field
              RoundTextField(
                  hintText: "Email",
                  icon: "assets/icons/message_icon.png",
                  textInputType: TextInputType.emailAddress,
                  textEditingController: emailCtrl),
              const SizedBox(height: 15),

              // Password input field (hidden text)
              RoundTextField(
                  hintText: "Password",
                  icon: "assets/icons/lock_icon.png",
                  textInputType: TextInputType.text,
                  isObscureText: true, // Hide password text
                  textEditingController: passwordCtrl),
              const SizedBox(height: 15),

              // Terms and conditions checkbox
              Row(
                children: [
                  Checkbox(
                      value: isCheck,
                      onChanged: (v) => setState(() => isCheck = v ?? false)),
                  const Expanded(
                    child: Text(
                        "By continuing you accept our Privacy Policy and Terms of Use",
                        style: TextStyle(fontSize: 10)),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Register button with loading state
              RoundGradientButton(
                title: isLoading ? "Loading..." : "Register",
                onPressed: isLoading ? null : _register, // Disable when loading
              ),
              const SizedBox(height: 20),

              // Social login options
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google sign-in button
                  GestureDetector(
                      onTap: () => authService.signInWithGoogle(),
                      child: Image.asset("assets/icons/google_icon.png",
                          width: 50)),
                  const SizedBox(width: 20),
                  // Facebook sign-in button
                  GestureDetector(
                      onTap: () => authService.signInWithFacebook(),
                      child: Image.asset("assets/icons/facebook_icon.png",
                          width: 50)),
                ],
              ),

              // Navigate to login screen
              TextButton(
                onPressed: () => Get.toNamed(LoginScreen.routeName),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: AppColors.blackColor, fontSize: 14),
                    children: [
                      TextSpan(text: "Already have an account? "),
                      TextSpan(
                          text: "Login",
                          style: TextStyle(
                              color: AppColors.secondaryColor1,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
