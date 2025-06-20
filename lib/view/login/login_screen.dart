import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/services/auth_service.dart';
import 'package:fitnessapp/view/profile/complete_profile_screen.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordVisible = false;
  bool isLoading = false;
  bool hasNavigated = false;

  void _login() async {
    setState(() => isLoading = true);

    try {
      await authService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      // Navigation will be handled in StreamBuilder
    } catch (e) {
      Get.snackbar("Login Failed", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.data != null &&
            !hasNavigated) {
          hasNavigated = true;
          Future.microtask(() {
            Get.snackbar("Success", "Logged in Successfully", snackPosition: SnackPosition.BOTTOM);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CompleteProfileScreen()),
            );
          });
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Login"), centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: !passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => passwordVisible = !passwordVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
                const SizedBox(height: 20),
                Row(children: const [Expanded(child: Divider()), Text(" OR "), Expanded(child: Divider())]),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Image.asset('assets/icons/google_icon.png', height: 24),
                  label: const Text("Continue with Google"),
                  onPressed: () async {
                    try {
                      final user = await authService.signInWithGoogle();
                      if (user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const CompleteProfileScreen()),
                        );
                      }
                    } catch (e) {
                      Get.snackbar("Google Sign-In Failed", e.toString(), snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: Image.asset('assets/icons/facebook_icon.png', height: 24),
                  label: const Text("Continue with Facebook"),
                  onPressed: () async {
                    try {
                      final user = await authService.signInWithFacebook();
                      if (user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const CompleteProfileScreen()),
                        );
                      }
                    } catch (e) {
                      Get.snackbar("Facebook Sign-In Failed", e.toString(), snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  ),
                  child: const Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
