import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import '../../controllers/login_controller.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = "/LoginScreen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            children: [
              SizedBox(height: media.width * 0.03),
              const Text("Hey there,", style: TextStyle(color: AppColors.blackColor, fontSize: 16)),
              SizedBox(height: media.width * 0.01),
              const Text("Welcome Back", style: TextStyle(color: AppColors.blackColor, fontSize: 20, fontWeight: FontWeight.w700)),

              SizedBox(height: media.width * 0.05),
              RoundTextField(
                hintText: "Email",
                icon: "assets/icons/message_icon.png",
                textInputType: TextInputType.emailAddress,
                textEditingController: controller.emailController,
              ),
              SizedBox(height: media.width * 0.05),
              Obx(() => RoundTextField(
                    hintText: "Password",
                    icon: "assets/icons/lock_icon.png",
                    textInputType: TextInputType.text,
                    isObscureText: !controller.isPasswordVisible.value,
                    textEditingController: controller.passwordController,
                    rightIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.grayColor,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  )),
              SizedBox(height: media.width * 0.03),
              const Text("Forgot your password?", style: TextStyle(color: AppColors.grayColor, fontSize: 10)),
              const Spacer(),
              Obx(() => RoundGradientButton(
                    title: "Login",
                    onPressed: controller.isLoading.value ? null : controller.login,
                  )),
              SizedBox(height: media.width * 0.01),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.grayColor.withOpacity(0.5))),
                  const Text("  Or  ", style: TextStyle(color: AppColors.grayColor, fontSize: 12)),
                  Expanded(child: Divider(color: AppColors.grayColor.withOpacity(0.5))),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialIcon("assets/icons/google_icon.png", () {
                    // TODO: Implement Google login
                  }),
                  const SizedBox(width: 30),
                  socialIcon("assets/icons/facebook_icon.png", () {
                    // TODO: Implement Facebook login
                  }),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                  onPressed: () {
                    Get.toNamed(SignupScreen.routeName);
                  },
                  child: RichText(
                      text: TextSpan(style: TextStyle(color: AppColors.blackColor, fontSize: 14), children: [
                    const TextSpan(text: "Don’t have an account yet? "),
                    TextSpan(text: "Register", style: TextStyle(color: AppColors.secondaryColor1, fontWeight: FontWeight.w500)),
                  ])))
            ],
          ),
        ),
      ),
    );
  }

  Widget socialIcon(String iconPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primaryColor1.withOpacity(0.5), width: 1),
        ),
        child: Image.asset(iconPath, width: 20, height: 20),
      ),
    );
  }
}
