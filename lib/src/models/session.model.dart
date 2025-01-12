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
  String id;
  String uid;
  SessionType sessionType;
  SuggestionType suggestionType;
  TranceType tranceType;
  String inductionId;
  String deepening;
  String awakening;
  String playlistId;
  String topicId;
  int totalDuration;
  int startedTime;
  int finishedTime;
  int lastSaved;
  bool completed;
  bool updateSeen;
  int totalTracks;
  Map<String, double> topics;
  String goalId;
  String goalName;
  TranceMethod tranceMethod;
  int totalMinutes;
  int minutesPlayed;
  int score;
  int totalBreaths;
  BreathingMethod breathingMethod;
  int breathSeconds;

  Session({
    required this.id,
    required this.uid,
    required this.sessionType,
    required this.tranceType,
    required this.inductionId,
    this.deepening = '',
    this.awakening = '',
    this.goalId = '',
    this.playlistId = '',
    this.topicId = '',
    this.suggestionType = SuggestionType.Topic,
    this.totalDuration = 0,
    this.lastSaved = 0,
    this.totalTracks = 0,
    int? startedTime,
    this.finishedTime = 0,
    this.completed = false,
    Map<String, double>? topics,
    this.tranceMethod = TranceMethod.Hypnotherapy,
    this.goalName = '',
    this.totalMinutes = 0,
    this.minutesPlayed = 0,
    this.score = 0,
    this.totalBreaths = 0,
    this.breathingMethod = BreathingMethod.Focus,
    this.breathSeconds = 0,
    this.updateSeen = false,
  })  : topics = topics ?? {},
        startedTime = startedTime ?? DateTime.now().millisecondsSinceEpoch;

  SessionPlayType get playType => sessionType.playType;

  Session.fromMap(dynamic data)
      : id = data['id'] ?? '',
        uid = data['uid'] ?? '',
        sessionType =
            SessionType.fromString(data['type']) ?? SessionType.Relaxed,
        suggestionType = SuggestionType.Topic,
        tranceType =
            TranceType.fromString(data['tranceType']) ?? TranceType.Relaxed,
        breathingMethod = BreathingMethod.Focus,
        inductionId = data['induction'] ?? '',
        awakening = data['awakening'] ?? '',
        deepening = data['deepening'] ?? '',
        playlistId = data['playlist'] ?? '',
        topicId = data['topic'] ?? '',
        totalDuration = data['totalDuration'] ?? 0,
        startedTime = data['startedTime'] ?? 0,
        lastSaved = data['lastSaved'] ?? 0,
        goalId = data['goalId'] ?? '',
        score = data['score'] ?? 0,
        tranceMethod = TranceMethod.fromString(data['tranceMethod']) ??
            TranceMethod.Hypnotherapy,
        finishedTime = data['finishedTime'] ?? 0,
        completed = data['completed'] ?? false,
        totalMinutes = data['totalMinutes'] ?? 0,
        minutesPlayed = data['minutesPlayed'] ?? 0,
        goalName = data['goalName'] ?? '',
        totalTracks = data['totalTracks'] ?? 0,
        topics = (data['topics'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, v.toDouble()),
            ) ??
            {},
        breathSeconds = data['breathSeconds'] ?? 0,
        totalBreaths = data['totalBreaths'] ?? 0,
        updateSeen = data['updateSeen'] ?? false;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'id': id,
      'uid': uid,
      'tranceMethod': tranceMethod.string,
      'totalMinutes': totalMinutes,
      'goalId': goalId,
      'goalName': goalName,
      'type': sessionType.string,
      'suggestionType': enumToString(suggestionType),
      'tranceType': tranceType.string,
      'induction': inductionId,
      'awakening': awakening,
      'deepening': deepening,
      'playlist': playlistId,
      'topic': topicId,
      'totalDuration': totalDuration,
      'lastSaved': lastSaved,
      'startedTime': startedTime,
      'finishedTime': finishedTime,
      'totalTracks': totalTracks,
      'completed': completed,
      'topics': topics,
      'minutesPlayed': minutesPlayed,
      'totalBreaths': totalBreaths,
      'breathingMethod': breathingMethod.string,
      'breathSeconds': breathSeconds,
      'score': score,
    };
    data.removeWhere((String key, dynamic value) => value == null);
    return data;
  }
}
