// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trancend/src/models/goal.model.dart';
import 'package:trancend/src/models/settings.model.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/models/user_topic.model.dart';
import 'package:trancend/src/models/trance.model.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/models/played_track.model.dart';
import 'package:trancend/src/models/track.model.dart';

abstract class FirestoreService {
  late FirebaseFirestore db;
  Future<User> getUser(String uid);
  Future<User> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> updateUserFromData(String uid, Map<String, dynamic> data);
  Future<UserSettings?> getSettings(String uid);
  Future<void> updateSettings(String uid, UserSettings settings);
  Future<List<Topic>> getTopics();
  Future<Topic> getTopic(String id);
  CollectionReference<Topic> getTopicQuery();
  Future<Goal> getGoal(String id);
  Stream<User> watchUser(String uid);
  Stream<UserSettings?> watchSettings(String uid);
  Stream<List<UserTopic>> watchUserTopics(String uid);
  Future<void> toggleTopicFavorite(String uid, String topicId);
  Future<List<UserTopic>> getUserTopics(String uid);
  Future<void> updateUserTopic(String uid, UserTopic userTopic);
  Future<UserSettings> createSettings(UserSettings settings);
  Future<List<UserInduction>> getUserInductions(String uid);
  Future<UserInduction> createUserInduction(UserInduction userInduction);
  Future<void> updateUserInduction(UserInduction userInduction);
  Future<List<UserAwakening>> getUserAwakenings(String uid);
  Future<UserAwakening> createUserAwakening(UserAwakening userAwakening);
  Future<void> updateUserAwakening(UserAwakening userAwakening);
  Future<List<UserDeepening>> getUserDeepenings(String uid);
  Future<UserDeepening> createUserDeepening(UserDeepening userDeepening);
  Future<void> updateUserDeepening(UserDeepening userDeepening);
  Future<Session> getSession(String id);
  Future<List<Session>> getSessions(String uid, {DateTime? startDate, DateTime? endDate});
  Future<Session> createSession(Session session);
  Future<void> updateSession(Session session);
  Future<void> removeSession(String id);
  Future<void> savePlayedTrack(PlayedTrack playedTrack);
  Future<List<PlayedTrack>> getPlayedTracks(String uid, {DateTime? startDate, DateTime? endDate});
  Future<List<Track>> getTracksFromTopic(Topic topic);
  Future<UserSettings?> getUserSettings(String uid);
  Stream<UserSettings?> getUserSettingsStream(String uid);
}

class FirestoreServiceAdapter extends FirestoreService {
  FirestoreServiceAdapter() : super();
  @override
  FirebaseFirestore db = FirebaseFirestore.instance;

  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection("users");

  CollectionReference _userDataRef(String uid) =>
      FirebaseFirestore.instance.collection("userData").doc(uid).collection("data");

  @override
  Future<User> getUser(String uid) async {
    var userData = await _userRef.doc(uid).get();
    print('userData ${userData.exists} ${userData.data()}');
    if (!userData.exists || userData.data() == null) {
      throw Exception('User not found');
    }
    final data = Map<String, dynamic>.from(userData.data() as Map<String, dynamic>);
    data['uid'] = uid;
    return User.fromJson(data);
  }

  @override
  Future<User> createUser(User user) async {
    // Create user profile
    await _userRef.doc(user.uid).set(user.toJson());
    
    // Initialize default settings in userData
    final defaultSettings = UserSettings(
      uid: user.uid,
      statsStartDate: DateTime.now().millisecondsSinceEpoch,
      statsEndDate: DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
      delaySeconds: 3,
      maxHours: 1,
      useCellularData: false,
      usesDeepening: true,
      usesOwnDeepening: false
    );
    await _userDataRef(user.uid).doc('settings').set(defaultSettings.toJson());
    
    // Initialize topics collection
    await _userDataRef(user.uid).doc('topics').set({'initialized': true});
    
    return user;
  }

  @override
  Future<void> updateUser(User user) async {
    await _userRef.doc(user.uid).update(user.toJson());
  }

  @override
  Future<void> updateUserFromData(String uid, Map<String, dynamic> data) async {
    await _userRef.doc(uid).update(data);
  }

  @override
  Future<UserSettings?> getSettings(String uid) async {
    final doc = await _userDataRef(uid).doc("settings").get();
    if (!doc.exists || doc.data() == null) return null;
    final data = Map<String, dynamic>.from(doc.data() as Map<String, dynamic>);
    data['uid'] = uid;
    return UserSettings.fromJson(data);
  }

  @override
  Future<void> updateSettings(String uid, UserSettings settings) async {
    await _userDataRef(uid).doc('settings').set(settings.toJson());
  }

  @override
  Future<List<Topic>> getTopics() async {
    var topicsData = await db.collection('topics').where('totalTracks', isGreaterThan: 8).get();
    try {
      return topicsData.docs.map((doc) {
        final data = doc.data();
        
        // Handle numeric conversions safely
        double totalDuration = 0.0;
        if (data['totalDuration'] != null) {
          if (data['totalDuration'] is num) {
            totalDuration = (data['totalDuration'] as num).toDouble();
          } else if (data['totalDuration'] is String) {
            totalDuration = double.tryParse(data['totalDuration'] as String) ?? 0.0;
          }
        }

        int totalFileSize = 0;
        if (data['totalFileSize'] != null) {
          if (data['totalFileSize'] is num) {
            totalFileSize = (data['totalFileSize'] as num).toInt();
          } else if (data['totalFileSize'] is String) {
            totalFileSize = int.tryParse(data['totalFileSize'] as String) ?? 0;
          }
        }

        int totalTracks = 0;
        if (data['totalTracks'] != null) {
          if (data['totalTracks'] is num) {
            totalTracks = (data['totalTracks'] as num).toInt();
          } else if (data['totalTracks'] is String) {
            totalTracks = int.tryParse(data['totalTracks'] as String) ?? 0;
          }
        }

        return Topic.fromJson({
          'id': doc.id,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'icon': data['icon'] ?? '',
          'image': data['image'] ?? '',
          'svg': data['svg'] ?? '',
          'group': data['group'] ?? '',
          'goal': data['goal'] ?? '',
          'activeVerb': data['activeVerb'] ?? '',
          'totalDuration': totalDuration,
          'totalFileSize': totalFileSize,
          'totalTracks': totalTracks,
          'isDefault': data['isDefault'] ?? false,
          'isPremium': data['isPremium'] ?? false,
          'isMentalHealth': data['isMentalHealth'] ?? false,
          'isPriority': data['isPriority'] ?? false,
        });
      }).toList();
    } catch (e) {
      print("ERROR--->>${e}");
      return [];
    }
  }

  @override
  Future<Topic> getTopic(String id) async {
    var topicData = await db.collection('topics').doc(id).get();
    if (!topicData.exists || topicData.data() == null) {
      throw Exception('Topic not found');
    }
    final data = topicData.data()!;
    return Topic.fromJson({
      'id': id,
      'title': data['title'] ?? '',
      'description': data['description'] ?? '',
      'icon': data['icon'] ?? '',
      'image': data['image'] ?? '',
      'svg': data['svg'] ?? '',
      'group': data['group'] ?? '',
      'goal': data['goal'] ?? '',
      'activeVerb': data['activeVerb'] ?? '',
      'totalDuration': (data['totalDuration'] ?? 0.0).toDouble(),
      'totalFileSize': data['totalFileSize'] ?? 0,
      'totalTracks': data['totalTracks'] ?? 0,
      'isDefault': data['isDefault'] ?? false,
      'isPremium': data['isPremium'] ?? false,
      'isMentalHealth': data['isMentalHealth'] ?? false,
      'isPriority': data['isPriority'] ?? false,
      'price': (data['price'] ?? 0.0).toDouble(),
      'isLocked': data['isLocked'] ?? false,
      'strength': (data['strength'] ?? 0.0).toDouble(),
    });
  }

  @override
  CollectionReference<Topic> getTopicQuery() {
    return db.collection('topics').withConverter<Topic>(
      fromFirestore: (snapshot, _) {
        final data = snapshot.data()!;
        return Topic.fromJson({
          'id': snapshot.id,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'icon': data['icon'] ?? '',
          'image': data['image'] ?? '',
          'svg': data['svg'] ?? '',
          'group': data['group'] ?? '',
          'goal': data['goal'] ?? '',
          'activeVerb': data['activeVerb'] ?? '',
          'totalDuration': (data['totalDuration'] ?? 0.0).toDouble(),
          'totalFileSize': data['totalFileSize'] ?? 0,
          'totalTracks': data['totalTracks'] ?? 0,
          'isDefault': data['isDefault'] ?? false,
          'isPremium': data['isPremium'] ?? false,
          'isMentalHealth': data['isMentalHealth'] ?? false,
          'isPriority': data['isPriority'] ?? false,
          'price': (data['price'] ?? 0.0).toDouble(),
          'isLocked': data['isLocked'] ?? false,
          'strength': (data['strength'] ?? 0.0).toDouble(),
        });
      },
      toFirestore: (topic, _) => topic.toJson(),
    );
  }

  @override
  Future<Goal> getGoal(String id) async {
    var goalData = await db.collection('goals').doc(id).get();
    if (!goalData.exists || goalData.data() == null) {
      throw Exception('Goal not found');
    }
    return Goal.fromJson({...goalData.data()!, 'id': id});
  }

  @override
  Stream<User> watchUser(String uid) {
    return _userRef.doc(uid).snapshots().map(
          (doc) {
            final data = Map<String, dynamic>.from(doc.data() as Map<String, dynamic>);
            data['uid'] = doc.id;
            return User.fromJson(data);
          },
        );
  }

  @override
  Stream<UserSettings?> watchSettings(String uid) {
    return _userDataRef(uid)
        .doc('settings')
        .snapshots()
        .map((doc) => doc.exists && doc.data() != null 
            ? UserSettings.fromJson(Map<String, dynamic>.from(doc.data() as Map<String, dynamic>)..['uid'] = uid)
            : null);
  }

  @override
  Stream<List<UserTopic>> watchUserTopics(String uid) {
    return _userDataRef(uid)
        .doc('topics')
        .collection('topics')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = Map<String, dynamic>.from(doc.data() as Map<String, dynamic>);
              data['id'] = doc.id;
              data['uid'] = uid;
              return UserTopic.fromJson(data);
            }).toList());
  }

  @override
  Future<void> toggleTopicFavorite(String uid, String topicId) async {
    final userTopicRef = _userDataRef(uid).doc('topics').collection('topics').doc(topicId);
    final userTopic = await userTopicRef.get();
    
    if (userTopic.exists) {
      final data = userTopic.data() as Map<String, dynamic>;
      await userTopicRef.update({'isFavorite': !(data['isFavorite'] ?? false)});
    } else {
      // Create new UserTopic document if it doesn't exist
      await userTopicRef.set({
        'id': topicId,
        'uid': uid,
        'topicId': topicId,
        'isFavorite': true,
        'lastAccessed': DateTime.now().toIso8601String(),
        'accessCount': 0
      });
    }
  }

  @override
  Future<List<UserTopic>> getUserTopics(String uid) async {
    try {
      print("Getting user topics for uid: $uid");
      final snapshot = await _userDataRef(uid)
          .doc('topics')
          .collection('topics')
          .get();
      
      print("User topics snapshot: ${snapshot.docs.length} documents");
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        data['uid'] = uid;
        print("User topic data: $data");
        return UserTopic.fromJson(data);
      }).toList();
    } catch (e, st) {
      print("Error getting user topics: $e\n$st");
      return [];
    }
  }

  @override
  Future<void> updateUserTopic(String uid, UserTopic userTopic) async {
    await _userDataRef(uid)
        .doc('topics')
        .collection('topics')
        .doc(userTopic.id)
        .set(userTopic.toJson());
  }

  @override
  Future<UserSettings> createSettings(UserSettings settings) async {
    final docRef = _userDataRef(settings.uid).doc('settings');
    await docRef.set(settings.toJson());
    return settings;
  }

  @override
  Future<List<UserInduction>> getUserInductions(String uid) async {
    QuerySnapshot _snap = await db
        .collection("userInductions")
        .where("uid", isEqualTo: uid)
        .get();
    return _snap.docs.map((doc) => UserInduction.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Future<UserInduction> createUserInduction(UserInduction userInduction) async {
    var data = userInduction.toJson();
    DocumentReference _ref = await db.collection("userInductions").add(data);
    await db.collection("userInductions").doc(_ref.id).update({"id": _ref.id});
    DocumentSnapshot doc = await _ref.get();
    return UserInduction.fromMap(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> updateUserInduction(UserInduction userInduction) async {
    var data = userInduction.toJson();
    await db.collection("userInductions").doc(userInduction.id).update(data);
  }

  @override
  Future<List<UserAwakening>> getUserAwakenings(String uid) async {
    QuerySnapshot _snap = await db
        .collection("userAwakenings")
        .where("uid", isEqualTo: uid)
        .get();
    return _snap.docs.map((doc) => UserAwakening.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Future<UserAwakening> createUserAwakening(UserAwakening userAwakening) async {
    var data = userAwakening.toJson();
    DocumentReference _ref = await db.collection("userAwakenings").add(data);
    await db.collection("userAwakenings").doc(_ref.id).update({"id": _ref.id});
    DocumentSnapshot doc = await _ref.get();
    return UserAwakening.fromMap(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> updateUserAwakening(UserAwakening userAwakening) async {
    var data = userAwakening.toJson();
    await db.collection("userAwakenings").doc(userAwakening.id).update(data);
  }

  @override
  Future<List<UserDeepening>> getUserDeepenings(String uid) async {
    QuerySnapshot _snap = await db
        .collection("userDeepenings")
        .where("uid", isEqualTo: uid)
        .get();
    return _snap.docs.map((doc) => UserDeepening.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Future<UserDeepening> createUserDeepening(UserDeepening userDeepening) async {
    var data = userDeepening.toJson();
    DocumentReference _ref = await db.collection("userDeepenings").add(data);
    await db.collection("userDeepenings").doc(_ref.id).update({"id": _ref.id});
    DocumentSnapshot doc = await _ref.get();
    return UserDeepening.fromMap(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> updateUserDeepening(UserDeepening userDeepening) async {
    var data = userDeepening.toJson();
    await db.collection("userDeepenings").doc(userDeepening.id).update(data);
  }

  @override
  Future<Session> getSession(String id) async {
    var snapshot = await db.collection("sessions").doc(id).get();
    return Session.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  @override
  Future<List<Session>> getSessions(String uid, {DateTime? startDate, DateTime? endDate}) async {
    endDate ??= DateTime.now();

    QuerySnapshot _snap = await db
        .collection("sessions")
        .where("uid", isEqualTo: uid)
        .where("finishedTime", isGreaterThan: startDate?.millisecondsSinceEpoch)
        .where("finishedTime", isLessThan: endDate.millisecondsSinceEpoch)
        .get();
    return _snap.docs.map((doc) => Session.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Future<Session> createSession(Session session) async {
    var data = session.toJson();
    DocumentReference _sessionReference = await db.collection("sessions").add(data);
    await db.collection("sessions").doc(_sessionReference.id).update({"id": _sessionReference.id});
    return getSession(_sessionReference.id);
  }

  @override
  Future<void> updateSession(Session session) async {
    await db.collection("sessions").doc(session.id).set(session.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> removeSession(String id) async {
    DocumentReference _session = db.collection('sessions').doc(id);
    DocumentSnapshot session = await _session.get();
    if (session.exists) {
      await _session.delete();
    }
  }

  @override
  Future<void> savePlayedTrack(PlayedTrack playedTrack) async {
    await db.collection("playedTracks").add(playedTrack.toJson());
  }

  @override
  Future<List<PlayedTrack>> getPlayedTracks(String uid, {DateTime? startDate, DateTime? endDate}) async {
    endDate ??= DateTime.now();

    QuerySnapshot _snap = await db
        .collection("playedTracks")
        .where("uid", isEqualTo: uid)
        .where("created", isGreaterThan: startDate?.millisecondsSinceEpoch)
        .where("created", isLessThan: endDate.millisecondsSinceEpoch)
        .get();
    return _snap.docs.map((doc) => PlayedTrack.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Track>> getTracksFromTopic(Topic topic) async {
    List<Track> _tracks = [];
    print('Getting tracks from topic: ${topic.id}');
    QuerySnapshot _snap = await db
        .collection("tracks")
        .where("topic", isEqualTo: topic.id)
        // .where("approved", isEqualTo: true)
        .get();
    print('Tracks: ${_snap.docs.length}');
    if (_snap.docs.isNotEmpty) {
      _tracks = _snap.docs.map((doc) => Track.fromMap(doc.data() as Map<String, dynamic>)).toList();
      print('Tracks: ${_tracks.length}');
    }
    return _tracks;
  }

  @override
  Future<UserSettings?> getUserSettings(String uid) async {
    try {
      final doc = await db.collection('userSettings').doc(uid).get();
      if (!doc.exists) {
        // Create default settings if none exist
        final defaultSettings = UserSettings(
          uid: uid,
          statsStartDate: DateTime.now().millisecondsSinceEpoch,
          statsEndDate: DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
          delaySeconds: 3,
          maxHours: 8,
          useCellularData: true,
          usesDeepening: false,
          usesOwnDeepening: false,
        );
        await db.collection('userSettings').doc(uid).set(defaultSettings.toJson());
        return defaultSettings;
      }
      return UserSettings.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting user settings: $e');
      return null;
    }
  }

  @override
  Stream<UserSettings?> getUserSettingsStream(String uid) {
    return db
        .collection('userSettings')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserSettings.fromJson(doc.data() as Map<String, dynamic>) : null);
  }
}