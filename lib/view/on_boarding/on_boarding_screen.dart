import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/on_boarding/widgets/pager_widget.dart';
import 'package:fitnessapp/utils/permissions_handler.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:flutter/material.dart'; // ⬅️ Import your permissions helper // Import your Dashboard screen
import 'package:fitnessapp/services/sharedPref_service.dart'; // Import SharedPrefsService

class OnBoardingScreen extends StatefulWidget {
  static String routeName = "/onBoarding";
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();
  List pageList = [
    {
      "title": "Track Your Goal",
      "subtitle":
          "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
      "image": "assets/images/on_board1.png"
    },
    {
      "title": "Get Burn",
      "subtitle":
          "Let’s keep burning, to achive yours goals, it hurts only temporarily, if you give up now you will be in pain forever",
      "image": "assets/images/on_board2.png"
    },
    {
      "title": "Eat Well",
      "subtitle":
          "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
      "image": "assets/images/on_board3.png"
    },
    {
      "title": "Improve Sleep Quality",
      "subtitle":
          "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
      "image": "assets/images/on_board4.png"
    }
  ];
  int selectedIndex = 0;

  Future<void> _handleNavigation() async {
    if (selectedIndex == pageList.length - 1) {
      // Set onboarding as complete
      await SharedPrefsService().setOnboardingComplete();
      // Request permissions
      await AppPermissions.requestAllPermissions();
      if (!mounted) return;
      // Navigate to signup since user won't be logged in at this point
      Navigator.pushReplacementNamed(context, SignupScreen.routeName);
    } else {
      // Move to next page
      setState(() {
        selectedIndex += 1;
      });
      pageController.animateToPage(
        selectedIndex,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInSine,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: pageList.length,
                  onPageChanged: (i) {
                    setState(() {
                      selectedIndex = i;
                    });
                  },
                  itemBuilder: (context, index) {
                    var temp = pageList[index] as Map? ?? {};
                    return PagerWidget(obj: temp);
                  },
                ),
              ),
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor1,
                        value: (selectedIndex + 1) / 4,
                        strokeWidth: 3,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 25),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: AppColors.primaryColor1,
                      ),
                      child: IconButton(
                        icon: Icon(
                          selectedIndex == pageList.length - 1
                              ? Icons.check
                              : Icons.navigate_next,
                          color: AppColors.whiteColor,
                        ),
                        onPressed: _handleNavigation,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
