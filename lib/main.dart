import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickmovies/Discover_Screen.dart';
import 'package:quickmovies/Home_Screen.dart';
import 'package:quickmovies/Profile_Screen.dart';
import 'package:quickmovies/Splash_Screen.dart';
import 'package:quickmovies/controllers/theme_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://szybzpodhznbkoydefce.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN6eWJ6cG9kaHpuYmtveWRlZmNlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA2OTA1MDgsImV4cCI6MjA2NjI2NjUwOH0.6pE2qcJSscH4cWhbormYIly8o4G2Sc5nn6L6rJceSF0',
  );

  // Theme controller for dynamic themes
  Get.put(ThemeController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final themeController = Get.put(ThemeController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeController.theme,
          home: const SplashScreen(), // ✅ Handles auto-login or signup screen
        ));
  }
}

class NavigationBottomBar extends StatefulWidget {
  const NavigationBottomBar({super.key});

  @override
  State<NavigationBottomBar> createState() => _NavigationBottomBarState();
}

class _NavigationBottomBarState extends State<NavigationBottomBar> {
  final List<Widget> screens = [
    HomeScreen(),
    DiscoverScreen(),
    ProfileScreen(),
  ];

  int currentIndex = 0;

  void changedIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: changedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/home1.png"),
            activeIcon: Image.asset("assets/icons/home2.png"),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/play1.png"),
            activeIcon: Image.asset("assets/icons/play2.png"),
            label: "Discover",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/person1.png", scale: 7.5),
            activeIcon: Image.asset("assets/icons/person2.png", scale: 7),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
