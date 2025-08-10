import 'package:fitnessapp/view/profile/edit_profile_screen.dart';
import 'package:fitnessapp/view/profile/user_profile.dart';
import 'package:fitnessapp/view/splash/splash_screen.dart';
import 'package:get/get.dart';
import 'package:fitnessapp/view/activity_tracker/activity_tracker_screen.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:fitnessapp/view/finish_workout/finish_workout_screen.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:fitnessapp/view/notification/notification_screen.dart';
import 'package:fitnessapp/view/on_boarding/on_boarding_screen.dart';
import 'package:fitnessapp/view/on_boarding/start_screen.dart';
import 'package:fitnessapp/view/profile/complete_profile_screen.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:fitnessapp/view/welcome/welcome_screen.dart';
import 'package:fitnessapp/view/workout_schedule_view/workout_schedule_view.dart';
import 'package:fitnessapp/view/your_goal/your_goal_screen.dart';
import 'package:fitnessapp/view/workout/workout_screen.dart';
import 'package:fitnessapp/view/nutrition/nutrition_screen.dart';

final List<GetPage> appRoutes = [
  GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
  GetPage(
      name: OnBoardingScreen.routeName, page: () => const OnBoardingScreen()),
  GetPage(name: LoginScreen.routeName, page: () => const LoginScreen()),
  GetPage(name: StartScreen.routeName, page: () => const StartScreen()),
  GetPage(name: SignupScreen.routeName, page: () => const SignupScreen()),
  GetPage(
      name: CompleteProfileScreen.routeName,
      page: () => const CompleteProfileScreen()),
  GetPage(name: YourGoalScreen.routeName, page: () => const YourGoalScreen()),
  GetPage(name: WelcomeScreen.routeName, page: () => WelcomeScreen()),
  GetPage(name: DashboardScreen.routeName, page: () => const DashboardScreen()),
  GetPage(
      name: FinishWorkoutScreen.routeName,
      page: () => const FinishWorkoutScreen()),
  GetPage(
      name: NotificationScreen.routeName,
      page: () => const NotificationScreen()),
  GetPage(
      name: ActivityTrackerScreen.routeName,
      page: () => const ActivityTrackerScreen()),
  GetPage(
      name: WorkoutScheduleView.routeName,
      page: () => const WorkoutScheduleView()),
  GetPage(name: EditProfileScreen.routeName, page: () => EditProfileScreen()),
  GetPage(name: UserProfile.routeName, page: () => const UserProfile()),
  GetPage(name: WorkoutScreen.routeName, page: () => WorkoutScreen()),
  GetPage(name: NutritionScreen.routeName, page: () => const NutritionScreen()),
];
