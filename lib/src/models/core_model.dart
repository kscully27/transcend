// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum SessionType {
  Active,
  ActiveWithDeepening,
  Relaxed,
  RelaxedWithDeepening,
  SleepWithInduction,
  SleepWithDeepening,
  SleepWithSnooze,
}

class PlayedTrack {
  late String trackId;
  late String uid;
  late String topicId;
  late SessionType sessionType;
  late String sessionId;
  late String playlistId;
  late int duration;
  late int year;
  late int day;
  late int month;
  late int week;
  late int created;

  PlayedTrack.fromMap(Map<String, dynamic> data) {
    trackId = data["trackId"];
    uid = data["uid"] ?? 0;
    topicId = data['topicId'];
    sessionType = SessionType.values.firstWhere(
        (type) => type.toString().split('.').last == data["sessionType"],
        orElse: () => SessionType.Relaxed);
    sessionId = data['sessionId'];
    playlistId = data['playlistId'];
    duration = data['duration'];
    year = data['year'];
    day = data['day'];
    week = data['week'];
    month = data['month'];
    created = data['created'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'trackId': trackId,
      'uid': uid,
      'topicId': topicId,
      'playlistId': playlistId,
      'sessionId': sessionId,
      'sessionType': sessionType.toString(),
      'duration': duration,
      'year': year,
      'month': month,
      'day': day,
      'week': week,
      'created': created,
    };

    data.removeWhere((String key, dynamic value) => value == null);
    return data;
  }
}

enum TranceType { Active, Relaxed, Sleep }

class TranceModel {
  late String id;
  late String title;
  late IconData icon;
  late AppColor color;
  late String appColor;
  List<int> colors;
  TranceType type;

  TranceModel(
      {required this.id,
      required this.title,
      required this.colors,
      required this.icon,
      required this.appColor,
      required this.color,
      required this.type});
}

// Each stat is saved after either track completion or session completion

class AudioTrack {
  String id;
  String text;
  String category;
  String svg;
  double duration;
  bool isMantra;
  bool isPrimary;
  bool approved;
  bool active;
  bool isDefault;
  String topic;
  String fileName;
  String url;
  String title;
  String voiceId;
  String voiceName;
  int words;
  int fileSize;
  String originalId;
  int updated;
  int created;

  AudioTrack(
      {required this.id,
      required this.text,
      required this.title,
      required this.duration,
      required this.isDefault,
      required this.category,
      required this.svg,
      required this.isMantra,
      required this.isPrimary,
      required this.topic,
      required this.approved,
      required this.active,
      required this.fileName,
      required this.fileSize,
      required this.originalId,
      required this.words,
      required this.voiceName,
      required this.voiceId,
      required this.updated,
      required this.created,
      required this.url});

  factory AudioTrack.fromMap(Map data) {
    return AudioTrack(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
      topic: data['topic'] ?? '',
      title: data['title'] ?? '',
      active: data['active'] ?? false,
      svg: data['svg'] ?? '',
      isDefault: data['isDefault'] ?? false,
      duration: data['duration']?.toDouble() ?? 0.0,
      words: data['words']?.toInt() ?? 0,
      category: data['category'] ?? '',
      isMantra: data['isMantra'] ?? false,
      isPrimary: data['isPrimary'] ?? false,
      approved: data['isPrimary'] ?? false,
      fileName: data['fileName'] ?? '',
      fileSize: data['fileSize']?.toInt() ?? 0,
      created: data['created']?.toInt() ??
          DateTime.now().toUtc().millisecondsSinceEpoch,
      updated: data['updated']?.toInt() ??
          DateTime.now().toUtc().millisecondsSinceEpoch,
      originalId: data['originalId'],
      url: data['url'],
      voiceId: data['voiceId'] ?? '',
      voiceName: data['voiceName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'title': title,
      'active': active,
      'svg': svg,
      'isDefault': isDefault,
      'duration': duration,
      'words': words,
      'text': text,
      'category': category,
      'approved': approved,
      'fileName': fileName,
      'created': created,
      'updated': updated,
      'originalId': originalId,
      'url': url,
    };
  }
}
