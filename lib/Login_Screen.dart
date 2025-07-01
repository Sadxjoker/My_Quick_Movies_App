import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickmovies/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
      }
    } on AuthException catch (e) {
      Get.snackbar("Auth Error", e.message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not launch $url");
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
                                          ? CircularProgressIndicator(
                                              color: Colors.deepOrangeAccent,
                                            )
                                          : Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: Colors.white
                                                        // ignore: deprecated_member_use
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
                                    )
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
                            onTap: () {
                              _launchURL("https://www.facebook.com");
                            },
                            child: Image.asset(
                              'assets/icons/facebook.png',
                              height: 45,
                              width: 45,
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              _launchURL("https://www.google.com");
                            },
                            child: Image.asset(
                              'assets/icons/google.png',
                              height: 45,
                              width: 45,
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
