import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mimo_to/controller/todo_controller.dart';
import 'package:mimo_to/model/todo_model.dart';
import 'package:mimo_to/service/todo_service.dart';
import 'package:provider/provider.dart';

class TodoPage extends StatelessWidget {
  final String task;
  final TextEditingController taskCtrl = TextEditingController();

  TodoPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(task)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: CircleAvatar(
        maxRadius: 30,
        child: FloatingActionButton(
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
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
                          onSubmitted: (value) {
                            addTask(context);
                            Navigator.of(context).pop();
                            taskCtrl.clear();
                          },
                          controller: taskCtrl,
                          decoration: InputDecoration(
                            hintText: 'Enter task details',
                          ),
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
      ),
      body: StreamBuilder<QuerySnapshot<TodoModel>>(
        stream: TodoService().getUserData(
          currentUserId ?? "",
          task,
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
                              context, taskData, tasks[index].id, value);
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

  Future<void> addTask(context) async {
    final provide = Provider.of<TodoController>(context, listen: false);
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && taskCtrl.text.isNotEmpty) {
      final data = TodoModel(
          taskname: taskCtrl.text,
          uId: uid,
          isCompleted: false,
          tasktitile: task);
      await provide.addTask(data);
    } else {
      print(
          'User is not logged in or task is empty'); // Handle error if necessary
    }
  }

  Future<void> updateTaskCompletion(
      context, TodoModel task, String taskId, bool isCompleted) async {
    final provide = Provider.of<TodoController>(context, listen: false);

    task.isCompleted = isCompleted;
    await provide.updateTask(task, taskId);
  }
}
