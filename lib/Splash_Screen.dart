import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickmovies/Signup_Screen.dart';
import 'package:quickmovies/main.dart'; // For NavigationBottomBar
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkAuthStatus(); // extracted for better readability
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // optional splash delay

    final session = Supabase.instance.client.auth.currentSession;
    print("🌟 Splash Session: $session");

    if (session != null) {
      Get.offAll(() => const NavigationBottomBar());
    } else {
      Get.offAll(() => const SignupScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/splash/splash_screen.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
