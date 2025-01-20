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
  final String? id;
  final String uid;
  final String topicId;
  final int startTime;
  final int? endTime;
  final bool isComplete;
  final String? inductionId;
  final String? awakeningId;
  final int totalMinutes;
  final String? goalId;
  final String? goalName;
  final TranceMethod tranceMethod;
  final int startedTime;
  final int totalTracks;
  final List<PlayedTrack>? playedTracks;

  Session({
    this.id,
    required this.uid,
    required this.topicId,
    required this.startTime,
    this.endTime,
    required this.isComplete,
    this.inductionId,
    this.awakeningId,
    required this.totalMinutes,
    this.goalId,
    this.goalName,
    required this.tranceMethod,
    required this.startedTime,
    required this.totalTracks,
    this.playedTracks,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'topicId': topicId,
      'startTime': startTime,
      'endTime': endTime,
      'isComplete': isComplete,
      'inductionId': inductionId,
      'awakeningId': awakeningId,
      'totalMinutes': totalMinutes,
      'goalId': goalId,
      'goalName': goalName,
      'tranceMethod': tranceMethod.name,
      'startedTime': startedTime,
      'totalTracks': totalTracks,
      'playedTracks': playedTracks?.map((track) => track.toJson()).toList(),
    };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      uid: json['uid'],
      topicId: json['topicId'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      isComplete: json['isComplete'],
      inductionId: json['inductionId'],
      awakeningId: json['awakeningId'],
      totalMinutes: json['totalMinutes'],
      goalId: json['goalId'],
      goalName: json['goalName'],
      tranceMethod: TranceMethod.values.firstWhere(
        (e) => e.name == json['tranceMethod'],
        orElse: () => TranceMethod.Hypnotherapy,
      ),
      startedTime: json['startedTime'],
      totalTracks: json['totalTracks'],
      playedTracks: json['playedTracks'] != null
          ? (json['playedTracks'] as List)
              .map((track) => PlayedTrack.fromJson(track))
              .toList()
          : null,
    );
  }

  Session copyWith({
    String? id,
    String? uid,
    String? topicId,
    int? startTime,
    int? endTime,
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
      id: id ?? this.id,
      uid: uid ?? this.uid,
      topicId: topicId ?? this.topicId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
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
}