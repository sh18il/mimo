import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mimo_to/model/task_model.dart';

class TaskService {
  String refrence = "Task";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference<TaskModel> postData =
      firestore.collection(refrence).withConverter<TaskModel>(
            fromFirestore: (snapshot, options) =>
                TaskModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (value, options) => value.toJson(),
          );

  Future<void> addData(TaskModel model) async {
    try {
      await postData.add(model);
    } catch (e) {}
  }

  Future<void> deleteNotes(String id) async {
    try {
      await postData.doc(id).delete();
    } catch (e) {}
  }

  Future<void> updateData(TaskModel model, String id) async {
    try {
      await postData.doc(id).update(model.toJson());
    } catch (e) {}
  }

  Stream<QuerySnapshot<TaskModel>> getUserData(
      TaskModel model, String currentUserId) {
    try {
      if (model.uId == currentUserId) {
        return postData.where('uId', isEqualTo: currentUserId).snapshots();
      } else {
        return Stream<QuerySnapshot<TaskModel>>.empty();
      }
    } on FirebaseException catch (e) {
      return throw Exception(e);
      //  showErrorMessage(context, "error$e")
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
