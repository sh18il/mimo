import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mimo_to/service/auth_service.dart';

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
                    icon: Icon(Icons.arrow_back)),
                Text(
                  "Forgot Password",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                Gap(20)
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  TextFormField(
                    controller: passwordCtrl,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Email"),
                  ),
                  Column(
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
                  Gap(15),
                  ElevatedButton(
                      style: ButtonStyle(
                          fixedSize: WidgetStatePropertyAll(
                              Size.copy(Size.fromWidth(width))),
                          shape: WidgetStatePropertyAll(BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(2))),
                          backgroundColor: WidgetStatePropertyAll(
                              const Color.fromARGB(255, 28, 97, 153))),
                      onPressed: () {},
                      child: Text(
                        "CONTINUW",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  forgetPass(BuildContext context) async {
    AuthService service = AuthService();
    await service.forgotPassword(context, passwordCtrl.text).then((_) {
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset password: $error')),
      );
    });
  }
}
