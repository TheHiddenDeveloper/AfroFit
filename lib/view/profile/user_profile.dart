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
      body: Obx(() {
        // Get current user data from controller
        final user = userController.user;

        // Prepare display data with fallbacks for missing information
        final fullName =
            "${user?.firstName ?? ''} ${user?.lastName ?? ''}".trim();
        final goal = user?.goal ?? "Set your fitness goal";
        final height = user?.height ?? 0;
        final weight = user?.weight ?? 0;
        final age = user?.age ?? 0;
        final bmi = user?.bmi ?? 0;

        return CustomScrollView(
          slivers: [
            // Custom App Bar with gradient background
            SliverAppBar(
              expandedHeight: 220,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 20),
                onPressed: () => Get.back(),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {
                      // TODO: Implement more options menu
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryColor1,
                        AppColors.primaryColor2,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),

                        // Profile Avatar
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.asset(
                              "assets/images/user.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // User Name
                        Text(
                          fullName.isNotEmpty ? fullName : "User Name",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // User Goal
                        Text(
                          goal,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Body Content
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -30),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Edit Profile Button
                        Center(
                          child: Container(
                            width: 140,
                            height: 45,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryColor1,
                                  AppColors.primaryColor2,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primaryColor1.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: () =>
                                    Get.to(() => const EditProfileScreen()),
                                child: const Center(
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 35),

                        // Stats Section
                        const Text(
                          "Health Stats",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blackColor,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Stats Grid
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.height,
                                      value: height > 0
                                          ? "${height.toStringAsFixed(0)} cm"
                                          : "-",
                                      label: "Height",
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.monitor_weight_outlined,
                                      value: weight > 0
                                          ? "${weight.toStringAsFixed(1)} kg"
                                          : "-",
                                      label: "Weight",
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.cake_outlined,
                                      value: age > 0 ? "$age years" : "-",
                                      label: "Age",
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.analytics_outlined,
                                      value: bmi > 0
                                          ? bmi.toStringAsFixed(1)
                                          : "-",
                                      label: "BMI",
                                      color: Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        // Settings Section
                        const Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blackColor,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Notification Setting Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Notification Icon
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.blue.shade600,
                                  size: 24,
                                ),
                              ),

                              const SizedBox(width: 15),

                              // Notification Text
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Push Notifications",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "Receive workout reminders and updates",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.grayColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Toggle Switch
                              CustomAnimatedToggleSwitch<bool>(
                                current: userController.notificationEnabled,
                                values: const [false, true],
                                dif: 0.0,
                                indicatorSize: const Size.square(24.0),
                                animationDuration:
                                    const Duration(milliseconds: 200),
                                animationCurve: Curves.easeInOut,
                                onChanged: (val) =>
                                    userController.toggleNotification(val),
                                iconBuilder: (context, local, global) =>
                                    const SizedBox(),
                                defaultCursor: SystemMouseCursors.click,
                                iconsTappable: false,
                                wrapperBuilder: (context, global, child) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Positioned(
                                        left: 8.0,
                                        right: 8.0,
                                        height: 28.0,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: userController
                                                      .notificationEnabled
                                                  ? [
                                                      AppColors.primaryColor1,
                                                      AppColors.primaryColor2
                                                    ]
                                                  : [
                                                      Colors.grey.shade300,
                                                      Colors.grey.shade400
                                                    ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      child,
                                    ],
                                  );
                                },
                                foregroundIndicatorBuilder: (context, global) {
                                  return SizedBox.fromSize(
                                    size: const Size(20, 20),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 3,
                                            offset: Offset(0, 1),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grayColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
