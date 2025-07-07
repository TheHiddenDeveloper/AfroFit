import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/services/sharedPref_service.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:fitnessapp/view/profile/complete_profile_screen.dart';
import 'package:fitnessapp/view/welcome/welcome_screen.dart';
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
  final AuthService authService = AuthService();
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool isCheck = false;
  bool isLoading = false;

  void _register() async {
    if (!isCheck) {
      Get.snackbar("Terms", "Please accept Privacy Policy and Terms of Use");
      return;
    }

    setState(() => isLoading = true);
    try {
      final User? user = await authService.signUpWithEmail(
        emailCtrl.text.trim(),
        passwordCtrl.text.trim(),
      );

      if (user != null) {
        // Save first name to shared prefs
        await SharedPrefsService().saveUserName(
          firstName: firstNameCtrl.text.trim(),
          lastName: lastNameCtrl.text.trim()
        );

        Get.snackbar("Success", "Registration Successful",
            snackPosition: SnackPosition.BOTTOM);

        // Navigate to CompleteProfileScreen as per roadmap
        Get.offAllNamed(CompleteProfileScreen.routeName);
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
            children: [
              const SizedBox(height: 15),
              const Text("Hey there,", style: TextStyle(color: AppColors.blackColor, fontSize: 16)),
              const Text("Create an Account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),

              const SizedBox(height: 15),
              RoundTextField(
                  hintText: "First Name",
                  icon: "assets/icons/profile_icon.png",
                  textInputType: TextInputType.name,
                  textEditingController: firstNameCtrl),
              const SizedBox(height: 15),

              RoundTextField(
                  hintText: "Last Name",
                  icon: "assets/icons/profile_icon.png",
                  textInputType: TextInputType.name,
                  textEditingController: lastNameCtrl),

              const SizedBox(height: 15),
              RoundTextField(
                  hintText: "Email",
                  icon: "assets/icons/message_icon.png",
                  textInputType: TextInputType.emailAddress,
                  textEditingController: emailCtrl),
              const SizedBox(height: 15),
              RoundTextField(
                  hintText: "Password",
                  icon: "assets/icons/lock_icon.png",
                  textInputType: TextInputType.text,
                  isObscureText: true,
                  textEditingController: passwordCtrl),
              const SizedBox(height: 15),

              Row(
                children: [
                  Checkbox(value: isCheck, onChanged: (v) => setState(() => isCheck = v ?? false)),
                  const Expanded(
                    child: Text("By continuing you accept our Privacy Policy and Terms of Use",
                        style: TextStyle(fontSize: 10)),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              RoundGradientButton(
                title: isLoading ? "Loading..." : "Register",
                onPressed: isLoading ? null : _register,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () => authService.signInWithGoogle(),
                      child: Image.asset("assets/icons/google_icon.png", width: 50)),
                  const SizedBox(width: 20),
                  GestureDetector(
                      onTap: () => authService.signInWithFacebook(),
                      child: Image.asset("assets/icons/facebook_icon.png", width: 50)),
                ],
              ),
              TextButton(
                onPressed: () => Get.toNamed(LoginScreen.routeName),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
                    children: const [
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
