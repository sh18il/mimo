import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mimo_to/controller/auth_controller.dart';
import 'package:mimo_to/view/login_page.dart';
import 'package:mimo_to/view/register_page.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final heght = MediaQuery.sizeOf(context).height * 1;

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(heght * 0.28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                const Text(
                  "Forgot Password",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                const Gap(20)
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  TextFormField(
                    controller: passwordCtrl,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Email"),
                  ),
                  const Column(
                    children: [
                      Text(
                        "Enter the email address You used to create your account and",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "we will email you a link to reset you password",
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const Gap(15),
                  ElevatedButton(
                      style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all(
                            Size(width * 0.9, 60),
                          ),
                          shape: WidgetStatePropertyAll(BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(2))),
                          backgroundColor: const WidgetStatePropertyAll(
                              Color.fromARGB(255, 28, 97, 153))),
                      onPressed: () {
                        forgetPass(context);
                      },
                      child: const Text(
                        "CONTINUW",
                        style: TextStyle(color: Colors.white),
                      )),
                  const Gap(40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Get.to(() => RegisterPage(),
                                transition: Transition.fadeIn);
                          },
                          child: const Text("Register"))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  forgetPass(BuildContext context) async {
    final authController = Provider.of<AuthController>(context, listen: false);

    await authController.forgotPassword(context, passwordCtrl.text).then((_) {
      Get.offAll(() => LoginPage());
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset password: $error')),
      );
    });
  }
}
