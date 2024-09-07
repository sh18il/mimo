import 'package:flutter/material.dart';
import 'package:mimo_to/service/todo_service.dart';
import 'package:mimo_to/model/todo_model.dart';

class TodoController extends ChangeNotifier {
  final TodoService _todoService = TodoService();

  List<TodoModel> todos = [];

  bool isLoading = false;

  void fetchTasks(String currentUserId, String title) {
    isLoading = true;
    notifyListeners();

    _todoService.getUserData(currentUserId, title).listen((snapshot) {
      todos = snapshot.docs.map((doc) => doc.data()).toList();
      isLoading = false;
      notifyListeners();
    });
  }

  // Add a task
  Future<void> addTask(TodoModel task) async {
    isLoading = true;
    notifyListeners();

    await _todoService.addData(task);
    isLoading = false;
    notifyListeners();
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    isLoading = true;
    notifyListeners();

    await _todoService.deleteNotes(id);
    isLoading = false;
    notifyListeners();
  }

  // Update a task
  Future<void> updateTask(TodoModel task, String id) async {
    isLoading = true;
    notifyListeners();

    await _todoService.updateData(task, id);
    isLoading = false;
    notifyListeners();
  }
}
