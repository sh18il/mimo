import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mimo_to/model/task_model.dart';
import 'package:mimo_to/service/task_service.dart';
import 'package:mimo_to/view/login_page.dart';
import 'package:mimo_to/view/todo_page.dart';
import 'package:mimo_to/view/widgets/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    String? userPhotoUrl = FirebaseAuth.instance.currentUser?.photoURL;
    String? currentuserId = FirebaseAuth.instance.currentUser?.uid;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () =>
                Get.to(() => ProfilePage(), transition: Transition.leftToRight),
            child: CircleAvatar(
              backgroundImage: userPhotoUrl != null
                  ? NetworkImage(userPhotoUrl)
                  : const AssetImage('assets/images (4).jpeg') as ImageProvider,
              maxRadius: 20,
            ),
          ),
          leadingWidth: 40,
          title: const Center(child: Text("Categories")),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Get.offAll(
                    () => LoginPage()); // Navigate to login page after sign out
              },
              icon: const Icon(Icons.output_rounded),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8,
                child: Container(
                  width: width,
                  height: 100,
                  child: Row(
                    children: [
                      ClipRRect(
                        child: CircleAvatar(
                          backgroundImage: userPhotoUrl != null
                              ? NetworkImage(userPhotoUrl)
                              : const AssetImage('assets/images (4).jpeg')
                                  as ImageProvider,
                          maxRadius: 30,
                        ),
                      ),
                      const Gap(10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("The memories is a shield and life helper"),
                          Text("Tamim AI - Barghouti")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot<TaskModel>>(
                  stream: TaskService().getUserData(
                      TaskModel(uId: currentuserId), currentuserId ?? ""),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.hasData) {
                      List<QueryDocumentSnapshot<TaskModel>> tasks =
                          snapshot.data?.docs ?? [];
                      print("Tasks length: ${tasks.length}"); // Debugging
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.32,
                        ),
                        itemCount:
                            tasks.length + 1, // Add one for the add button
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // Button to add new items
                            return GestureDetector(
                              onTap: () {
                                _showAddItemDialog(context);
                              },
                              child: Card(
                                elevation: 4,
                                child: Center(
                                  child: CircleAvatar(
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // Display other items
                            var task = tasks[index - 1]
                                .data(); // Adjust index for items
                            return GestureDetector(
                              onTap: () => Get.to(
                                  () => TodoPage(task: task.title ?? "")),
                              child: Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.description ?? "",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                      Gap(15),
                                      Text(
                                        task.title ?? 'No Title',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      return Center(
                        child: Text('No data available.'),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController iconController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.text,
                controller: iconController,
                decoration: const InputDecoration(
                  hintText: "Add Emoji",
                ),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Enter Title",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: const Text("Add"),
              onPressed: () {
                String title = titleController.text;
                String icon = iconController.text;
                if (title.isNotEmpty && icon.isNotEmpty) {
                  _addItem(title, icon); // Call the method to add item
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addItem(String title, String icon) async {
    TaskService service = TaskService();
    final data = TaskModel(
      uId: FirebaseAuth.instance.currentUser?.uid,
      title: title,
      description: icon,
      // timestamp: DateTime.now().toString(), // Add timestamp here if needed
    );

    await service.addData(data);
  }
}
