// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trancend/src/models/goal.model.dart';
import 'package:trancend/src/models/settings.model.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/models/user.model.dart';

abstract class FirestoreService {
  // FirestoreService() : super();
  late FirebaseFirestore db;
  Future<User> getUser(String uid);
  Future<User> createUser(User user);
  Future<void> updateUser(User user);
  Future updateUserFromData(String uid, Map<String, dynamic> data);
  Future<UserSettings> getSettings(String settingsId);
  Future<UserSettings> createSettings(UserSettings settings);
  Future<void> updateSettings(UserSettings settings);
  Future<List<Topic>> getTopics();
  Future<Topic> getTopic(String id);
  CollectionReference<Topic> getTopicQuery();
  Future<Goal> getGoal(String id);
}

class FirestoreServiceAdapter extends FirestoreService {
  FirestoreServiceAdapter() : super();
  @override
  FirebaseFirestore db = FirebaseFirestore.instance;

  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection("users");

  @override
  Future<User> getUser(String uid) async {
    var userData = await _userRef.doc(uid).get();
    print('userData ${userData.exists} ${userData.data()}');
    if (!userData.exists || userData.data() == null) {
      throw Exception('User not found');
    }
    return User.fromMap(userData.data() as Map<String, dynamic>);
  }

  @override
  Future<User> createUser(User user) async {
    try {
      await db.collection("users").doc(user.uid).set(user.toJson());
      return getUser(user.uid);
    } catch (e) {
      print('error creating user $e');
      return user;
    }
  }

  @override
  Future<void> updateUser(User user) async {
    await _userRef.doc(user.uid).set(user.toJson(), SetOptions(merge: true));
  }

  @override
  Future updateUserFromData(String uid, Map<String, dynamic> data) async {
    await _userRef.doc(uid).update(data);
  }

  @override
  Future<UserSettings> getSettings(String id) async {
    var snapshot = await db.collection("settings").doc(id).get();
    return UserSettings.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  @override
  Future<UserSettings> createSettings(UserSettings settings) async {
    assert(settings != null || settings.uid != null);
    await db.collection("settings").doc(settings.uid).set(settings.toJson());
    return getSettings(settings.uid);
  }

  @override
  Future<void> updateSettings(UserSettings settings) async {
    await db
        .collection("settings")
        .doc(settings.uid)
        .set(settings.toJson(), SetOptions(merge: true));
  }

  @override
  Future<List<Topic>> getTopics() async {
    QuerySnapshot _snap = await db
        .collection("topics")
        .where("totalTracks", isGreaterThan: 10)
        .get();
    return _snap.docs
        .map((doc) => Topic.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  CollectionReference<Topic> getTopicQuery() {
    final collectionRef = db.collection('topics');

    return collectionRef.withConverter<Topic>(
      fromFirestore: (snapshot, _) => Topic.fromMap(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
  }

  @override
  Future<Topic> getTopic(String id) async {
    DocumentSnapshot _snap = await db.collection("topics").doc(id).get();
    return Topic.fromMap(_snap.data() as Map<String, dynamic>);
  }

  @override
  Future<Goal> getGoal(String id) async {
    var snapshot = await db.collection("goals").doc(id).get();
    if (!snapshot.exists) {
      throw Exception('Goal not found');
    }
    return Goal.fromMap(snapshot.data() as Map<String, dynamic>, id);
  }
}