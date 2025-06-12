import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/services/auth_service.dart';
import 'package:fitnessapp/view/login/login_screen.dart';
import 'package:fitnessapp/view/profile/complete_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService authService = AuthService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool passwordVisible = false;
  bool isLoading = false;

  void _signUp() async {
    setState(() => isLoading = true);
    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      Get.snackbar("Error", "Passwords do not match", snackPosition: SnackPosition.BOTTOM);
      setState(() => isLoading = false);
      return;
    }

    try {
      await authService.signUpWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      // Success is handled in snapshot builder
    } catch (e) {
      Get.snackbar("Sign Up Failed", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Navigate if user is signed in
        if (snapshot.connectionState == ConnectionState.active && snapshot.data != null) {
          Future.microtask(() {
            Get.snackbar("Success", "Successfully Signed Up", snackPosition: SnackPosition.BOTTOM);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          });
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Sign Up"), centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
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
                TextField(
                  controller: confirmPasswordController,
                  obscureText: !passwordVisible,
                  decoration:  InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => passwordVisible = !passwordVisible), 
                      ), 
                    ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : _signUp,
                  child: isLoading ? const CircularProgressIndicator() : const Text('Register'),
                ),
                const SizedBox(height: 20),
                Row(children: const [Expanded(child: Divider()), Text(" OR "), Expanded(child: Divider())]),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Image.asset('assets/icons/google_icon.png', height: 24),
                  label: const Text("Continue with Google"),
                  onPressed: () => authService.signInWithGoogle(),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: Image.asset('assets/icons/facebook_icon.png', height: 24),
                  label: const Text("Continue with Facebook"),
                  onPressed: () => authService.signInWithFacebook(),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CompleteProfileScreen()),
                  ),
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
