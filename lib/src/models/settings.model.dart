import 'package:trancend/src/constants/enums.dart';
import 'package:trancend/src/constants/strings.dart';
import 'package:trancend/src/models/user.model.dart';

class UserSettings {
  String uid;
  int statsStartDate;
  int statsEndDate;
  bool useCellularData;
  String defaultGoalId;
  bool usesOwnDeepening;
  bool usesDeepening;
  int delaySeconds;
  int maxHours;
  String inductionName;
  String inductionId;
  int inductionDuration;
  String deepeningName;
  String deepeningId;
  int deepeningDuration;
  String awakeningName;
  String awakeningId;
  int awakeningDuration;
  String userInductionName;
  String userInductionId;
  int userInductionDuration;
  String userDeepeningName;
  String userDeepeningId;
  int userDeepeningDuration;
  String userAwakeningName;
  String userAwakeningId;
  int userAwakeningDuration;

  AlarmSound alarmSound;
  AppSound defaultSound;

  UserSettings({
    required this.uid,
    this.awakeningDuration = 0,
    this.inductionDuration = 0,
    this.deepeningDuration = 0,
    this.statsEndDate = 0,
    this.alarmSound = AlarmSound.Glissando,
    this.defaultSound = AppSound.Alien_Chime,
    this.statsStartDate = 0,
    this.useCellularData = true,
    this.defaultGoalId = "",
    this.usesOwnDeepening = false,
    this.usesDeepening = false,
    this.inductionName = "Basic Induction",
    this.inductionId = "",
    this.deepeningName = "Basic Deepening",
    this.deepeningId = "",
    this.awakeningName = "Basic Awakening",
    this.awakeningId = "",
    this.userInductionName = "",
    this.userInductionId = "",
    this.userDeepeningName = "",
    this.userDeepeningId = "",
    this.userAwakeningName = "",
    this.userAwakeningId = "",
    this.delaySeconds = 4,
    this.maxHours = 8,
    this.userAwakeningDuration = 0,
    this.userDeepeningDuration = 0,
    this.userInductionDuration = 0,
  });

  factory UserSettings.fromMap(Map data) {
    return UserSettings(
      uid: data['uid'],
      statsStartDate: data['statsStartDate'],
      defaultGoalId: data['defaultGoalId'],
      delaySeconds: data['delaySeconds'] ?? 4,
      maxHours: data['maxHours'] ?? 8,
      statsEndDate: data['statsEndDate'],
      useCellularData: data['useCellularData'] ?? true,
      usesDeepening: data['usesDeepening'] ?? false,
      usesOwnDeepening: data['usesOwnDeepening'] ?? false,
      inductionName: data['inductionName'] ?? "Basic Induction",
      inductionId: data['inductionId'] ?? defaultInductionId,
      deepeningName: data['deepeningName'] ?? "Basic Deepening",
      deepeningId: data['deepeningId'] ?? defaultDeepeningId,
      awakeningName: data['awakeningName'] ?? "Basic Awakening",
      awakeningId: data['awakeningId'] ?? defaultAwakeningId,
      userInductionName: data['userInductionName'],
      awakeningDuration: data['awakeningDuration'],
      inductionDuration: data['inductionDuration'],
      deepeningDuration: data['deepeningDuration'],
      userInductionId: data['userInductionId'],
      userDeepeningName: data['userDeepeningName'],
      userDeepeningId: data['userDeepeningId'],
      userAwakeningName: data['userAwakeningName'],
      userAwakeningId: data['userAwakeningId'],
      userAwakeningDuration: data['userAwakeningDuration'],
      userDeepeningDuration: data['userDeepeningDuration'],
      userInductionDuration: data['userInductionDuration'],
      alarmSound: enumFromString(data['alarmSound'], AlarmSound.values) ??
          AlarmSound.Glissando,
      defaultSound: enumFromString(data['defaultSound'], AppSound.values) ??
          AppSound.Simple,
    );
  }

  Map<String, dynamic> toJson() {
    var data = {
      'uid': uid,
      'statsStartDate': statsStartDate,
      'delaySeconds': delaySeconds,
      'maxHours': maxHours,
      'alarmSound': enumToString(alarmSound),
      'defaultSound': enumToString(defaultSound),
      'statsEndDate': statsEndDate,
      "useCellularData": useCellularData,
      'defaultGoalId': defaultGoalId,
      'usesOwnDeepening': usesOwnDeepening,
      'usesDeepening': usesDeepening,
      'inductionName': inductionName,
      'inductionId': inductionId,
      'deepeningName': deepeningName,
      'deepeningId': deepeningId,
      'awakeningName': awakeningName,
      'awakeningId': awakeningId,
      'userInductionName': userInductionName,
      'userInductionId': userInductionId,
      'userDeepeningName': userDeepeningName,
      'userDeepeningId': userDeepeningId,
      'userAwakeningName': userAwakeningName,
      'userAwakeningId': userAwakeningId,
      'awakeningDuration': awakeningDuration,
      'inductionDuration': inductionDuration,
      'deepeningDuration': deepeningDuration,
      'userAwakeningDuration': userAwakeningDuration,
      'userDeepeningDuration': userDeepeningDuration,
      'userInductionDuration': userInductionDuration,
    };

    data.removeWhere((String key, dynamic value) => value == null);
    return data;
  }
}
