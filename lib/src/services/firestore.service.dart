import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trancend/src/models/topic.model.dart';

abstract class FirestoreService {
  // FirestoreService() : super();
  late FirebaseFirestore db;
  Future<List<Topic>> getTopics();
  Future<Topic> getTopic(String id);
  CollectionReference<Topic> getTopicQuery();
}

class FirestoreServiceAdapter extends FirestoreService {
  FirestoreServiceAdapter() : super();
  @override
  FirebaseFirestore db = FirebaseFirestore.instance;

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
}
