import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mimo_to/model/todo_model.dart';

class TodoService {
  String reference = "Todo";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference<TodoModel> addPost =
      firestore.collection(reference).withConverter<TodoModel>(
            fromFirestore: (snapshot, options) =>
                TodoModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (value, options) => value.toJson(),
          );

  Future<void> addData(TodoModel model) async {
    try {
      await addPost.add(model);
    } catch (e) {
      print("Error adding data: $e");
    }
  }

  Future<void> deleteNotes(String id) async {
    try {
      await addPost.doc(id).delete();
    } catch (e) {
      print("Error deleting data: $e");
    }
  }

  Future<void> updateData(TodoModel model, String id) async {
    try {
      await addPost.doc(id).update(model.toJson());
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  Stream<QuerySnapshot<TodoModel>> getUserData(
      String currentUserId, String title) {
    try {
      return addPost
          .where('uId', isEqualTo: currentUserId)
          .where('titile', isEqualTo: title)
          .snapshots();
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
