import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickmovies/Signup_Screen.dart';
import 'package:quickmovies/change_password_screen.dart';
import 'package:quickmovies/controllers/SignUp_controller.dart';
import 'package:quickmovies/controllers/theme_controller.dart';
import 'package:quickmovies/favorites_screen.dart';
import 'package:quickmovies/main.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Stack(
          children: [
            // Back Icon
            Positioned(
              top: 30,
              left: 5,
              child: IconButton(
                iconSize: 30,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NavigationBottomBar()));
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            // Background Circle
            Positioned(
              top: -140,
              left: 180,
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    height: 380,
                    width: 380,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color.fromARGB(255, 255, 119, 78)
                              .withOpacity(0.3),
                          const Color.fromARGB(255, 162, 39, 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Profile Image
            Positioned(
              top: 60,
              left: 100,
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/user_profile.png',
                      scale: 5,
                    ),
                  ),
                ),
              ),
            ),
            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 250),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Column(
                  //     children: [
                  //       _infoTile("Username",
                  //           user?.userMetadata?['username'] ?? "Not set"),
                  //       const SizedBox(height: 10),
                  //       _infoTile("Email", user?.email ?? "Not set"),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FutureBuilder(
                      future: SignupController().getUserProfile(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Skeleton loader
                          return Column(
                            children: [
                              _skeletonTile(),
                              const SizedBox(height: 10),
                              _skeletonTile(),
                            ],
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Text("No profile data found");
                        }

                        final profile = snapshot.data!;
                        return Column(
                          children: [
                            _infoTile(
                                "Username", profile['username'] ?? "Not set"),
                            const SizedBox(height: 10),
                            _infoTile("Email", profile['email'] ?? "Not set"),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 10),
                  // Theme container
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(221, 39, 39, 39),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Inside your theme container
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Themes",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: 18),
                                  ),
                                  SizedBox(width: 80),
                                  Obx(() => Row(
                                        children: [
                                          _buildThemeCircle(
                                            color: Colors.black,
                                            isSelected: themeController
                                                    .currentTheme.value ==
                                                AppTheme.dark,
                                            onTap: () => themeController
                                                .changeTheme(AppTheme.dark),
                                          ),
                                          const SizedBox(width: 10),
                                          _buildThemeCircle(
                                            color: Colors.blueGrey.shade900,
                                            isSelected: themeController
                                                    .currentTheme.value ==
                                                AppTheme.darkBlue,
                                            onTap: () => themeController
                                                .changeTheme(AppTheme.darkBlue),
                                          ),
                                          const SizedBox(width: 10),
                                          _buildThemeCircle(
                                            color: const Color(0xFF3B0A0A),
                                            isSelected: themeController
                                                    .currentTheme.value ==
                                                AppTheme.darkMaroon,
                                            onTap: () =>
                                                themeController.changeTheme(
                                                    AppTheme.darkMaroon),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 70,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(221, 39, 39, 39),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Favorites",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                              const SizedBox(width: 80),
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 12,
                                ),
                                onPressed: () {
                                  Get.to(() => FavoritesScreen());
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                                () => ChangePasswordScreen(isFromLogin: false));
                          },
                          child: Container(
                            height: 70,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(221, 39, 39, 39),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Change Password",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  // Logout Button
                  ElevatedButton(
                    onPressed: () async {
                      await Supabase.instance.client.auth.signOut();
                      Get.offAll(() => const SignupScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 253, 139, 105),
                              Color.fromARGB(255, 204, 68, 27)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text("Logout",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      height: 70,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(221, 39, 39, 39),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildThemeCircle({
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.deepOrangeAccent : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }
}

Widget _skeletonTile() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade800,
    highlightColor: Colors.grey.shade700,
    child: Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
