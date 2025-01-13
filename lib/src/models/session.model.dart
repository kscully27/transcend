import 'package:trancend/src/constants/enums.dart';
import 'package:trancend/src/models/breath.model.dart';

enum SessionType {
  Active,
  Relaxed;

  String get string => name;
  static SessionType? fromString(String? value) => value == null
      ? null
      : values.firstWhere((e) => e.name == value, orElse: () => Relaxed);
}

enum TranceType {
  Relaxed,
  Deep,
  Light;

  String get string => name;
  static TranceType? fromString(String? value) => value == null
      ? null
      : values.firstWhere((e) => e.name == value, orElse: () => Relaxed);
}

enum TranceMethod {
  Hypnotherapy,
  Active;

  String get string => name;
  static TranceMethod? fromString(String? value) => value == null
      ? null
      : values.firstWhere((e) => e.name == value, orElse: () => Hypnotherapy);
}

enum SessionPlayType { Audio, Video, Text }

extension SessionTypeX on SessionType {
  SessionPlayType get playType {
    switch (this) {
      case SessionType.Active:
        return SessionPlayType.Video;
      case SessionType.Relaxed:
        return SessionPlayType.Audio;
    }
  }
}

enum SuggestionType { Playlist, Topic }

class Session {
  String? id;
  String? uid;
  String? topicId;
  int? startTime;
  int? finishedTime;
  int? totalSeconds;
  bool? isComplete;

  Session({
    this.id,
    this.uid,
    this.topicId,
    this.startTime,
    this.finishedTime,
    this.totalSeconds,
    this.isComplete,
  });

  factory Session.fromMap(Map? data) {
    if (data == null) return Session();
    return Session(
      id: data['id'],
      uid: data['uid'],
      topicId: data['topicId'],
      startTime: data['startTime'],
      finishedTime: data['finishedTime'],
      totalSeconds: data['totalSeconds'],
      isComplete: data['isComplete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'id': id,
      'uid': uid,
      'topicId': topicId,
      'startTime': startTime,
      'finishedTime': finishedTime,
      'totalSeconds': totalSeconds,
      'isComplete': isComplete,
    };
    result.removeWhere((String key, dynamic value) => value == null);
    return result;
  }
}
