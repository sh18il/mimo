import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mimo_to/controller/auth_controller.dart';
import 'package:mimo_to/controller/theme_controller.dart';
import 'package:mimo_to/model/auth_model.dart';
import 'package:mimo_to/view/login_page.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  String? userPhotoUrl = FirebaseAuth.instance.currentUser?.photoURL;
  String? userid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Settings")),
        actions: [
          Consumer<ThemeController>(
            builder: (context, themeController, child) {
              return IconButton(
                onPressed: () => themeController.toggleTheme(),
                icon: Icon(
                  themeController.isDarkMode
                      ? Icons.brightness_2
                      : Icons.brightness_7,
                ),
              );
            },
          )
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
                    ClipRRect(
                      child: CircleAvatar(
                        backgroundImage: userPhotoUrl != null
                            ? NetworkImage(userPhotoUrl ?? "")
                            : const AssetImage('assets/images (4).jpeg')
                                as ImageProvider,
                        maxRadius: 30,
                      ),
                    ),
                    const Gap(20),
                    FutureBuilder<UserModel?>(
                      future: provider.getUserData(context, userid ?? ""),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                              child: Text('No user data available'));
                        } else {
                          final user = snapshot.data!;

                          return Column(
                            children: [
                              Text(user.username ?? ""),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ),
          const Gap(10),
          const Padding(
            padding: EdgeInsets.all(14),
            child: Text("Hi! I'm a community manager from Rabat.Morocco"),
          ),
          const Gap(30),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notification"),
          ),
          const Gap(6),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text("Genaral"),
          ),
          const Gap(6),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text("Account"),
          ),
          const Gap(6),
          const ListTile(
            leading: Icon(Icons.notification_important),
            title: Text("About"),
          ),
          const Gap(6),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.offAll(() => LoginPage());
            },
            child: const ListTile(
              leading: Icon(Icons.output_outlined),
              title: Text("LogOut"),
            ),
          ),
          const Gap(6),
        ],
      ),
    );
  }
}
