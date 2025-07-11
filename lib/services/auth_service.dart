import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/services/sharedPref_service.dart';
import 'package:fitnessapp/view/profile/complete_profile_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign up with email & password
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw Exception("Sign up failed: ${e.toString()}");
    }
  }

  // Login with email & password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
  }

  // Sign in with Google
 Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      Get.snackbar("Cancelled", "Google sign-in was cancelled.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential result =
        await _auth.signInWithCredential(credential);

    if (result.user != null) {
      // ✅ Split the full name into first and last names
      final displayName = googleUser.displayName ?? "";
      final names = displayName.split(" ");
      final firstName = names.isNotEmpty ? names.first : "User";
      final lastName = names.length > 1 ? names.sublist(1).join(" ") : "";

      // ✅ Store names in SharedPreferences
      await SharedPrefsService().saveUserName(
        firstName: firstName,
        lastName: lastName,
      );

      Get.snackbar("Success", "Signed in with Google",
          snackPosition: SnackPosition.BOTTOM);

      // ✅ Forward to complete profile screen
      Get.offAllNamed(CompleteProfileScreen.routeName);
    }
  } catch (e) {
    Get.snackbar("Error", "Google sign-in failed: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM);
  }
}


  // Sign in with Facebook
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status != LoginStatus.success) {
        throw Exception('Facebook login failed');
      }

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      final result = await _auth.signInWithCredential(facebookAuthCredential);
      return result.user;
    } catch (e) {
      throw Exception("Facebook sign-in failed: ${e.toString()}");
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }
}
