import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickmovies/Splash_Screen.dart';
import 'package:quickmovies/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupController extends GetxController {
  final isLoading = false.obs;

  /// Email/Password Signup
  Future<void> registerUser(
      String email, String password, String username) async {
    isLoading.value = true;

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user != null) {
        // Save to user_data table
        await Supabase.instance.client.from('user_data').insert({
          'user_uid': user.id,
          'email': email,
          'username': username,
        });

        Get.snackbar("Signup Successful", "Logging you in...");
        await Future.delayed(const Duration(seconds: 3));
        Get.offAll(() => const NavigationBottomBar());
      } else {
        Get.snackbar("Signup Failed", "Please try again.");
      }
    } on AuthException catch (e) {
      if (e.message.contains("already registered")) {
        Get.snackbar("Already Registered", "Please login instead.");
      } else {
        Get.snackbar("Auth Error", e.message);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Email/Password Login
  Future<void> loginUser(String email, String password) async {
    isLoading.value = true;

    try {
      final response = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);

      if (response.user != null) {
        Get.snackbar("Login Successful", "Welcome back!");
        Get.offAll(() => const NavigationBottomBar());
      } else {
        Get.snackbar("Login Failed", "Invalid credentials.");
      }
    } on AuthException catch (e) {
      Get.snackbar("Auth Error", e.message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Google Sign-In (cleaned - no isFromSignup)
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      const webClientId =
          '441009367228-pf5lhek588ppi2oho44gd0m3f4luo96f.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
        scopes: ['email', 'profile'],
      );

      await googleSignIn.signOut(); // Ensure fresh login
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        Get.snackbar("Cancelled", "Google Sign-In cancelled by user");
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;
      print("✅ ID Token: ${googleAuth.idToken}");
      print("✅ Access Token: ${googleAuth.accessToken}");
      if (idToken == null || accessToken == null) {
        Get.snackbar("Error", "Missing Google Auth token");
        return;
      }
      // Sign in with Supabase using Google OAuth
      final authResponse = await Supabase.instance.client.auth
          .signInWithIdToken(
              provider: OAuthProvider.google,
              idToken: idToken,
              accessToken: accessToken);

      final user = authResponse.user;
      if (user == null) {
        Get.snackbar("Login Failed", "Supabase did not return a user");
        return;
      }

      // Save to user_data table if not already
      final existing = await Supabase.instance.client
          .from('user_data')
          .select()
          .eq('user_uid', user.id)
          .maybeSingle();

      if (existing == null) {
        await Supabase.instance.client.from('user_data').insert({
          'user_uid': user.id,
          'email': googleUser.email,
          'username': googleUser.displayName ?? 'Google User',
        });
      }

      Get.offAll(() => const NavigationBottomBar());

      Future.delayed(const Duration(milliseconds: 500), () {
        Get.snackbar(
          "Welcome 👋",
          "Hello, ${googleUser.displayName ?? 'User'}!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.85),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
        );
      });
    } catch (e) {
      Get.snackbar(
        "Google Sign-In Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      Get.offAll(() => const SplashScreen());
    } catch (e) {
      Get.snackbar("Logout Failed", e.toString());
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    final data = await Supabase.instance.client
        .from('user_data')
        .select()
        .eq('user_uid', user.id)
        .maybeSingle();

    return data;
  }
}
