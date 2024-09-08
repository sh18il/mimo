import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:mimo_to/controller/auth_controller.dart';
import 'package:mimo_to/view/forgot_password_page%20.dart';
import 'package:mimo_to/view/home_page.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          children: [
            Gap(height * 0.16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const Text(
                  "Create an Account",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                Gap(20),
              ],
            ),
            Gap(20),
            Column(
              children: [
                TextFormField(
                  controller: usernameCtrl,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Full Name"),
                ),
                Gap(15),
                TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                ),
                Gap(15),
                TextFormField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                ),
                Gap(15),
                TextFormField(
                  controller: confirmPasswordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Confirm Password"),
                ),
                Gap(5),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Get.to(() => ForgotPasswordPage(),
                              transition: Transition.rightToLeft);
                        },
                        child: const Text("Forgot Password?")),
                  ],
                ),
                Gap(15),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize:
                        WidgetStateProperty.all(Size.fromWidth(width * 0.9)),
                    shape: WidgetStateProperty.all(BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(2))),
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 28, 97, 153)),
                  ),
                  onPressed: () {
                    register(context);
                  },
                  child: const Text(
                    "CONTINUE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Gap(50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void register(BuildContext context) async {
    final authController = Provider.of<AuthController>(context, listen: false);

    User? user = await authController.signup(
        context, usernameCtrl.text, emailCtrl.text, passwordCtrl.text);

    if (user != null) {
      print("User successfully logged in");

      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
        (route) => false,
      );
    } else {
      print("An error occurred during login");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Login failed. Please check your credentials and try again.')),
      );
    }
  }
}
