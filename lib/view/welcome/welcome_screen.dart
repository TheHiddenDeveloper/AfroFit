import 'package:fitnessapp/services/sharedPref_service.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/round_gradient_button.dart';

class WelcomeScreen extends StatelessWidget {
  static String routeName = "/WelcomeScreen";

  final Future<String?> firstNameFuture = SharedPrefsService().getFirstName();

  WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: firstNameFuture,
          builder: (context, snapshot) {
            final name = snapshot.data ?? "user";

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset("assets/images/welcome_promo.png",
                      width: media.width * 0.75, fit: BoxFit.fitWidth),
                  SizedBox(height: media.width * 0.05),
                  Text(
                    "Welcome, $name",
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "You are all set now, let’s reach your\ngoals together with us",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grayColor,
                      fontSize: 12,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  RoundGradientButton(
                    title: "Go To Home",
                    onPressed: () {
                      Get.toNamed(DashboardScreen.routeName);
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
