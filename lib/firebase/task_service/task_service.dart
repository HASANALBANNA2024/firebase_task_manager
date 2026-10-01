import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Present user logged in
  String? get currentUserId => _auth.currentUser?.uid;

  /// ---------------Task Operation-----------------
  Future<bool> addTask({
    required String title,
    required String notes,
    required String category,
    required String priority,
    required String date,
    required String time,
    required bool remindMe,
  }) async {
    try {
      if (currentUserId == null) return false;
      await _firestore.collection('tasks').add({
        'userId': currentUserId,
        'title': title,
        'notes': notes,
        'category': category,
        'priority': priority,
        'remindMe': false,
        'date': date,
        'time': time,
        'isCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint("Error Adding task: $e");
      return false;
    }
  }

  /// task update
  Future<bool> updateTask({
    required String taskId,
    required String title,
    required String notes,
    required String category,
    required String priority,
    required String date,
    required String time,
    required bool remindMe,
    required bool isCompleted,
  }) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'title': title,
        'notes': notes,
        'category': category,
        'priority': priority,
        'date': date,
        'time': time,
        'remindMe': remindMe,
        'isCompleted': isCompleted,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      debugPrint("Error updating task: $e");
      return false;
    }
  }

  /// delete task
  Future<bool> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting task: $e');
      return false;
    }
  }

  ///  ---------------Profile Operations--------------
  Future<bool> createOrUpdateProfile({
    required String name,
    required String phone,
  }) async {
    try {
      if (currentUserId == null) return false;
      await _firestore.collection('tasks').doc(currentUserId).set({
        'uid': currentUserId,
        'name': name,
        'phone': phone,
        'email': _auth.currentUser?.email ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint("Error updating profile: $e");
      return false;
    }
  }

  final taskServiceProvider = Provider<TaskService>((ref) {
    return TaskService();
  });
}
