import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

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
                        onPressed: () {},
                        child: const Text("Forgot Password?")),
                  ],
                ),
                Gap(15),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize:
                        MaterialStateProperty.all(Size.fromWidth(width * 0.9)),
                    shape: MaterialStateProperty.all(BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(2))),
                    backgroundColor: MaterialStateProperty.all(
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
    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    try {
      // Set locale for Firebase
      FirebaseAuth.instance
          .setLanguageCode('en'); // Set to 'en' or your preferred language

      // Attempt to create a user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful'),
        ),
      );

      // Navigate to the next screen or perform any other action
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registration failed';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'The email is already in use.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email is invalid.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }
}
