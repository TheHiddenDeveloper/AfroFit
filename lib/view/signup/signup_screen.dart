import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/services/auth_service.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import '../profile/complete_profile_screen.dart';

class SignupScreen extends StatefulWidget {
  static String routeName = "/SignupScreen";

  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isCheck = false;
  bool isLoading = false;

  void _signUp() async {
    if (!isCheck) {
      Get.snackbar("Error", "You must accept the privacy policy & terms of use.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      Get.snackbar("Error", "Passwords do not match", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => isLoading = true);
    try {
      final user = await _authService.signUpWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (user != null) {
        Get.snackbar("Success", "Account created successfully!", snackPosition: SnackPosition.BOTTOM);
        Navigator.pushReplacementNamed(context, CompleteProfileScreen.routeName);
      }
    } catch (e) {
      Get.snackbar("Sign Up Failed", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    setState(() => isLoading = false);
  }

  Future<void> _handleSocialLogin(Future<User?> Function() loginMethod) async {
    setState(() => isLoading = true);
    try {
      final user = await loginMethod();
      if (user != null) {
        Get.snackbar("Success", "Signed in successfully", snackPosition: SnackPosition.BOTTOM);
        Navigator.pushReplacementNamed(context, CompleteProfileScreen.routeName);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              const Text("Hey there,", style: TextStyle(color: AppColors.blackColor, fontSize: 16)),
              const SizedBox(height: 5),
              const Text("Create an Account",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 15),
              RoundTextField(
                hintText: "First Name",
                icon: "assets/icons/profile_icon.png",
                textInputType: TextInputType.name,
                textEditingController: firstNameController,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                hintText: "Last Name",
                icon: "assets/icons/profile_icon.png",
                textInputType: TextInputType.name,
                textEditingController: lastNameController,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                hintText: "Email",
                icon: "assets/icons/message_icon.png",
                textInputType: TextInputType.emailAddress,
                textEditingController: emailController,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                hintText: "Password",
                icon: "assets/icons/lock_icon.png",
                textInputType: TextInputType.text,
                isObscureText: true,
                textEditingController: passwordController,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                hintText: "Confirm Password",
                icon: "assets/icons/lock_icon.png",
                textInputType: TextInputType.text,
                isObscureText: true,
                textEditingController: confirmPasswordController,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => setState(() => isCheck = !isCheck),
                    icon: Icon(
                      isCheck ? Icons.check_box : Icons.check_box_outline_blank,
                      color: AppColors.grayColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "By continuing you accept our Privacy Policy and\nTerm of Use",
                      style: TextStyle(color: AppColors.grayColor, fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              RoundGradientButton(
                title: isLoading ? "Please wait..." : "Register",
                onPressed: isLoading ? null : _signUp,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.grayColor.withOpacity(0.5))),
                  const Text("  Or  ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                  Expanded(child: Divider(color: AppColors.grayColor.withOpacity(0.5))),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _handleSocialLogin(_authService.signInWithGoogle),
                    child: _socialButton("assets/icons/google_icon.png"),
                  ),
                  const SizedBox(width: 30),
                  GestureDetector(
                    onTap: () => _handleSocialLogin(_authService.signInWithFacebook),
                    child: _socialButton("assets/icons/facebook_icon.png"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () =>  Navigator.pushReplacementNamed(context, LoginScreen.routeName),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
                    children: [
                      const TextSpan(text: "Already have an account? "),
                      TextSpan(
                          text: "Login",
                          style: TextStyle(
                              color: AppColors.secondaryColor1,
                              fontSize: 14,
                              fontWeight: FontWeight.w800)),
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

  Widget _socialButton(String assetPath) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryColor1.withOpacity(0.5), width: 1),
      ),
      child: Image.asset(assetPath, width: 20, height: 20),
    );
  }
}
