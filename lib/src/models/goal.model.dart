// ignore_for_file: constant_identifier_names, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/models/suggestion.model.dart';

String enumToString(Object o) => o.toString().split('.').last;
T enumFromString<T>(String key, List<T> values) =>
    values.where((v) => key == enumToString(v as Object)).firstOrNull as T;

enum GoalType { Specific, Broad }

extension GoalTypeX on GoalType {
  GoalType fromString(String string) => enumFromString(string, GoalType.values);
  String get string => enumToString(this);
}

class GoalSuggestion {
  String id;
  String name;
  int amount;
  GoalSuggestion({required this.name, required this.amount, required this.id});

  factory GoalSuggestion.fromMap(Map data) {
    return GoalSuggestion(
      id: data['id'],
      name: data['name'],
      amount: data['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'id': id,
      'name': name,
      'amount': amount,
    };
    result.removeWhere((String key, dynamic value) => value == null);
    return result;
  }
}

class Goal {
  String id;
  String uid;
  String name;
  String category;
  String objective;
  GoalType goalType;
  String goalTopicId;
  IconData icon;
  CategoryColor color;
  String remittance;
  String plan;
  String mantra;
  String mantraUrl;
  bool usesOwnVoice;
  bool usesOwnDeepening;
  bool usesDeepening;
  List<GoalSuggestion> suggestions;
  int created;
  List<Suggestion> goalSuggestions;
  bool useTopicSuggestions;
  String groupId;
  List<String> trackIds;
  List<String> userTrackIds;
  int totalMinutes;
  int totalSessions;
  int currentStreak;
  int longestStreak;
  int score;
  int lastStreakSave;
  double mantraPercent;
  bool archived;
  bool shownUserRecordings;

  Goal({
    required this.id,
    required this.uid,
    required this.name,
    required this.category,
    required this.objective,
    required this.goalTopicId,
    required this.goalType,
    this.remittance = "",
    this.icon = Icons.question_mark,
    this.color = CategoryColor.Blue,
    this.usesOwnDeepening = false,
    this.usesDeepening = false,
    this.plan = "",
    this.userTrackIds = const [],
    this.mantra = "",
    this.mantraUrl = "",
    this.usesOwnVoice = false,
    this.suggestions = const [],
    int? created,
    this.goalSuggestions = const [],
    this.useTopicSuggestions = false,
    this.groupId = "",
    this.trackIds = const [],
    this.totalMinutes = 0,
    this.totalSessions = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    int? lastStreakSave,
    this.score = 0,
    this.mantraPercent = 0.3,
    this.archived = false,
    this.shownUserRecordings = false,
  })  : lastStreakSave =
            lastStreakSave ?? DateTime.now().millisecondsSinceEpoch,
        created = created ?? DateTime.now().millisecondsSinceEpoch;

  int get today => DateTime.now().day;
  bool get hasActiveStreak =>
      currentStreak == null ? false : today - lastStreakSave < 1;

  factory Goal.fromMap(Map data, param1) {
    List<GoalSuggestion> _suggestions = [];
    if (data['suggestions'] != null && data['suggestions'].isNotEmpty) {
      data['suggestions'].forEach((s) {
        _suggestions.add(GoalSuggestion.fromMap(s));
      });
    }

    List<String> _trackIds = [];
    if (data['trackIds'] != null && data['trackIds'].isNotEmpty) {
      data['trackIds'].forEach((s) {
        _trackIds.add(s);
      });
    }
    List<String> _userSuggestions = [];
    if (data['userTrackIds'] != null && data['userTrackIds'].isNotEmpty) {
      data['userTrackIds'].forEach((s) {
        _userSuggestions.add(s);
      });
    }

    return Goal(
      id: data['id'],
      uid: data['uid'],
      name: data['name'],
      icon: data['icon'],
      userTrackIds: _userSuggestions,
      trackIds: _trackIds,
      color: CategoryColor.Blue.fromString(data['color']),
      goalTopicId: data['goalTopicId'],
      objective: data['objective'],
      goalType: GoalType.Broad.fromString(data['goalType']),
      category: data['category'],
      mantra: data['mantra'],
      mantraUrl: data['mantraUrl'],
      remittance: data['remittance'],
      plan: data['plan'],
      totalMinutes: data['totalMinutes'] ?? 0,
      totalSessions: data['totalSessions'] ?? 0,
      longestStreak: data['longestStreak'] ?? 0,
      currentStreak: data['currentStreak'] ?? 0,
      usesOwnVoice: data['usesOwnVoice'] ?? false,
      archived: data['archived'] ?? false,
      usesDeepening: data['usesDeepening'] ?? false,
      usesOwnDeepening: data['usesOwnDeepening'] ?? false,
      useTopicSuggestions: data['useTopicSuggestions'],
      groupId: data['groupId'],
      score: data['score'] ?? 0,
      mantraPercent: data['mantraPercent'] ?? .3,
      suggestions: _suggestions,
      created: data['created'] ?? DateTime.now().millisecondsSinceEpoch,
      lastStreakSave: data['lastStreakSave'],
      shownUserRecordings: data['shownUserRecordings'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'id': id,
      'uid': uid,
      'name': name,
      'objective': objective,
      'goalTopicId': goalTopicId,
      'goalType': goalType.string,
      'mantra': mantra,
      'trackIds': trackIds,
      'mantraUrl': mantraUrl,
      'usesOwnVoice': usesOwnVoice,
      'archived': archived,
      'usesOwnDeepening': usesOwnDeepening,
      'usesDeepening': usesDeepening,
      'remittance': remittance,
      'icon': icon,
      'userTrackIds': userTrackIds,
      'color': color.string,
      "plan": plan,
      "totalMinutes": totalMinutes,
      "totalSessions": totalSessions,
      "longestStreak": longestStreak,
      "currentStreak": currentStreak,
      "mantraPercent": mantraPercent,
      "useTopicSuggestions": useTopicSuggestions,
      "groupId": groupId,
      "category": category,
      "score": score,
      "suggestions": suggestions.isEmpty
          ? null
          : suggestions.map(
              (s) {
                return s.toJson();
              },
            ).toList(),
      "created": created,
      "lastStreakSave": lastStreakSave,
      "shownUserRecordings": shownUserRecordings,
    };
    result.removeWhere((String key, dynamic value) => value == null);
    return result;
  }
}
