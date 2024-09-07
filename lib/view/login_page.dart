import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mimo_to/service/auth_service.dart';
import 'package:mimo_to/view/forgot_password_page%20.dart';
import 'package:mimo_to/view/home_page.dart';
import 'package:mimo_to/view/register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final heght = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(150),
              Center(
                child: Text(
                  "mimo",
                  style: TextStyle(fontSize: 67, fontWeight: FontWeight.bold),
                ),
              ),
              Gap(20),
              Padding(
                padding: const EdgeInsets.only(right: 17, left: 17),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailCtrl,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Email"),
                    ),
                    Gap(15),
                    TextFormField(
                      controller: passwordCtrl,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Password"),
                    ),
                    Gap(5),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.to(() => ForgotPasswordPage(),
                                  transition: Transition.rightToLeft);
                            },
                            child: Text("Forgot Password?")),
                      ],
                    ),
                    Gap(15),
                    ElevatedButton(
                        style: ButtonStyle(
                            fixedSize: WidgetStatePropertyAll(
                                Size.copy(Size.fromWidth(width))),
                            shape: WidgetStatePropertyAll(
                                BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(2))),
                            backgroundColor: WidgetStatePropertyAll(
                                const Color.fromARGB(255, 28, 97, 153))),
                        onPressed: () {
                          login(context);
                        },
                        child: Text(
                          "CONTINUW",
                          style: TextStyle(color: Colors.white),
                        )),
                    Gap(50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                            onPressed: () {
                              Get.to(() => RegisterPage(),
                                  transition: Transition.fadeIn);
                            },
                            child: Text("Register"))
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
    AuthService service = AuthService();
    User? user =
        await service.signin(context, emailCtrl.text, passwordCtrl.text);
    if (user != null) {
      print("user secssus full login");
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
        (route) => false,
      );
    } else {
      print("some error happend");
    }
  }
}
