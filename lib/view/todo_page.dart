import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mimo_to/model/task_model.dart';
import 'package:mimo_to/model/todo_model.dart';
import 'package:mimo_to/service/todo_service.dart';

class TodoPage extends StatelessWidget {
  final String task;
  final TextEditingController taskCtrl = TextEditingController();

  TodoPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(task),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add search functionality here if needed
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                          ),
                        ),
                      ),
                      TextField(
                        controller: taskCtrl,
                        decoration: InputDecoration(
                          hintText: 'Enter task details',
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              addTask(); // Call the addTask method
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Add'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot<TodoModel>>(
        stream: TodoService().getUserData(
          currentUserId ?? "",
          task, // Assuming `task` contains the title you want to filter by
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tasks available'));
          } else {
            final tasks = snapshot.data!.docs;

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final taskData = tasks[index].data();
                return ListTile(
                  leading: Transform.scale(
                    scale: 1.4,
                    child: Checkbox(
                      side:
                          BorderSide(strokeAlign: BorderSide.strokeAlignInside),
                      activeColor: Colors.green,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      value: taskData.isCompleted ?? false,
                      onChanged: (bool? value) {
                        if (value != null) {
                          updateTaskCompletion(
                              taskData, tasks[index].id, value);
                        }
                      },
                    ),
                  ),
                  title: Text(taskData.taskname ?? ''),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> addTask() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && taskCtrl.text.isNotEmpty) {
      TodoService service = TodoService();
      final data = TodoModel(
          taskname: taskCtrl.text,
          uId: uid,
          isCompleted: false,
          tasktitile: task);
      await service.addData(data);
    } else {
      print(
          'User is not logged in or task is empty'); // Handle error if necessary
    }
  }

  Future<void> updateTaskCompletion(
      TodoModel task, String taskId, bool isCompleted) async {
    TodoService service = TodoService();
    task.isCompleted = isCompleted;
    await service.updateData(task, taskId);
  }
}
