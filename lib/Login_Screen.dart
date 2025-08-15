import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quickmovies/change_password_screen.dart';
import 'package:quickmovies/controllers/SignUp_controller.dart';
import 'package:quickmovies/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  bool isObscure = true;
  bool showForgotPassword = false;

  Future<void> _loginUser() async {
    if (!formkey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        Get.snackbar("Success", "Login successful!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NavigationBottomBar()),
        );
      } else {
        Get.snackbar("Login Failed", "Invalid email or password.");
        setState(() => showForgotPassword = true);
      }
    } on AuthException catch (e) {
      Get.snackbar("Auth Error", e.message);
      setState(() => showForgotPassword = true);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 255, 113, 70),
                const Color.fromARGB(255, 149, 36, 2)
              ]),
        ),
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                Image.asset(
                  "assets/icons/app_icon2.png",
                  scale: 2,
                ),
                Text(
                  "Login Account",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                    const Color.fromARGB(255, 54, 54, 54),
                                    const Color.fromARGB(255, 22, 22, 22)
                                  ])),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                          labelText: 'Email',
                                          floatingLabelStyle: TextStyle(
                                              color: Colors.deepOrangeAccent),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white70),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors
                                                      .deepOrangeAccent))),
                                      validator: (val) =>
                                          val != null && val.contains('@')
                                              ? null
                                              : 'Enter a valid email',
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: isObscure,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        floatingLabelStyle: TextStyle(
                                            color: Colors.deepOrangeAccent),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white70)),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepOrangeAccent),
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
                                      validator: (val) =>
                                          val != null && val.length >= 6
                                              ? null
                                              : 'Min 6 characters required',
                                    ),
                                    const SizedBox(height: 15),
                                    ElevatedButton(
                                      onPressed: isLoading ? null : _loginUser,
                                      child: isLoading
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.deepOrange,
                                              ),
                                            )
                                          : Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.5)),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      const Color.fromARGB(
                                                          255, 255, 113, 70),
                                                      const Color.fromARGB(
                                                          255, 200, 48, 2)
                                                    ]),
                                              ),
                                              child: const Text(
                                                "Login",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                    ),
                                    if (showForgotPassword)
                                      TextButton(
                                        onPressed: () {
                                          Get.to(() => ChangePasswordScreen(
                                                isFromLogin: true,
                                              ));
                                        },
                                        child: const Text(
                                          "Forgot Password",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 70),
                      const Text(
                        "Or continue with",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final controller = Get.find<SignupController>();
                              await controller.signInWithGoogle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.google,
                                    color: Colors.deepOrange,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("Sign in with Google",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
