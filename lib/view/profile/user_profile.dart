import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/round_button.dart';
import '../../utils/app_colors.dart';
import '../../view/profile/widgets/setting_row.dart';
import '../../view/profile/widgets/title_subtitle_cell.dart';
import '../../controllers/user_controller.dart';
import '../profile/edit_profile_screen.dart';

class UserProfile extends StatelessWidget {

  static String routeName = "/UserProfileScreen";

  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.lightGrayColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/icons/more_icon.png",
                width: 12,
                height: 12,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      body: Obx(() {
        final user = userController.user;
        final fullName = "${user?.firstName} ${user?.lastName}";
        final goal = user?.goal ?? "-";
        final height = user?.height ?? "-";
        final weight = user?.weight ?? "-";
        final age = user?.age ?? "-";
        final bmi = user?.bmi != null ? user?.bmi!.toStringAsFixed(1) : "-";

        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        "assets/images/user.png",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: const TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            goal,
                            style: const TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      height: 25,
                      child: RoundButton(
                        title: "Edit",
                        type: RoundButtonType.primaryBG,
                        onPressed: () {
                          Get.to(() => const EditProfileScreen());
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TitleSubtitleCell(
                        title: "$height cm",
                        subtitle: "Height",
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TitleSubtitleCell(
                        title: "$weight kg",
                        subtitle: "Weight",
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TitleSubtitleCell(
                        title: "$age yo",
                        subtitle: "Age",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TitleSubtitleCell(
                  title: "BMI: $bmi",
                  subtitle: "Body Mass Index",
                ),
                const SizedBox(height: 25),

                /// Notification Toggle Section
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Notification",
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset("assets/icons/p_notification.png",
                              height: 15, width: 15),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Text(
                              "Pop-up Notification",
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Obx(() {
                            return CustomAnimatedToggleSwitch<bool>(
                              current: userController.notificationEnabled,
                              values: const [false, true],
                              dif: 0.0,
                              indicatorSize: const Size.square(30.0),
                              animationDuration: const Duration(milliseconds: 200),
                              animationCurve: Curves.linear,
                              onChanged: (val) {
                                userController.toggleNotification(val);
                              },
                              iconBuilder: (context, local, global) => const SizedBox(),
                              defaultCursor: SystemMouseCursors.click,
                              iconsTappable: false,
                              wrapperBuilder: (context, global, child) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      left: 10.0,
                                      right: 10.0,
                                      height: 30.0,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: AppColors.secondaryG),
                                          borderRadius:
                                              const BorderRadius.all(Radius.circular(30.0)),
                                        ),
                                      ),
                                    ),
                                    child,
                                  ],
                                );
                              },
                              foregroundIndicatorBuilder: (context, global) {
                                return SizedBox.fromSize(
                                  size: const Size(10, 10),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black38,
                                          blurRadius: 1.1,
                                          offset: Offset(0.0, 0.8),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          })
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
