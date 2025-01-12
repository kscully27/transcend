import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/constants/enums.dart';
import 'package:trancend/src/models/topic.model.dart';

class Playlist {
  String id;
  String uid;
  String title;
  CategoryColor primaryColor;
  List<Topic> topics;
  bool isPrimary;
  int lastPlayed;
  int totalTimesPlayed;
  int totalDurationPlayed;
  int lastDuration;
  int created;

  Playlist({
    required this.id,
    required this.uid,
    required this.title,
    required this.primaryColor,
    required this.topics,
    this.isPrimary = false,
    int? lastPlayed,
    this.totalTimesPlayed = 0,
    this.totalDurationPlayed = 0,
    this.lastDuration = 0,
    int? created,
  }) : 
    this.lastPlayed = lastPlayed ?? DateTime.now().millisecondsSinceEpoch,
    this.created = created ?? DateTime.now().millisecondsSinceEpoch;

  factory Playlist.fromMap(Map<String, dynamic> data) {
    try {
      return Playlist(
        title: data['title'] ?? "General",
        primaryColor: enumFromString(data['appColor'], CategoryColor.values) ?? CategoryColor.Blue,
        id: data['id'],
        uid: data['uid'],
        lastPlayed: data['lastPlayed'] ?? DateTime.now().millisecondsSinceEpoch,
        created: data['created'] ?? DateTime.now().millisecondsSinceEpoch,
        topics: (data['topics'] as List<dynamic>? ?? [])
            .map((data) => Topic.fromJson(data as Map<String, dynamic>))
            .toList(),
        isPrimary: data['isPrimary'] ?? false,
        totalTimesPlayed: data['totalTimesPlayed'] ?? 0,
        totalDurationPlayed: data['totalDurationPlayed'] ?? 0,
        lastDuration: data['lastDuration'] ?? 0,
      );
    } catch (e) {
      print("error getting playlist --> $e");
      throw Exception('Failed to create Playlist from map: $e');
    }
  }

  int paidTopics(List<Topic> allTopics) {
    return topics.where((t) {
      final topic = allTopics.cast<Topic?>().firstWhere(
            (_t) => _t?.id == t.id,
            orElse: () => null,
          );
      return topic?.isPremium == true;
    }).length;
  }

  List<Topic> get freeTopics => 
      topics.where((t) => t.isPremium != true).toList();
      
  List<Topic> get premiumTopics => 
      topics.where((t) => t.isPremium == true).toList();

  int get totalFreeTopics => freeTopics.length;
  int get totalPremiumTopics => premiumTopics.length;

  String displayStrength(double strength) =>
      ((strength / totalStrength) * 100).round().toString();

  String displayFreeStrength(double strength) =>
      ((strength / totalFreeStrength) * 100).round().toString();

  double topicStrength(String topicId) =>
      topics.cast<Topic?>().firstWhere(
            (t) => topicId == t?.id,
            orElse: () => null,
          )?.strength ?? 0;

  Future<void> update(Map<String, dynamic> data) async {
    final docRef = FirebaseFirestore.instance.collection('playlists').doc(id);
    await docRef.update(data);
  }

  Playlist copy() {
    return Playlist.fromMap(toJson())..id = '';
  }

  Future<void> create() async {
    final collection = FirebaseFirestore.instance.collection('playlists');
    final doc = await collection.add(toJson());
    id = doc.id;
    await update({'id': id});
  }

  Future<String> cloneWithUid(String newUid) async {
    final newPlaylist = copy()..uid = newUid;
    await newPlaylist.create();
    return newPlaylist.id;
  }

  Future<void> upsert() async {
    await update(toJson());
  }

  void updateTopicStrength(String topicId, double strength) {
    final index = topics.indexWhere((t) => topicId == t.id);
    if (index != -1) {
      topics[index] = topics[index].copyWith(strength: strength);
    }
  }

  String get color => primaryColor.toString().split('.').last.toLowerCase();
  Color get flat => AppColors.flat(color);
  Color get dark => AppColors.dark(color);
  Color get light => AppColors.light(color);
  Color get shadow => AppColors.shadow(color);
  Color get highlight => AppColors.highlight(color);

  void _addTopic(Topic topic) {
    topics.add(Topic(
      id: topic.id,
      title: topic.title,
      description: topic.description,
      image: topic.image,
      icon: topic.icon,
      svg: topic.svg,
      group: topic.group,
      goal: topic.goal,
      activeVerb: topic.activeVerb,
      totalDuration: topic.totalDuration,
      totalFileSize: topic.totalFileSize,
      totalTracks: topic.totalTracks,
      isDefault: topic.isDefault,
      isPremium: topic.isPremium,
      isMentalHealth: topic.isMentalHealth,
      isPriority: topic.isPriority,
      price: topic.price,
      isLocked: topic.isLocked,
      strength: 50,
    ));
  }

  void addTopic(Topic topic) {
    if (!topics.map((t) => t.id).contains(topic.id)) {
      _addTopic(topic);
    }
  }

  bool addOrRemoveTopic(Topic topic) {
    final hasTopic = topics.map((t) => t.id).contains(topic.id);
    if (!hasTopic) {
      _addTopic(topic);
    } else {
      topics.removeWhere((t) => t.id == topic.id);
    }
    return !hasTopic;
  }

  bool hasTopic(Topic topic) {
    return topics.map((t) => t.id).contains(topic.id);
  }

  double get totalStrength =>
      topics.fold<double>(0, (sum, topic) => sum + topic.strength);

  double get totalFreeStrength {
    final free = freeTopics;
    return free.isEmpty ? 1 : free.fold<double>(0, (sum, topic) => sum + (topic.strength));
  }

  void removeTopic(String topicId) {
    topics.removeWhere((topic) => topic.id == topicId);
  }

  int get totalTopics => topics.length;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'appColor': primaryColor.toString().split('.').last,
      'title': title,
      'lastPlayed': lastPlayed,
      'isPrimary': isPrimary,
      'topics': topics.map((topic) => topic.toJson()).toList(),
      'created': created,
      'totalTimesPlayed': totalTimesPlayed,
      'totalDurationPlayed': totalDurationPlayed,
    };
  }
}
