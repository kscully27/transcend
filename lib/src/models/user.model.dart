import 'package:supercharged/supercharged.dart';
import 'package:trancend/src/constants/enums.dart';
import 'package:trancend/src/constants/strings.dart';
import 'package:trancend/src/models/breath.model.dart';
import 'package:trancend/src/models/level.model.dart';

enum UserRole { Basic, Premium, Platinum }

enum SigninMethod { Email, Facebook, Google, Apple, EmailLink, Anonymous, None }

extension SigninMethodX on SigninMethod {
  String get string => enumToString(this);
  SigninMethod fromString(String string) =>
      enumFromString(string, SigninMethod.values);
}

enum AppGender { Male, Female, Other }

extension AppGenderX on AppGender {
  String get string => enumToString(this);
  AppGender fromString(String string) =>
      enumFromString(string, AppGender.values);
}

enum ReminderPreference { Morning, Evening, None }

enum Category { Mental, Physical, Emotional, Spiritual, Lifestyle, Success }

enum HypnotherapySkill {
  Mindfulness,
  Basic_Hypnotherapy,
  Awareness,
  Breath_Focus,
  Active_Hypnosis,
  Mindful_Hypnosis,
  Body_Scan,
  Labeling,
  Empathy,
  Spotlighting,
  Oxygenated_Breathing,
  Boxed_Breathing,
  Visualization,
  Innovation,
  Self_Direction,
  // Calm your mind before sleep
  Sleep_Soothing,
  // Double inhales + longer exhales
  Sleep_Breathing,
  // Tapping to a beat that slows down over time until you fall asleep
  Sleep_Rythm,
  Sleep_Programming,
}

enum TranceMethod {
  Hypnotherapy,
  Active,
  Meditation,
  Sleep,
}

enum ActiveBackgroundSound {
  Fire,
  Electricity,
  Encouragement,
  Energy,
  Enhance,
  Flight,
  Force,
  Ignition,
  Motivation,
  Passion,
  Power,
  Spark,
  Stamina,
  Strength,
  None
}

enum BackgroundSound {
  Waves,
  Rain,
  Campfire,
  Chimes,
  Stream,
  Saturn,
  Sun,
  City,
  Farm,
  Wetlands,
  Forest,
  Train,
  Rainforest,
  Nature,
  None,
}

enum AlarmSound {
  Default,
  Marimba,
  Glissando,
  Twinkle,
  Flutter,
  Fantasy,
  Simple,
  Beep,
  Godmother,
  Watch_Alarm,
  Magic_Wand,
}

enum AppSound {
  Default,
  Calm_Finish,
  Done_Chime,
  Simple,
  Alien_Chime,
  Breath_Out,
  Close_Out,
  Efficient,
  Electronic_Chime,
  Future_Chime,
  Magic_Computer,
  Magic_Wand,
  Marimba,
  Music_Box,
  Mystery,
  Open_Sky,
  Quick_Complete,
  Record_Scratch,
  Retro_Computer,
  Shooting_Star,
  Store_Door,
  Sustain_Complete,
  Tally,
  Temple_Bell,
  Triple_Bop,
  Upbeat,
  Vinyl_Rewind,
  Water_Drop,
}

class User {
  late String uid;
  late String displayName;
  late UserRole role;
  late SigninMethod signinMethod;
  late String photoUrl;
  late String email;
  late bool isAnonymous;
  late bool emailVerified;
  late bool madePurchase;
  late String defaultPlaylist;
  late String oldUid;
  late bool notificationsEnabled;
  late bool needsMerge;
  late bool isOnboarded;
  late bool hasRatedApp;
  String phoneNumber;
  String firstName;
  List<String> friends;
  int age;
  AppGender gender;
  BreathingMethod breathingMethod;
  List<Category> categories;
  List<String> entitlements;
  Category topCategory;
  ExperienceLevel experienceLevel;
  ReminderPreference reminderPreference;
  int reminderHour;
  int reminderMinute;
  // DateTime reminderTime;
  int created;
  bool categoriesSorted;
  bool notificationsAuthorized;
  List<TranceMethod> tranceInterests;
  String primaryGoalId;
  TranceMethod lastTranceMethod;
  bool doesntLikeVoice;
  bool completedTraining;
  bool accepted10DayChallenge;
  bool shownPremiumOption;
  List<TranceMethod> tranceTypesCompleted;
  List<HypnotherapySkill> skillsCompleted;
  int defaultBreathTime;
  int defaultMeditationTime;
  int defaultHypnotherapyTime;
  int defaultActiveHypnotherapyTime;
  int defaultSleepDelay;
  bool usesSleepDelay;
  ActiveBackgroundSound activeBackgroundSound;
  BackgroundSound backgroundSound;
  double backgroundVolume;
  double voiceVolume;
  String defaultInduction;
  String defaultDeepening;
  String defaultAwakening;
  bool usesDeepening;
  bool isStripe;
  int secondsDelayBetweenTracks;
  int score;
  int longestStreak;
  int currentStreak;
  int totalSessions;
  int totalMinutes;
  int mindfulDays;
  int lastStreakSave;
  int totalBreaths;
  bool givenFeedback;
  int totalSharesAccepted;
  String referrerUid;

  bool onboarededHypnotherapy;
  bool onboarededActive;
  bool onboarededBreathing;
  bool onboarededSleep;
  bool onboarededMeditation;

  AlarmSound alarmSound;
  AppSound defaultSound;
  int breathSeconds;
  bool emailSubscribed;
  int premiumUntil;

  User({
    required this.uid,
    this.isAnonymous = false,
    this.tranceInterests = const [],
    this.voiceVolume = 0.7,
    this.defaultSound = AppSound.Default,
    this.displayName = '',
    this.alarmSound = AlarmSound.Default,
    this.lastTranceMethod = TranceMethod.Hypnotherapy,
    this.role = UserRole.Basic,
    this.signinMethod = SigninMethod.None,
    this.hasRatedApp = false,
    this.breathingMethod = BreathingMethod.Energize,
    this.photoUrl = '',
    this.email = '',
    this.shownPremiumOption = false,
    this.phoneNumber = '',
    this.givenFeedback = false,
    this.onboarededHypnotherapy = false,
    this.onboarededActive = false,
    this.onboarededBreathing = false,
    this.onboarededSleep = false,
    this.onboarededMeditation = false,
    // this.reminderTime = DateTime.now(),
    this.referrerUid = '',
    this.totalSharesAccepted = 0,
    this.reminderHour = 0,
    this.reminderMinute = 0,
    this.emailVerified = false,
    this.defaultPlaylist = '',
    this.isOnboarded = false,
    this.entitlements = const [],
    this.friends = const [],
    this.needsMerge = false,
    this.topCategory = Category.Mental,
    this.madePurchase = false,
    this.notificationsEnabled = false,
    this.reminderPreference = ReminderPreference.Morning,
    this.firstName = '',
    this.gender = AppGender.Other,
    this.categories = const [],
    this.age = 0,
    this.experienceLevel = ExperienceLevel.Beginner,
    this.oldUid = '',
    int? created,
    this.categoriesSorted = false,
    this.notificationsAuthorized = false,
    this.doesntLikeVoice = false,
    this.primaryGoalId = '',
    this.completedTraining = false,
    this.accepted10DayChallenge = false,
    this.tranceTypesCompleted = const [],
    this.skillsCompleted = const [],
    this.defaultBreathTime = 4,
    this.defaultMeditationTime = 5,
    this.defaultHypnotherapyTime = 5,
    this.defaultActiveHypnotherapyTime = 10,
    this.defaultSleepDelay = 30,
    this.usesSleepDelay = true,
    this.backgroundSound = BackgroundSound.Waves,
    this.activeBackgroundSound = ActiveBackgroundSound.Fire,
    this.backgroundVolume = 0.7,
    this.defaultInduction = defaultInductionId,
    this.defaultDeepening = defaultDeepeningId,
    this.defaultAwakening = defaultAwakeningId,
    this.usesDeepening = true,
    this.isStripe = false,
    this.secondsDelayBetweenTracks = 5,
    this.score = 0,
    this.longestStreak = 0,
    this.currentStreak = 0,
    this.totalSessions = 0,
    this.totalMinutes = 0,
    this.mindfulDays = 0,
    int? lastStreakSave,
    this.breathSeconds = 4,
    this.totalBreaths = 0,
    this.emailSubscribed = false,
    this.premiumUntil = 0,
  })  : created = created ?? DateTime.now().millisecondsSinceEpoch,
        lastStreakSave =
            lastStreakSave ?? DateTime.now().millisecondsSinceEpoch;

  String get ageAttribute {
    String _age = 'Not Specified';
    if (age > 0) _age = "13 & under";
    if (age > 13) _age = "13-18";
    if (age > 18) _age = "18-25";
    if (age > 25) _age = "25-30";
    if (age > 30) _age = "30-35";
    if (age > 35) _age = "35-40";
    if (age > 40) _age = "40-45";
    if (age > 45) _age = "45-50";
    if (age > 50) _age = "50-55";
    if (age > 55) _age = "55-60";
    if (age > 60) _age = "60-65";
    if (age > 65) _age = "65-70";
    if (age > 70) _age = "70-75";
    if (age > 75) _age = "75-80";
    if (age > 80) _age = "80 & up";
    return _age;
  }

  String get totalTranceMinutesAttribute {
    String _totalMinutes = "0-10";
    if (totalMinutes > 0) _totalMinutes = "10-50";
    if (totalMinutes > 50) _totalMinutes = "50-100";
    if (totalMinutes > 100) _totalMinutes = "100-150";
    if (totalMinutes > 150) _totalMinutes = "150-200";
    if (totalMinutes > 200) _totalMinutes = "200-250";
    if (totalMinutes > 250) _totalMinutes = "250-300";
    if (totalMinutes > 300) _totalMinutes = "300-400";
    if (totalMinutes > 400) _totalMinutes = "400-500";
    if (totalMinutes > 500) _totalMinutes = "500-600";
    if (totalMinutes > 600) _totalMinutes = "600-700";
    if (totalMinutes > 700) _totalMinutes = "700-800";
    if (totalMinutes > 800) _totalMinutes = "800-900";
    if (totalMinutes > 900) _totalMinutes = "900-1000";
    if (totalMinutes > 1000) _totalMinutes = "1000-2000";
    if (totalMinutes > 2000) _totalMinutes = "2000-3000";
    return _totalMinutes;
  }

  bool get isPremium =>
      (role == UserRole.Premium || role == UserRole.Platinum) ||
      (premiumUntil > DateTime.now().millisecondsSinceEpoch);

  String get totalTranceSessionsAttribute {
    String _totalSessions = "0-10";
    if (totalSessions > 0) _totalSessions = "1-5";
    if (totalSessions > 5) _totalSessions = "5-10";
    if (totalSessions > 10) _totalSessions = "10-20";
    if (totalSessions > 20) _totalSessions = "20-30";
    if (totalSessions > 30) _totalSessions = "30-40";
    if (totalSessions > 40) _totalSessions = "40-50";
    if (totalSessions > 50) _totalSessions = "50-75";
    if (totalSessions > 75) _totalSessions = "75-100";
    if (totalSessions > 100) _totalSessions = "100-125";
    if (totalSessions > 125) _totalSessions = "125-150";
    if (totalSessions > 150) _totalSessions = "150-200";
    if (totalSessions > 200) _totalSessions = "200-300";
    if (totalSessions > 300) _totalSessions = "300-400";
    return _totalSessions;
  }

  factory User.fromMap(Map data) {
    try {
      List<Category> _categories = [];
      if (data['categories'] != null && data['categories'].isNotEmpty) {
        for (String category in data['categories']) {
          _categories.add(
            enumFromString<Category>(category, Category.values),
          );
        }
      }

      List<String> _friends = [];
      if (data['friends'] != null && data['friends'].isNotEmpty) {
        for (String friend in data['friends']) {
          _friends.add(friend);
        }
      }

      List<String> _entitlements = [];
      if (data['entitlements'] != null && data['entitlements'].isNotEmpty) {
        for (String entitlement in data['entitlements']) {
          _entitlements.add(entitlement);
        }
      }
      List<TranceMethod> _tranceInterests = [];
      if (data['tranceInterests'] != null &&
          data['tranceInterests'].isNotEmpty) {
        for (String interest in data['tranceInterests']) {
          _tranceInterests.add(
            enumFromString<TranceMethod>(interest, TranceMethod.values),
          );
        }
      }

      List<HypnotherapySkill> _skills = [];
      if (data['skillsCompleted'] != null &&
          data['skillsCompleted'].isNotEmpty) {
        data['skillsCompleted'].forEach((skill) {
          _skills.add(
            enumFromString<HypnotherapySkill>(skill, HypnotherapySkill.values),
          );
        });
      }
      List<TranceMethod> _tranceTypes = [];
      if (data['tranceTypesCompleted'] != null &&
          data['tranceTypesCompleted'].isNotEmpty) {
        data['tranceTypesCompleted'].forEach((tranceType) {
          _tranceTypes.add(
            enumFromString<TranceMethod>(tranceType, TranceMethod.values),
          );
        });
      }

      User _user = User(
        uid: data['uid'],
        madePurchase: data['madePurchase'] ?? false,
        phoneNumber: data['phoneNumber'],
        displayName: data['displayName'],
        tranceInterests: _tranceInterests,
        skillsCompleted: _skills,
        tranceTypesCompleted: _tranceTypes,
        backgroundVolume: data['backgroundVolume'] ?? .7,
        voiceVolume: data['voiceVolume'] ?? .7,
        reminderMinute: data['reminderMinute'] ?? 0,
        breathSeconds: data['breathSeconds'] ?? 4,
        reminderHour: data['reminderHour'],
        secondsDelayBetweenTracks: data['secondsDelayBetweenTracks'] ?? 5,
        // reminderTime: data['reminderTime'] == null
        //     ? null
        //     : DateTime.fromMillisecondsSinceEpoch(data['reminderTime']),
        role: enumFromString<UserRole>(data['role'], UserRole.values),
        gender: enumFromString<AppGender>(data['gender'], AppGender.values),
        breathingMethod: enumFromString<BreathingMethod>(
            data['breathingMethod'], BreathingMethod.values),
        topCategory:
            enumFromString<Category>(data['topCategory'], Category.values),
        experienceLevel: enumFromString<ExperienceLevel>(
            data['experienceLevel'], ExperienceLevel.values),
        reminderPreference: enumFromString<ReminderPreference>(
            data['reminderPreference'], ReminderPreference.values),
        categories: _categories,
        entitlements: _entitlements,
        age: data['age'],
        givenFeedback: data['givenFeedback'] ?? false,
        shownPremiumOption: data['shownPremiumOption'] ?? false,
        accepted10DayChallenge: data['accepted10DayChallenge'],
        firstName: data['firstName'],
        premiumUntil: data['premiumUntil'],
        signinMethod: enumFromString<SigninMethod>(
            data['signinMethod'], SigninMethod.values),
        lastTranceMethod: enumFromString<TranceMethod>(
            data['lastTranceMethod'], TranceMethod.values),
        backgroundSound: enumFromString<BackgroundSound>(
            data['backgroundSound'], BackgroundSound.values),
        activeBackgroundSound: enumFromString<ActiveBackgroundSound>(
            data['activeBackgroundSound'], ActiveBackgroundSound.values),
        photoUrl: data['photoUrl'],
        hasRatedApp: data['hasRatedApp'],
        email: data['email'],
        isAnonymous: data['isAnonymous'] ?? true,
        emailVerified: data['emailVerified'] ?? false,
        defaultPlaylist: data['defaultPlaylist'],
        oldUid: data['oldUid'],
        score: data['score'] ?? 0,
        totalSharesAccepted: data['totalSharesAccepted'] ?? 0,
        referrerUid: data['referrerUid'],
        totalSessions: data['totalSessions'] ?? 0,
        totalMinutes: data['totalMinutes'] ?? 0,
        mindfulDays: data['mindfulDays'] ?? 0,
        longestStreak: data['longestStreak'] ?? 0,
        currentStreak: data['currentStreak'] ?? 0,
        primaryGoalId: data['primaryGoalId'],
        onboarededHypnotherapy: data['onboarededHypnotherapy'] ?? false,
        onboarededActive: data['onboarededActive'] ?? false,
        onboarededBreathing: data['onboarededBreathing'] ?? false,
        onboarededSleep: data['onboarededSleep'] ?? false,
        onboarededMeditation: data['onboarededMeditation'] ?? false,
        doesntLikeVoice: data['doesntLikeVoice'] ?? false,
        notificationsEnabled: data['notificationsEnabled'] ?? false,
        needsMerge: data['needsMerge'] ?? false,
        isOnboarded: data['isOnboarded'] ?? false,
        categoriesSorted: data['categoriesSorted'] ?? false,
        friends: _friends,
        created: data['created']?.toInt() ??
            DateTime.now().toUtc().millisecondsSinceEpoch,
        notificationsAuthorized: data['notificationsAuthorized'] ?? false,
        completedTraining: data['completedTraining'] ?? false,
        defaultBreathTime: data['defaultBreathTime'] ?? 4,
        defaultMeditationTime: data['defaultMeditationTime'] ?? 5,
        defaultHypnotherapyTime: data['defaultHypnotherapyTime'] ?? 5,
        defaultActiveHypnotherapyTime:
            data['defaultActiveHypnotherapyTime'] ?? 10,
        defaultSleepDelay: data['defaultSleepDelay'] ?? 30,
        usesSleepDelay: data['usesSleepDelay'] ?? true,
        defaultInduction: data['defaultInduction'] ?? defaultInductionId,
        defaultAwakening: data['defaultAwakening'] ?? defaultAwakeningId,
        defaultDeepening: data['defaultDeepening'] ?? defaultDeepeningId,
        usesDeepening: data['usesDeepening'] ?? true,
        isStripe: data['isStripe'] ?? false,
        totalBreaths: data['totalBreaths'] ?? 0,
        lastStreakSave:
            data['lastStreakSave'] ?? DateTime.now().millisecondsSinceEpoch,
        emailSubscribed: data['emailSubscribed'],
      );
      return _user;
    } catch (e) {
      print("Error Mapping user $e");
      return User(uid: '', isAnonymous: true);
    }
  }
  BreathMethod get currentBreathMethod {
    int _defaultBreathTime = breathSeconds;
    return BreathMethod(
        breathOut: _defaultBreathTime * breathingMethod.method.breathOut,
        breathInHold: _defaultBreathTime * breathingMethod.method.breathInHold,
        breathOutHold:
            _defaultBreathTime * breathingMethod.method.breathOutHold,
        breathIn: _defaultBreathTime * breathingMethod.method.breathIn,
        title: breathingMethod.method.title,
        appColor: breathingMethod.method.appColor,
        longTitle: breathingMethod.method.longTitle,
        description: breathingMethod.method.description,
        icon: breathingMethod.method.icon,
        loop: true);
  }

  int get totalBreathsInSession => ((defaultBreathTime.minutes.inSeconds /
              (currentBreathMethod.breathIn +
                  currentBreathMethod.breathOut +
                  currentBreathMethod.breathIn +
                  currentBreathMethod.breathInHold +
                  currentBreathMethod.breathOutHold)) *
          2)
      .ceil();

  List<String>? get userCategories => categories.isNotEmpty
      ? categories.map((c) => enumToString(c)).toList()
      : null;

  Map<String, dynamic> toJson() {
    List<String> _categories = [];
    if (categories.isNotEmpty) {
      categories.forEach((element) {
        _categories.add(enumToString(element));
      });
    }
    List<String> _tranceInterests = [];
    if (tranceInterests.isNotEmpty) {
      tranceInterests.forEach((element) {
        _tranceInterests.add(enumToString(element));
      });
    }

    List<String> _skills = [];
    if (skillsCompleted.isNotEmpty) {
      skillsCompleted.forEach((element) {
        _skills.add(enumToString(element));
      });
    }
    List<String> _tranceTypes = [];
    if (tranceTypesCompleted.isNotEmpty) {
      tranceTypesCompleted.forEach((element) {
        _tranceTypes.add(enumToString(element));
      });
    }

    Map<String, dynamic> data = {
      'uid': uid,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'tranceInterests': _tranceInterests,
      'role': enumToString(role),
      'signinMethod': signinMethod.string,
      'skillsCompleted': _skills,
      'tranceTypesCompleted': _tranceTypes,
      'email': email,
      'entitlements': entitlements,
      'secondsDelayBetweenTracks': secondsDelayBetweenTracks,
      'isAnonymous': isAnonymous,
      'emailVerified': emailVerified,
      "madePurchase": madePurchase,
      "isOnboarded": isOnboarded,
      "hasRatedApp": hasRatedApp,
      "accepted10DayChallenge": accepted10DayChallenge,
      "experienceLevel": experienceLevel.string,
      "reminderPreference": enumToString(reminderPreference),
      "notificationsEnabled": notificationsEnabled,
      "oldUid": oldUid,
      "categories": _categories,
      "topCategory": enumToString(topCategory),
      "photoUrl": photoUrl,
      "friends": friends,
      "needsMerge": needsMerge,
      "gender": gender.string,
      "breathingMethod": breathingMethod.string,
      "reminderMinute": reminderMinute,
      "reminderHour": reminderHour,
      "activeBackgroundSound": enumToString(activeBackgroundSound),
      "backgroundSound": enumToString(backgroundSound),
      // "reminderTime": reminderTime.millisecondsSinceEpoch,
      "age": age,
      "firstName": firstName,
      "categoriesSorted": categoriesSorted,
      "primaryGoalId": primaryGoalId,
      "doesntLikeVoice": doesntLikeVoice,
      "created": created,
      "notificationsAuthorized": notificationsAuthorized,
      "completedTraining": completedTraining,
      "defaultBreathTime": defaultBreathTime,
      "breathSeconds": breathSeconds,
      "defaultMeditationTime": defaultMeditationTime,
      "defaultHypnotherapyTime": defaultHypnotherapyTime,
      "defaultActiveHypnotherapyTime": defaultActiveHypnotherapyTime,
      "defaultSleepDelay": defaultSleepDelay,
      "usesSleepDelay": usesSleepDelay,
      "score": score,
      "longestStreak": longestStreak,
      "currentStreak": currentStreak,
      "totalSessions": totalSessions,
      "totalMinutes": totalMinutes,
      "lastStreakSave": lastStreakSave,
      "voiceVolume": voiceVolume,
      "givenFeedback": givenFeedback,
      "shownPremiumOption": shownPremiumOption,
      "mindfulDays": mindfulDays,
      "onboarededHypnotherapy": onboarededHypnotherapy,
      "onboarededActive": onboarededActive,
      "onboarededBreathing": onboarededBreathing,
      "onboarededSleep": onboarededSleep,
      "onboarededMeditation": onboarededMeditation,
      "totalBreaths": totalBreaths,
      "emailSubscribed": emailSubscribed,
      "referrerUid": referrerUid,
      "totalSharesAccepted": totalSharesAccepted,
      "isStripe": isStripe,
      "premiumUntil": premiumUntil,
    };
    data.removeWhere((String key, dynamic value) => value == null);
    return data;
  }
}
