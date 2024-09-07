import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mimo_to/controller/theme_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Settings")),
        actions: [
          ElevatedButton(
            onPressed: () {
              themeController.toggleTheme();
            },
            child: Text('Toggle Theme'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 30,
                    ),
                    Gap(20),
                    Column(
                      children: [
                        Text("data"),
                        Text("data"),
                      ],
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ),
          Gap(10),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
                "Hi! My Name is ...., I'm a community manager from Rabat.Morocco"),
          ),
          Gap(30),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notification"),
          ),
          Gap(6),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Genaral"),
          ),
          Gap(6),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Account"),
          ),
          Gap(6),
          ListTile(
            leading: Icon(Icons.notification_important),
            title: Text("About"),
          ),
          Gap(6),
        ],
      ),
    );
  }
}
