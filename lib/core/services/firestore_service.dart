import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTask({
    required String title,
    required DateTime date,
    required String startTime,
    required String endTime,
    required Color color,
    String status = 'inProgress',
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db.collection("tasks").add({
      "title": title,
      "date": date.toIso8601String(),
      "startTime": startTime,
      "endTime": endTime,
      "userId": user.uid,
      "status": status,
      "createdAt": FieldValue.serverTimestamp(),
      "color": color.value,
    });
  }

  Stream<QuerySnapshot> getTasks() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.empty();

    return _db
        .collection("tasks")
        .where("userId", isEqualTo: user.uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Stream<int> getPendingTasksCount() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value(0);

    return _db
        .collection("tasks")
        .where("userId", isEqualTo: user.uid)
        .where("status", whereIn: [
      "inProgress",
      "ongoing",
      "waitingForReview"
    ])
        .snapshots()
        .map((s) => s.docs.length);
  }

  Future<void> deleteTask(String id) async {
    await _db.collection("tasks").doc(id).delete();
  }

  Future<void> updateStatus(String id, String status) async {
    await _db.collection("tasks").doc(id).update({
      "status": status,
    });
  }


  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String email,
    String? photoUrl,
  }) async {
    await _db.collection("users").doc(uid).set({
      "name": name,
      "email": email,
      "photoUrl": photoUrl,
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot> getUserProfile() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.empty();

    return _db.collection("users").doc(user.uid).snapshots();
  }

  Future<void> updateUserName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db.collection("users").doc(user.uid).set({
      "name": name,
    }, SetOptions(merge: true));
  }

  Future<void> updateProfilePhoto(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db.collection("users").doc(user.uid).set({
      "photoUrl": url,
    }, SetOptions(merge: true));
  }
}