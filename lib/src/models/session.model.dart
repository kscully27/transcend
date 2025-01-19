import 'package:trancend/src/models/played_track.model.dart';

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
  Sleep,
  Breathing,
  Meditation,
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
  final String? uid;
  final String? topicId;
  final int? startTime;
  int? finishedTime;
  int? totalSeconds;
  final bool? isComplete;
  final String? inductionId;
  final String? awakeningId;
  final int? totalMinutes;
  final String? goalId;
  final String? goalName;
  final TranceMethod? tranceMethod;
  final int? startedTime;
  final int? totalTracks;
  final List<PlayedTrack>? playedTracks;

  Session({
    this.id,
    this.uid,
    this.topicId,
    this.startTime,
    this.finishedTime,
    this.totalSeconds,
    this.isComplete,
    this.inductionId,
    this.awakeningId,
    this.totalMinutes,
    this.goalId,
    this.goalName,
    this.tranceMethod,
    this.startedTime,
    this.totalTracks,
    this.playedTracks,
  });

  Session copyWith({
    String? uid,
    String? topicId,
    int? startTime,
    bool? isComplete,
    String? inductionId,
    String? awakeningId,
    int? totalMinutes,
    String? goalId,
    String? goalName,
    TranceMethod? tranceMethod,
    int? startedTime,
    int? totalTracks,
    List<PlayedTrack>? playedTracks,
  }) {
    return Session(
      id: id,
      uid: uid ?? this.uid,
      topicId: topicId ?? this.topicId,
      startTime: startTime ?? this.startTime,
      finishedTime: finishedTime,
      totalSeconds: totalSeconds,
      isComplete: isComplete ?? this.isComplete,
      inductionId: inductionId ?? this.inductionId,
      awakeningId: awakeningId ?? this.awakeningId,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      goalId: goalId ?? this.goalId,
      goalName: goalName ?? this.goalName,
      tranceMethod: tranceMethod ?? this.tranceMethod,
      startedTime: startedTime ?? this.startedTime,
      totalTracks: totalTracks ?? this.totalTracks,
      playedTracks: playedTracks ?? this.playedTracks,
    );
  }

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
      inductionId: data['inductionId'],
      awakeningId: data['awakeningId'],
      totalMinutes: data['totalMinutes'],
      goalId: data['goalId'],
      goalName: data['goalName'],
      tranceMethod: TranceMethod.fromString(data['tranceMethod']),
      startedTime: data['startedTime'],
      totalTracks: data['totalTracks'],
      playedTracks: data['playedTracks'] != null
          ? (data['playedTracks'] as List)
              .map((t) => PlayedTrack.fromMap(t))
              .toList()
          : null,
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
      'inductionId': inductionId,
      'awakeningId': awakeningId,
      'totalMinutes': totalMinutes,
      'goalId': goalId,
      'goalName': goalName,
      'tranceMethod': tranceMethod?.string,
      'startedTime': startedTime,
      'totalTracks': totalTracks,
      'playedTracks': playedTracks?.map((t) => t.toJson()).toList(),
    };
    result.removeWhere((String key, dynamic value) => value == null);
    return result;
  }
}