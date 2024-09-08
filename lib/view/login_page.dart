import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mimo_to/controller/auth_controller.dart';
import 'package:mimo_to/controller/theme_controller.dart';
import 'package:mimo_to/view/forgot_password_page%20.dart';
import 'package:mimo_to/view/home_page.dart';
import 'package:mimo_to/view/register_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provide = Provider.of<ThemeController>(context, listen: false);
    final heght = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(150),
              Center(
                child: Image(
                    image: provide.isDarkMode
                        ? const AssetImage(
                            "assets/__ui_todo-removebg-preview.png")
                        : const AssetImage(
                            "assets/todo_app_ui-removebg-preview.png")),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 17, left: 17),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Email"),
                    ),
                    const Gap(15),
                    TextFormField(
                      controller: passwordCtrl,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Password"),
                    ),
                    const Gap(5),
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
                    const Gap(15),
                    ElevatedButton(
                        style: ButtonStyle(
                            fixedSize: WidgetStateProperty.all(
                              Size(width * 0.9, 60),
                            ),
                            shape: WidgetStatePropertyAll(
                                BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(2))),
                            backgroundColor: const WidgetStatePropertyAll(
                                Color.fromARGB(255, 28, 97, 153))),
                        onPressed: () {
                          login(context);
                        },
                        child: const Text(
                          "CONTINUW",
                          style: TextStyle(color: Colors.white),
                        )),
                    const Gap(50),
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
      ),
    );
  }

  login(context) async {
    final provide = Provider.of<AuthController>(context, listen: false);

    User? user =
        await provide.signin(context, emailCtrl.text, passwordCtrl.text);
    if (user != null) {
      print("user secssus full login");
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
        (route) => false,
      );
    } else {
      print("some error happend");
    }
  }
}
