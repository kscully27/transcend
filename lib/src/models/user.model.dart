
// // ignore_for_file: constant_identifier_names

// import 'package:flutter/material.dart';
// import 'package:trancend/src/constants/enums.dart';
// import 'package:trancend/src/models/breath.model.dart';
// import 'package:trancend/src/models/level.model.dart';
// import 'package:trancend/src/shared/icons.dart';

// enum UserRole { Basic, Premium, Platinum }

// enum SigninMethod { Email, Facebook, Google, Apple, EmailLink, Anonymous, None }
// extension SigninMethodX on SigninMethod {
//   String get string => enumToString(this);
//   SigninMethod fromString(String string) =>
//       enumFromString(string, SigninMethod.values);
// }

// enum AppGender { Male, Female, Other }
// extension AppGenderX on AppGender {
//   String get string => enumToString(this);
//   AppGender fromString(String string) =>
//       enumFromString(string, AppGender.values);
// }

// enum ReminderPreference { Morning, Evening, None }

// enum Category { Mental, Physical, Emotional, Spiritual, Lifestyle, Success }

// class User {
//   late String uid;
//   late String displayName;
//   late UserRole role;
//   late SigninMethod signinMethod;
//   late String photoUrl;
//   late String email;
//   late bool isAnonymous;
//   late bool emailVerified;
//   late bool madePurchase;
//   late String defaultPlaylist;
//   late String oldUid;
//   late bool notificationsEnabled;
//   late bool needsMerge;
//   late bool isOnboarded;
//   late bool hasRatedApp;
//   String phoneNumber;
//   String firstName;
//   List<String> friends;
//   int age;
//   AppGender gender;
//   BreathingMethod breathingMethod;
//   List<Category> categories;
//   List<String> entitlements;
//   Category topCategory;
//   ExperienceLevel experienceLevel;
//   ReminderPreference reminderPreference;
//   int reminderHour;
//   int reminderMinute;
//   DateTime reminderTime;
//   int created;
//   bool categoriesSorted;
//   bool notificationsAuthorized;
//   List<TranceMethod> tranceInterests;
//   String primaryGoalId;
//   TranceMethod lastTranceMethod;
//   bool doesntLikeVoice;
//   bool completedTraining;
//   bool accepted10DayChallenge;
//   bool shownPremiumOption;
//   List<TranceMethod> tranceTypesCompleted;
//   List<HypnotherapySkill> skillsCompleted;
//   int defaultBreathTime;
//   int defaultMeditationTime;
//   int defaultHypnotherapyTime;
//   int defaultActiveHypnotherapyTime;
//   int defaultSleepDelay;
//   bool usesSleepDelay;
//   ActiveBackgroundSound activeBackgroundSound;
//   BackgroundSound backgroundSound;
//   double backgroundVolume;
//   double voiceVolume;
//   String defaultInduction;
//   String defaultDeepening;
//   String defaultAwakening;
//   bool usesDeepening;
//   bool isStripe;
//   int secondsDelayBetweenTracks;
//   int score;
//   int longestStreak;
//   int currentStreak;
//   int totalSessions;
//   int totalMinutes;
//   int mindfulDays;
//   int lastStreakSave;
//   int totalBreaths;
//   bool givenFeedback;
//   int totalSharesAccepted;
//   String referrerUid;

//   bool onboarededHypnotherapy;
//   bool onboarededActive;
//   bool onboarededBreathing;
//   bool onboarededSleep;
//   bool onboarededMeditation;

//   AlarmSound alarmSound;
//   AppSound defaultSound;
//   int breathSeconds;
//   bool emailSubscribed;
//   int premiumUntil;

//   User({
//     this.uid,
//     this.isAnonymous,
//     this.tranceInterests,
//     this.voiceVolume,
//     this.defaultSound,
//     this.displayName,
//     this.alarmSound,
//     this.lastTranceMethod,
//     this.role = UserRole.Basic,
//     this.signinMethod = SigninMethod.None,
//     this.hasRatedApp,
//     this.breathingMethod,
//     this.photoUrl,
//     this.email,
//     this.shownPremiumOption,
//     this.phoneNumber,
//     this.givenFeedback,
//     this.onboarededHypnotherapy,
//     this.onboarededActive,
//     this.onboarededBreathing,
//     this.onboarededSleep,
//     this.onboarededMeditation,
//     this.reminderTime,
//     this.referrerUid,
//     this.totalSharesAccepted,
//     this.reminderHour,
//     this.reminderMinute,
//     this.emailVerified,
//     this.defaultPlaylist,
//     this.isOnboarded,
//     this.entitlements,
//     this.friends,
//     this.needsMerge,
//     this.topCategory,
//     this.madePurchase,
//     this.notificationsEnabled,
//     this.reminderPreference,
//     this.firstName,
//     this.gender,
//     this.categories,
//     this.age,
//     this.experienceLevel,
//     this.oldUid,
//     this.created,
//     this.categoriesSorted,
//     this.notificationsAuthorized,
//     this.doesntLikeVoice,
//     this.primaryGoalId,
//     this.completedTraining,
//     this.accepted10DayChallenge,
//     this.tranceTypesCompleted,
//     this.skillsCompleted,
//     this.defaultBreathTime,
//     this.defaultMeditationTime,
//     this.defaultHypnotherapyTime,
//     this.defaultActiveHypnotherapyTime,
//     this.defaultSleepDelay,
//     this.usesSleepDelay,
//     this.backgroundSound,
//     this.activeBackgroundSound,
//     this.backgroundVolume,
//     this.defaultInduction,
//     this.defaultDeepening,
//     this.defaultAwakening,
//     this.usesDeepening,
//     this.isStripe,
//     this.secondsDelayBetweenTracks,
//     this.score,
//     this.longestStreak,
//     this.currentStreak,
//     this.totalSessions,
//     this.totalMinutes,
//     this.mindfulDays,
//     this.lastStreakSave,
//     this.breathSeconds,
//     this.totalBreaths,
//     this.emailSubscribed,
//     this.premiumUntil,
//   });

//   UserAnimal get spiritAnimal => UserAnimal.Caterpillar.fromScore(score);

//   String get ageAttribute {
//     String _age = 'Not Specified';
//     if (age > 0) _age = "13 & under";
//     if (age > 13) _age = "13-18";
//     if (age > 18) _age = "18-25";
//     if (age > 25) _age = "25-30";
//     if (age > 30) _age = "30-35";
//     if (age > 35) _age = "35-40";
//     if (age > 40) _age = "40-45";
//     if (age > 45) _age = "45-50";
//     if (age > 50) _age = "50-55";
//     if (age > 55) _age = "55-60";
//     if (age > 60) _age = "60-65";
//     if (age > 65) _age = "65-70";
//     if (age > 70) _age = "70-75";
//     if (age > 75) _age = "75-80";
//     if (age > 80) _age = "80 & up";
//       return _age;
//   }

//   String get totalTranceMinutesAttribute {
//     String _totalMinutes;
//     if (totalMinutes > 0) _totalMinutes = "10-50";
//     if (totalMinutes > 50) _totalMinutes = "50-100";
//     if (totalMinutes > 100) _totalMinutes = "100-150";
//     if (totalMinutes > 150) _totalMinutes = "150-200";
//     if (totalMinutes > 200) _totalMinutes = "200-250";
//     if (totalMinutes > 250) _totalMinutes = "250-300";
//     if (totalMinutes > 300) _totalMinutes = "300-400";
//     if (totalMinutes > 400) _totalMinutes = "400-500";
//     if (totalMinutes > 500) _totalMinutes = "500-600";
//     if (totalMinutes > 600) _totalMinutes = "600-700";
//     if (totalMinutes > 700) _totalMinutes = "700-800";
//     if (totalMinutes > 800) _totalMinutes = "800-900";
//     if (totalMinutes > 900) _totalMinutes = "900-1000";
//     if (totalMinutes > 1000) _totalMinutes = "1000-2000";
//     if (totalMinutes > 2000) _totalMinutes = "2000-3000";
//       return _totalMinutes;
//   }

//   bool get isPremium =>
//       (role == UserRole.Premium || role == UserRole.Platinum) ||
//       (premiumUntil > DateTime.now().millisecondsSinceEpoch);

//   String get totalTranceSessionsAttribute {
//     String _totalSessions;
//     if (totalSessions > 0) _totalSessions = "1-5";
//     if (totalSessions > 5) _totalSessions = "5-10";
//     if (totalSessions > 10) _totalSessions = "10-20";
//     if (totalSessions > 20) _totalSessions = "20-30";
//     if (totalSessions > 30) _totalSessions = "30-40";
//     if (totalSessions > 40) _totalSessions = "40-50";
//     if (totalSessions > 50) _totalSessions = "50-75";
//     if (totalSessions > 75) _totalSessions = "75-100";
//     if (totalSessions > 100) _totalSessions = "100-125";
//     if (totalSessions > 125) _totalSessions = "125-150";
//     if (totalSessions > 150) _totalSessions = "150-200";
//     if (totalSessions > 200) _totalSessions = "200-300";
//     if (totalSessions > 300) _totalSessions = "300-400";
//       return _totalSessions;
//   }

//   factory User.fromMap(Map data) {
//     try {
//       List<Category> _categories = [];
//       if (data['categories'] != null && data['categories'].isNotEmpty) {
//         for (String category in data['categories']) {
//           _categories.add(Category.Mental.fromString(category));
//         }
//       }

//       List<String> _friends = [];
//       if (data['friends'] != null && data['friends'].isNotEmpty) {
//         for (String friend in data['friends']) {
//           _friends.add(friend);
//         }
//       }

//       List<String> _entitlements = [];
//       if (data['entitlements'] != null && data['entitlements'].isNotEmpty) {
//         for (String entitlement in data['entitlements']) {
//           _entitlements.add(entitlement);
//         }
//       }
//       List<TranceMethod> _tranceInterests = [];
//       if (data['tranceInterests'] != null &&
//           data['tranceInterests'].isNotEmpty) {
//         for (String interest in data['tranceInterests']) {
//           _tranceInterests.add(TranceMethod.Hypnotherapy.fromString(interest));
//         }
//       }

//       List<HypnotherapySkill> _skills = [];
//       if (data['skillsCompleted'] != null &&
//           data['skillsCompleted'].isNotEmpty) {
//         data['skillsCompleted'].forEach((skill) {
//           _skills.add(
//             HypnotherapySkill.Active_Hypnosis.fromString(
//                     data['skillsCompleted']) ??
//                 HypnotherapySkill.Active_Hypnosis,
//           );
//         });
//       }
//       List<TranceMethod> _tranceTypes = [];
//       if (data['tranceTypesCompleted'] != null &&
//           data['tranceTypesCompleted'].isNotEmpty) {
//         data['tranceTypesCompleted'].forEach((skill) {
//           _tranceTypes.add(
//             TranceMethod.Active.fromString(data['tranceTypesCompleted']) ??
//                 TranceMethod.Active,
//           );
//         });
//       }

//       User _user = User(
//         uid: data['uid'],
//         madePurchase: data['madePurchase'] ?? false,
//         phoneNumber: data['phoneNumber'],
//         displayName: data['displayName'],
//         tranceInterests: _tranceInterests,
//         skillsCompleted: _skills,
//         tranceTypesCompleted: _tranceTypes,
//         backgroundVolume: data['backgroundVolume'] ?? .7,
//         voiceVolume: data['voiceVolume'] ?? .7,
//         reminderMinute: data['reminderMinute'] ?? 0,
//         breathSeconds: data['breathSeconds'] ?? 4,
//         reminderHour: data['reminderHour'],
//         secondsDelayBetweenTracks: data['secondsDelayBetweenTracks'] ?? 5,
//         reminderTime: data['reminderTime'] == null
//             ? null
//             : DateTime.fromMillisecondsSinceEpoch(data['reminderTime']),
//         role: UserRole.Basic.fromString(data['role']) ?? UserRole.Basic,
//         gender: AppGender.Other.fromString(data['gender']) ?? AppGender.Other,
//         breathingMethod:
//             BreathingMethod.Energize.fromString(data['breathingMethod']) ??
//                 BreathingMethod.Energize,
//         topCategory: Category.Mental.fromString(data['topCategory']) ?? null,
//         experienceLevel:
//             ExperienceLevel.Beginner.fromString(data['experienceLevel']) ??
//                 null,
//         reminderPreference:
//             ReminderPreference.Morning.fromString(data['reminderPreference']) ??
//                 null,
//         categories: _categories,
//         entitlements: _entitlements,
//         age: data['age'],
//         givenFeedback: data['givenFeedback'] ?? false,
//         shownPremiumOption: data['shownPremiumOption'] ?? false,
//         accepted10DayChallenge: data['accepted10DayChallenge'],
//         firstName: data['firstName'],
//         premiumUntil: data['premiumUntil'],
//         signinMethod: SigninMethod.None.fromString(data['signinMethod']) ??
//             SigninMethod.None,
//         lastTranceMethod:
//             TranceMethod.Hypnotherapy.fromString(data['lastTranceMethod']) ??
//                 TranceMethod.Hypnotherapy,
//         backgroundSound:
//             BackgroundSound.Waves.fromString(data['backgroundSound']) ??
//                 BackgroundSound.Waves,
//         activeBackgroundSound: ActiveBackgroundSound.Fire.fromString(
//                 data['activeBackgroundSound']) ??
//             ActiveBackgroundSound.Fire,
//         photoUrl: data['photoUrl'],
//         hasRatedApp: data['hasRatedApp'],
//         email: data['email'],
//         isAnonymous: data['isAnonymous'] ?? true,
//         emailVerified: data['emailVerified'] ?? false,
//         defaultPlaylist: data['defaultPlaylist'],
//         oldUid: data['oldUid'],
//         score: data['score'] ?? 0,
//         totalSharesAccepted: data['totalSharesAccepted'] ?? 0,
//         referrerUid: data['referrerUid'],
//         totalSessions: data['totalSessions'] ?? 0,
//         totalMinutes: data['totalMinutes'] ?? 0,
//         mindfulDays: data['mindfulDays'] ?? 0,
//         longestStreak: data['longestStreak'] ?? 0,
//         currentStreak: data['currentStreak'] ?? 0,
//         primaryGoalId: data['primaryGoalId'],
//         onboarededHypnotherapy: data['onboarededHypnotherapy'] ?? false,
//         onboarededActive: data['onboarededActive'] ?? false,
//         onboarededBreathing: data['onboarededBreathing'] ?? false,
//         onboarededSleep: data['onboarededSleep'] ?? false,
//         onboarededMeditation: data['onboarededMeditation'] ?? false,
//         doesntLikeVoice: data['doesntLikeVoice'] ?? false,
//         notificationsEnabled: data['notificationsEnabled'] ?? false,
//         needsMerge: data['needsMerge'] ?? false,
//         isOnboarded: data['isOnboarded'] ?? false,
//         categoriesSorted: data['categoriesSorted'] ?? false,
//         friends: _friends,
//         created: data['created']?.toInt() ??
//             DateTime.now().toUtc().millisecondsSinceEpoch,
//         notificationsAuthorized: data['notificationsAuthorized'] ?? false,
//         completedTraining: data['completedTraining'] ?? false,
//         defaultBreathTime: data['defaultBreathTime'] ?? 4,
//         defaultMeditationTime: data['defaultMeditationTime'] ?? 5,
//         defaultHypnotherapyTime: data['defaultHypnotherapyTime'] ?? 5,
//         defaultActiveHypnotherapyTime:
//             data['defaultActiveHypnotherapyTime'] ?? 10,
//         defaultSleepDelay: data['defaultSleepDelay'] ?? 30,
//         usesSleepDelay: data['usesSleepDelay'] ?? true,
//         defaultInduction: data['defaultInduction'] ?? defaultInductionId,
//         defaultAwakening: data['defaultAwakening'] ?? defaultAwakeningId,
//         defaultDeepening: data['defaultDeepening'] ?? defaultDeepeningId,
//         usesDeepening: data['usesDeepening'] ?? true,
//         isStripe: data['isStripe'] ?? false,
//         totalBreaths: data['totalBreaths'] ?? 0,
//         lastStreakSave:
//             data['lastStreakSave'] ?? DateTime.now().millisecondsSinceEpoch,
//         emailSubscribed: data['emailSubscribed'],
//       );
//       return _user;
//     } catch (e) {
//       print("Error Mapping user $e");
//       return null;
//     }
//   }
//   BreathMethod get currentBreathMethod {
//     int _defaultBreathTime = breathSeconds ?? 4;
//     return BreathMethod(
//         breathOut: _defaultBreathTime * breathingMethod.method.breathOut,
//         breathInHold: _defaultBreathTime * breathingMethod.method.breathInHold,
//         breathOutHold:
//             _defaultBreathTime * breathingMethod.method.breathOutHold,
//         breathIn: _defaultBreathTime * breathingMethod.method.breathIn,
//         title: breathingMethod.method.title,
//         appColor: breathingMethod.method.appColor,
//         longTitle: breathingMethod.method.longTitle,
//         description: breathingMethod.method.description,
//         icon: breathingMethod.method.icon,
//         loop: true);
//   }

//   int get totalBreathsInSession => ((defaultBreathTime.minutes.inSeconds /
//               (currentBreathMethod.breathIn +
//                   currentBreathMethod.breathOut +
//                   currentBreathMethod.breathIn +
//                   currentBreathMethod.breathInHold +
//                   currentBreathMethod.breathOutHold)) *
//           2)
//       .ceil();

//   List<String> get userCategories => categories.isNotEmpty
//       ? categories.map((c) => c.id).toList()
//       : null;

//   Map<String, dynamic> toJson() {
//     List<String> _categories = [];
//     if (categories.isNotEmpty) {
//       categories.forEach((element) {
//         _categories.add(element.string);
//       });
//     }
//     List<String> _tranceInterests = [];
//     if (tranceInterests.isNotEmpty) {
//       tranceInterests.forEach((element) {
//         _tranceInterests.add(element.string);
//       });
//     }

//     List<String> _skills = [];
//     if (skillsCompleted.isNotEmpty) {
//       skillsCompleted.forEach((element) {
//         _skills.add(element.string);
//       });
//     }
//     List<String> _tranceTypes = [];
//     if (tranceTypesCompleted.isNotEmpty) {
//       tranceTypesCompleted.forEach((element) {
//         _tranceTypes.add(element.string);
//       });
//     }

//     Map<String, dynamic> data = {
//       'uid': uid,
//       'displayName': displayName,
//       'phoneNumber': phoneNumber,
//       'tranceInterests': _tranceInterests,
//       'role': role.string,
//       'signinMethod': signinMethod.string,
//       'skillsCompleted': _skills,
//       'tranceTypesCompleted': _tranceTypes,
//       'email': email,
//       'entitlements': entitlements,
//       'secondsDelayBetweenTracks': secondsDelayBetweenTracks,
//       'isAnonymous': isAnonymous,
//       'emailVerified': emailVerified,
//       "madePurchase": madePurchase,
//       "isOnboarded": isOnboarded,
//       "hasRatedApp": hasRatedApp,
//       "accepted10DayChallenge": accepted10DayChallenge,
//       "experienceLevel": experienceLevel.string,
//       "reminderPreference": reminderPreference.string,
//       "notificationsEnabled": notificationsEnabled,
//       "oldUid": oldUid,
//       "categories": _categories,
//       "topCategory": topCategory.string,
//       "photoUrl": photoUrl,
//       "friends": friends,
//       "needsMerge": needsMerge,
//       "gender": gender.string,
//       "breathingMethod": breathingMethod.string,
//       "reminderMinute": reminderMinute,
//       "reminderHour": reminderHour,
//       "activeBackgroundSound": activeBackgroundSound.string,
//       "backgroundSound": backgroundSound.string,
//       "reminderTime":
//           reminderTime == null ? null : reminderTime.millisecondsSinceEpoch,
//       "age": age,
//       "firstName": firstName,
//       "categoriesSorted": categoriesSorted,
//       "primaryGoalId": primaryGoalId,
//       "doesntLikeVoice": doesntLikeVoice,
//       "created": created,
//       "notificationsAuthorized": notificationsAuthorized,
//       "completedTraining": completedTraining,
//       "defaultBreathTime": defaultBreathTime,
//       "breathSeconds": breathSeconds,
//       "defaultMeditationTime": defaultMeditationTime,
//       "defaultHypnotherapyTime": defaultHypnotherapyTime,
//       "defaultActiveHypnotherapyTime": defaultActiveHypnotherapyTime,
//       "defaultSleepDelay": defaultSleepDelay,
//       "usesSleepDelay": usesSleepDelay,
//       "score": score,
//       "longestStreak": longestStreak,
//       "currentStreak": currentStreak,
//       "totalSessions": totalSessions,
//       "totalMinutes": totalMinutes,
//       "lastStreakSave": lastStreakSave,
//       "voiceVolume": voiceVolume,
//       "givenFeedback": givenFeedback,
//       "shownPremiumOption": shownPremiumOption,
//       "mindfulDays": mindfulDays,
//       "onboarededHypnotherapy": onboarededHypnotherapy,
//       "onboarededActive": onboarededActive,
//       "onboarededBreathing": onboarededBreathing,
//       "onboarededSleep": onboarededSleep,
//       "onboarededMeditation": onboarededMeditation,
//       "totalBreaths": totalBreaths,
//       "emailSubscribed": emailSubscribed,
//       "referrerUid": referrerUid,
//       "totalSharesAccepted": totalSharesAccepted,
//       "isStripe": isStripe,
//       "premiumUntil": premiumUntil,
//     };
//     data.removeWhere((String key, dynamic value) => value == null);
//     return data;
//   }
// }
