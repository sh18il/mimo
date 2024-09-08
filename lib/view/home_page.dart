import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mimo_to/controller/tasks_controller.dart';
import 'package:mimo_to/model/task_model.dart';
import 'package:mimo_to/model/todo_model.dart';
import 'package:mimo_to/service/task_service.dart';
import 'package:mimo_to/service/todo_service.dart';
import 'package:mimo_to/view/login_page.dart';
import 'package:mimo_to/view/todo_page.dart';
import 'package:mimo_to/view/widgets/profile_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String? userPhotoUrl = FirebaseAuth.instance.currentUser?.photoURL;
    String? currentuserId = FirebaseAuth.instance.currentUser?.uid;
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
              onPressed: () {},
              icon: const Icon(Icons.search),
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
                      print("Tasks length: ${tasks.length}");
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: tasks.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
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
                            var task = tasks[index - 1].data();
                            return GestureDetector(
                              onTap: () => Get.to(
                                  () => TodoPage(task: task.title ?? "")),
                              child: Card(
                                elevation: 8,
                                child: Container(
                                  decoration: BoxDecoration(),
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
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            StreamBuilder<
                                                QuerySnapshot<TodoModel>>(
                                              stream: TodoService().getUserData(
                                                currentuserId ?? "",
                                                task.title ?? "",
                                              ),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child: Text("0 Tasks"));
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                      child: Text(
                                                          'Error: ${snapshot.error}'));
                                                } else if (!snapshot.hasData ||
                                                    snapshot
                                                        .data!.docs.isEmpty) {
                                                  return Text('0 Tasks');
                                                } else {
                                                  final tasks =
                                                      snapshot.data!.docs;
                                                  final count = tasks.length;
                                                  return Text('$count Tasks');
                                                }
                                              },
                                            ),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                    Icons.more_vert_outlined))
                                          ],
                                        )
                                      ],
                                    ),
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
    TextEditingController iconController = TextEditingController(text: "🏡");

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
                  hintText: "🏡",
                  hintStyle: TextStyle(fontSize: 30),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
                ),
              ),
              TextField(
                onSubmitted: (value) {
                  String title = titleController.text;
                  String icon = iconController.text;
                  if (title.isNotEmpty && icon.isNotEmpty) {
                    _addItem(
                        context, title, icon); // Call the method to add item
                    Navigator.of(context).pop(); // Close the dialog
                  }
                },
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addItem(context, String title, String icon) async {
    final provider = Provider.of<TaskController>(context, listen: false);
    final data = TaskModel(
      uId: FirebaseAuth.instance.currentUser?.uid,
      title: title,
      description: icon,
      // timestamp: DateTime.now().toString(),
    );

    await provider.addTask(data);
  }
}
