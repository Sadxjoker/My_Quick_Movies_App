import 'package:flutter/material.dart';
import 'package:quickmovies/Login_Screen.dart';
import 'package:quickmovies/controllers/SignUp_controller.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final controller = Get.put(SignupController());
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Stack(
              children: [
                // Background Circles
                Positioned(
                  top: -100,
                  left: -20,
                  child: Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color.fromARGB(255, 255, 119, 78),
                          const Color.fromARGB(255, 162, 39, 1),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/icons/app_icon2.png",
                          scale: 2,
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        "Create\nAccount",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                            labelText: "Username",
                            floatingLabelStyle:
                                TextStyle(color: Colors.deepOrangeAccent),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent))),
                        validator: (val) => val != null && val.length >= 4
                            ? null
                            : "Min 4 characters",
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: "Email",
                            floatingLabelStyle:
                                TextStyle(color: Colors.deepOrangeAccent),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent))),
                        validator: (val) => val != null && val.contains("@")
                            ? null
                            : "Enter valid email",
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: isObscure,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.white70),
                          floatingLabelStyle:
                              const TextStyle(color: Colors.deepOrangeAccent),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.deepOrangeAccent),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                          ),
                        ),
                        validator: (val) => val != null && val.length >= 6
                            ? null
                            : "Min 6 characters",
                      ),
                      const SizedBox(height: 30),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Get.to(() => const LoginScreen());
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(color: Colors.deepOrangeAccent),
                            ),
                          ),
                        ],
                      ),

                      // ✅ Sign Up Button with GetX Obx
                      Obx(
                        () => Center(
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      controller.registerUser(
                                        _emailController.text,
                                        _passwordController.text,
                                        _usernameController.text,
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 248, 80, 29),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.deepOrange,
                                  )
                                : Center(
                                    child: const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
