import 'package:get/get.dart';
import 'package:quickmovies/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupController extends GetxController {
  final isLoading = false.obs;

  Future<void> registerUser(
      String email, String password, String username) async {
    isLoading.value = true;

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username}, // Goes into user_metadata
      );

      if (response.user != null || response.session != null) {
        Get.snackbar("Signup Successful", "Logging you in...");
        await Future.delayed(const Duration(seconds: 3));

        // Already logged in after signup (no need to call login again)
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
}
