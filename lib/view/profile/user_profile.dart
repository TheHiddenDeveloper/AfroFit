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
    // Get UserController instance to access user data
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,

      // App bar with profile title
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          // More options button (functionality to be implemented)
          InkWell(
            onTap: () {
              // TODO: Implement more options menu
            },
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

      // Use Obx for reactive UI updates when user data changes
      body: Obx(() {
        // Get current user data from controller
        final user = userController.user;

        // Prepare display data with fallbacks for missing information
        final fullName =
            "${user?.firstName ?? ''} ${user?.lastName ?? ''}".trim();
        final goal = user?.goal ?? "-";
        final height = user?.height?.toString() ?? "-";
        final weight = user?.weight?.toString() ?? "-";
        final age = user?.age?.toString() ?? "-";
        // Format BMI to 1 decimal place if available
        final bmi = user?.bmi != null ? user?.bmi!.toStringAsFixed(1) : "-";

        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User profile header section
                Row(
                  children: [
                    // User avatar image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        "assets/images/user.png", // Default user image
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),

                    // User name and goal info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display full name or placeholder if empty
                          Text(
                            fullName.isNotEmpty ? fullName : "User Name",
                            style: const TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Display goal or placeholder
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

                    // Edit profile button
                    SizedBox(
                      width: 70,
                      height: 25,
                      child: RoundButton(
                        title: "Edit",
                        type: RoundButtonType.primaryBG,
                        onPressed: () {
                          // Navigate to edit profile screen
                          Get.to(() => const EditProfileScreen());
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),

                // User stats row (Height, Weight, Age)
                Row(
                  children: [
                    // Height display
                    Expanded(
                      child: TitleSubtitleCell(
                        title: "$height cm",
                        subtitle: "Height",
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Weight display
                    Expanded(
                      child: TitleSubtitleCell(
                        title: "$weight kg",
                        subtitle: "Weight",
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Age display
                    Expanded(
                      child: TitleSubtitleCell(
                        title: "$age yo",
                        subtitle: "Age",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // BMI display
                TitleSubtitleCell(
                  title: "BMI: $bmi",
                  subtitle: "Body Mass Index",
                ),
                const SizedBox(height: 25),

                /// Notification Settings Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                      // Notification section title
                      const Text(
                        "Notification",
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Notification toggle row
                      Row(
                        children: [
                          // Notification icon
                          Image.asset("assets/icons/p_notification.png",
                              height: 15, width: 15),
                          const SizedBox(width: 15),

                          // Notification label
                          const Expanded(
                            child: Text(
                              "Pop-up Notification",
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 12,
                              ),
                            ),
                          ),

                          // Reactive notification toggle switch
                          Obx(() {
                            return CustomAnimatedToggleSwitch<bool>(
                              current: userController.notificationEnabled,
                              values: const [false, true],
                              dif: 0.0,
                              indicatorSize: const Size.square(30.0),
                              animationDuration:
                                  const Duration(milliseconds: 200),
                              animationCurve: Curves.linear,
                              // Handle toggle state change
                              onChanged: (val) {
                                userController.toggleNotification(val);
                              },
                              iconBuilder: (context, local, global) =>
                                  const SizedBox(),
                              defaultCursor: SystemMouseCursors.click,
                              iconsTappable: false,
                              // Custom switch background design
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
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30.0)),
                                        ),
                                      ),
                                    ),
                                    child,
                                  ],
                                );
                              },
                              // Custom switch indicator design
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
