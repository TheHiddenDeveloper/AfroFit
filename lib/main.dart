import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 👈 Import GetX
import 'package:fitnessapp/routes.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // 👈 Use GetMaterialApp
      title: 'Fitness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor1,
        useMaterial3: true,
        fontFamily: "Poppins",
      ),
      initialRoute: SplashScreen.routeName,
      getPages: appRoutes, // 👈 Replace `routes:` with `getPages:`
    );
  }
}
