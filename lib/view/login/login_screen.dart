// 🔁 Updated Login Screen with full functionality
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/services/auth_service.dart';
import 'package:fitnessapp/view/profile/complete_profile_screen.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import '../../utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;

  void _login() async {
    setState(() => isLoading = true);
    try {
      await authService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      Get.snackbar("Success", "Successfully Logged In");
      Navigator.pushReplacementNamed(context, CompleteProfileScreen.routeName);
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    }
    setState(() => isLoading = false);
  }

  void _socialLogin(Future<User?> Function() method) async {
    setState(() => isLoading = true);
    try {
      final user = await method();
      if (user != null) {
        Get.snackbar("Success", "Successfully Logged In");
        Navigator.pushReplacementNamed(context, CompleteProfileScreen.routeName);
      }
    } catch (e) {
      Get.snackbar("Social Login Failed", e.toString());
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                width: media.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: media.width * 0.03),
                    const Text("Hey there,", style: TextStyle(color: AppColors.blackColor, fontSize: 16)),
                    const SizedBox(height: 5),
                    const Text("Welcome Back", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              RoundTextField(
                  textEditingController: emailController,
                  hintText: "Email",
                  icon: "assets/icons/message_icon.png",
                  textInputType: TextInputType.emailAddress),
              const SizedBox(height: 20),
              RoundTextField(
                textEditingController: passwordController,
                hintText: "Password",
                icon: "assets/icons/lock_icon.png",
                textInputType: TextInputType.text,
                isObscureText: true,
              ),
              const SizedBox(height: 10),
              const Text("Forgot your password?", style: TextStyle(color: AppColors.grayColor, fontSize: 10)),
              const Spacer(),
              RoundGradientButton(
                title: isLoading ? "Please wait..." : "Login",
                onPressed: isLoading ? null : _login,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.grayColor.withOpacity(0.5))),
                  const Text("  Or  "),
                  Expanded(child: Divider(color: AppColors.grayColor.withOpacity(0.5))),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _socialLogin(authService.signInWithGoogle),
                    child: socialIcon("assets/icons/google_icon.png"),
                  ),
                  const SizedBox(width: 30),
                  GestureDetector(
                    onTap: () => _socialLogin(authService.signInWithFacebook),
                    child: socialIcon("assets/icons/facebook_icon.png"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, SignupScreen.routeName),
                child: const Text("Don’t have an account yet? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget socialIcon(String assetPath) {
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
