import 'package:flutter/material.dart';
import 'package:mimo_to/service/task_service.dart';
import 'package:mimo_to/model/task_model.dart';

class TaskController extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  // Add a task
  Future<void> addTask(TaskModel task) async {
    await _taskService.addData(task);
    notifyListeners();
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    await _taskService.deleteNotes(id);
    notifyListeners();
  }

  // Update a task
  Future<void> updateTask(TaskModel task, String id) async {
    await _taskService.updateData(task, id);
    notifyListeners();
  }
}
