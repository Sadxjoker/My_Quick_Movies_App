import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordScreen extends StatefulWidget {
  final bool isFromLogin; // true = Forget Password, false = Change Password
  const ChangePasswordScreen({super.key, required this.isFromLogin});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final emailController = TextEditingController();
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();

  final supabase = Supabase.instance.client;
  bool loading = false;

  Future<void> resetPassword() async {
    try {
      setState(() => loading = true);
      await supabase.auth.resetPasswordForEmail(
        emailController.text.trim(),
      );
      Get.snackbar("Success", "Password reset email sent!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> changePassword() async {
    try {
      setState(() => loading = true);
      await supabase.auth.updateUser(
        UserAttributes(password: newPassController.text.trim()),
      );
      Get.snackbar("Success", "Password changed successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.deepOrange,
              size: 30,
            )),
        centerTitle: true,
        title: Text(
          widget.isFromLogin ? "Forgot Password" : "Change Password",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 2,
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isFromLogin) ...[
                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: loading ? null : resetPassword,
                    child: loading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: const CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.deepOrange),
                          )
                        : const Text("Send Reset Email"),
                  ),
                ] else ...[
                  TextField(
                    controller: newPassController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Enter new password",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: loading ? null : changePassword,
                    child: loading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: const CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.deepOrange))
                        : const Text("Change Password"),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
