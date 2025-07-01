import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppTheme { dark, darkBlue, darkMaroon }

class ThemeController extends GetxController {
  var currentTheme = AppTheme.dark.obs;

  ThemeData get theme {
    switch (currentTheme.value) {
      case AppTheme.darkBlue:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0A0E21),
          primaryColor: const Color(0xFF1D1E33),
        );
      case AppTheme.darkMaroon:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF3B0A0A),
          primaryColor: const Color(0xFF8B0000),
        );
      default:
        return ThemeData.dark();
    }
  }

  void changeTheme(AppTheme theme) {
    currentTheme.value = theme;
  }
}
