import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recase/recase.dart';
import 'package:trancend/src/constants/enums.dart';
import 'package:trancend/src/models/session.model.dart' show TranceMethod;
import 'package:trancend/src/shared/icons.dart';

part 'user.model.freezed.dart';
part 'user.model.g.dart';

enum UserRole { Basic, Premium, Platinum }
enum SigninMethod { Email, Facebook, Google, Apple, EmailLink, Anonymous, None }
enum AppGender { Male, Female, Other }
enum ReminderPreference { Morning, Evening, None }
enum Category { Mental, Physical, Emotional, Spiritual, Lifestyle, Success }
// enum Category { Meditation, Sleep, Hypnotherapy, Active, Breathing, None }
enum ExperienceLevel { Beginner, Intermediate, Advanced }

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
  Sleep_Soothing,
  Sleep_Breathing,
  Sleep_Rythm,
  Sleep_Programming,
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


Map<ActiveBackgroundSound, IconData> activeBackgroundIcons = {
  ActiveBackgroundSound.Fire: AppIcons.fire,
  ActiveBackgroundSound.Electricity: AppIcons.electricity,
  ActiveBackgroundSound.Encouragement: AppIcons.encouragement,
  ActiveBackgroundSound.Energy: AppIcons.energy,
  ActiveBackgroundSound.Enhance: AppIcons.enhance,
  ActiveBackgroundSound.Flight: AppIcons.flight,
  ActiveBackgroundSound.Force: AppIcons.force,
  ActiveBackgroundSound.Ignition: AppIcons.ignition,
  ActiveBackgroundSound.Motivation: AppIcons.motivation,
  ActiveBackgroundSound.Passion: AppIcons.passion,
  ActiveBackgroundSound.Power: AppIcons.power,
  ActiveBackgroundSound.Spark: AppIcons.spark,
  ActiveBackgroundSound.Stamina: AppIcons.stamina,
  ActiveBackgroundSound.Strength: AppIcons.strength,
  ActiveBackgroundSound.None: AppIcons.none,
};

extension ActiveBackgroundSoundX on ActiveBackgroundSound {
  ActiveBackgroundSound fromString(String string) =>
      enumFromString(string, ActiveBackgroundSound.values);
  String get string => enumToString(this);
  String get id => enumToString(this).toLowerCase();
  IconData get icon => activeBackgroundIcons[this] ?? AppIcons.none;
  // String get mp3Path => 'assets/audio/loops/active/$id.mp3';
  String get path => 'active/$id.mp3';
}


enum HypnotherapyMethod {
  Guided,
  Cognitive,
  // Ericksonian,
  // NLP,
  Relaxed
}

Map<HypnotherapyMethod, String> hypnotherapyMethods = {
  HypnotherapyMethod.Guided: 'Guided',
  HypnotherapyMethod.Cognitive: 'Cognitive',
  // HypnotherapyMethod.Ericksonian: 'Ericksonian',
  // HypnotherapyMethod.NLP: 'NLP',
  HypnotherapyMethod.Relaxed: 'Relaxed',
};

// Map for hypnotherapy method descriptions
Map<HypnotherapyMethod, String> hypnotherapyMethodDescriptions = {
  HypnotherapyMethod.Guided: 'A gentle guided experience toward your desired outcome',
  HypnotherapyMethod.Cognitive: 'Combines hypnosis with cognitive behavioral techniques',
  HypnotherapyMethod.Relaxed: 'Deep relaxation focused on mental and physical healing',
};

// Map for hypnotherapy method icons
Map<HypnotherapyMethod, IconData> hypnotherapyMethodIcons = {
  HypnotherapyMethod.Guided: Icons.psychology,
  HypnotherapyMethod.Cognitive: Icons.sync_alt,
  HypnotherapyMethod.Relaxed: Icons.spa,
};

// Breathing methods enum
enum BreathingMethod {
  BalancedBreathing,
  ButeykoBreathing,
  BoxBreathing,
  FourSevenEightBreathing,
  // Keep original values for backward compatibility
  Energize,
  Focus,
  Relax
}

// Map for breathing method names
Map<BreathingMethod, String> breathingMethods = {
  BreathingMethod.BalancedBreathing: 'Balanced breathing',
  BreathingMethod.ButeykoBreathing: 'Buteyko breathing',
  BreathingMethod.BoxBreathing: 'Box breathing',
  BreathingMethod.FourSevenEightBreathing: '4-7-8 breathing',
  // Legacy values
  BreathingMethod.Energize: 'Energize',
  BreathingMethod.Focus: 'Focus',
  BreathingMethod.Relax: 'Relax',
};

// Map for breathing method descriptions
Map<BreathingMethod, String> breathingMethodDescriptions = {
  BreathingMethod.BalancedBreathing: 'Improves mood and relieves stress',
  BreathingMethod.ButeykoBreathing: 'Improve respiratory health and increase CO2',
  BreathingMethod.BoxBreathing: 'Quickly focus and improve your performance',
  BreathingMethod.FourSevenEightBreathing: 'Relax your mind and body to fall asleep quickly',
  // Legacy values
  BreathingMethod.Energize: 'Increase energy and alertness',
  BreathingMethod.Focus: 'Improve concentration and mental clarity',
  BreathingMethod.Relax: 'Reduce anxiety and promote relaxation',
};

// Map for breathing method icons
Map<BreathingMethod, IconData> breathingMethodIcons = {
  BreathingMethod.BalancedBreathing: Icons.balance,
  BreathingMethod.ButeykoBreathing: Icons.air,
  BreathingMethod.BoxBreathing: Icons.crop_square,
  BreathingMethod.FourSevenEightBreathing: Icons.bedtime,
  // Legacy values with appropriate icons
  BreathingMethod.Energize: Icons.bolt,
  BreathingMethod.Focus: Icons.center_focus_strong,
  BreathingMethod.Relax: Icons.waves,
};

// Meditation methods enum
enum MeditationMethod {
  Mindfulness,
  BodyScan,
  LovingKindness,
  Mantra,
  Visualization
}

// Map for meditation method names
Map<MeditationMethod, String> meditationMethods = {
  MeditationMethod.Mindfulness: 'Mindfulness',
  MeditationMethod.BodyScan: 'Body Scan',
  MeditationMethod.LovingKindness: 'Loving-Kindness',
  MeditationMethod.Mantra: 'Mantra',
  MeditationMethod.Visualization: 'Visualization',
};

// Map for meditation method descriptions
Map<MeditationMethod, String> meditationMethodDescriptions = {
  MeditationMethod.Mindfulness: 'Focus on being present and aware without judgment',
  MeditationMethod.BodyScan: 'Progressive relaxation by focusing on different body parts',
  MeditationMethod.LovingKindness: 'Cultivate compassion and kindness toward self and others',
  MeditationMethod.Mantra: 'Use repetitive sounds to clear the mind',
  MeditationMethod.Visualization: 'Create mental images of peaceful scenes or desired outcomes',
};

// Map for meditation method icons
Map<MeditationMethod, IconData> meditationMethodIcons = {
  MeditationMethod.Mindfulness: Icons.remove_red_eye,
  MeditationMethod.BodyScan: Icons.accessibility_new,
  MeditationMethod.LovingKindness: Icons.favorite,
  MeditationMethod.Mantra: Icons.record_voice_over,
  MeditationMethod.Visualization: Icons.panorama,
};

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


Map<BackgroundSound, IconData> backgroundIcons = {
  BackgroundSound.Waves: AppIcons.waves_1,
  BackgroundSound.Rain: AppIcons.rain,
  BackgroundSound.Campfire: AppIcons.campfire,
  BackgroundSound.Chimes: AppIcons.chimes,
  BackgroundSound.Stream: AppIcons.stream,
  BackgroundSound.Saturn: AppIcons.saturn,
  BackgroundSound.Sun: AppIcons.sun,
  BackgroundSound.City: AppIcons.city,
  BackgroundSound.Farm: AppIcons.farm,
  BackgroundSound.Wetlands: AppIcons.wetlands,
  BackgroundSound.Forest: AppIcons.forest,
  BackgroundSound.Train: AppIcons.train,
  BackgroundSound.Rainforest: AppIcons.rainforest,
  BackgroundSound.Nature: AppIcons.nature,
  BackgroundSound.None: AppIcons.none,
};

extension BackgroundSoundX on BackgroundSound {
  BackgroundSound fromString(String string) =>
      enumFromString(string, BackgroundSound.values);
  String get string => enumToString(this);
  String get id => enumToString(this).toLowerCase();
  IconData get icon => backgroundIcons[this] ?? AppIcons.none;
  // String get mp3Path => 'assets/audio/loops/relaxed/$id.mp3';
  String get path => 'relaxed/$id.mp3';
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

extension AppSoundsX on AppSound {
  AppSound fromString(String string) => enumFromString(string, AppSound.values);
  String get string => enumToString(this);
  String get id => string.toLowerCase();
  String get file => '/audio/$id.mp3';
  String get title => ReCase(string).titleCase;
}

@freezed
class User with _$User {
  @JsonSerializable()
  factory User({
    required String uid,
    required String email,
    required String displayName,
    required String photoUrl,
    @Default('') String phoneNumber,
    @Default('') String firstName,
    @Default([]) List<String> friends,
    @Default(0) int age,
    @Default(AppGender.Other) AppGender gender,
    @Default(BreathingMethod.Focus) BreathingMethod breathingMethod,
    @Default([]) List<Category> categories,
    @Default([]) List<String> entitlements,
    @Default(Category.Mental) Category topCategory,
    @Default(ExperienceLevel.Beginner) ExperienceLevel experienceLevel,
    @Default(ReminderPreference.None) ReminderPreference reminderPreference,
    @Default(0) int reminderHour,
    @Default(0) int reminderMinute,
    @Default(0) int created,
    @Default(false) bool categoriesSorted,
    @Default(false) bool notificationsAuthorized,
    @Default([]) List<TranceMethod> tranceInterests,
    @Default('') String primaryGoalId,
    @Default(TranceMethod.Meditation) TranceMethod lastTranceMethod,
    @Default(false) bool doesntLikeVoice,
    @Default(false) bool completedTraining,
    @Default(false) bool accepted10DayChallenge,
    @Default(false) bool shownPremiumOption,
    @Default([]) List<TranceMethod> tranceTypesCompleted,
    @Default([]) List<HypnotherapySkill> skillsCompleted,
    @Default(0) int defaultBreathTime,
    @Default(0) int defaultMeditationTime,
    @Default(0) int defaultHypnotherapyTime,
    @Default(0) int defaultActiveHypnotherapyTime,
    @Default(0) int defaultSleepDelay,
    @Default(false) bool usesSleepDelay,
    @Default(ActiveBackgroundSound.Fire) ActiveBackgroundSound activeBackgroundSound,
    @Default(BackgroundSound.Waves) BackgroundSound backgroundSound,
    @Default(0.2) double backgroundVolume,
    @Default(0.8) double voiceVolume,
    @Default('') String defaultInduction,
    @Default('') String defaultDeepening,
    @Default('') String defaultAwakening,
    @Default(false) bool usesDeepening,
    @Default(false) bool isStripe,
    @Default(4) int secondsDelayBetweenTracks,
    @Default(0) int score,
    @Default(0) int longestStreak,
    @Default(0) int currentStreak,
    @Default(0) int totalSessions,
    @Default(0) int totalMinutes,
    @Default(0) int mindfulDays,
    @Default(0) int lastStreakSave,
    @Default(0) int totalBreaths,
    @Default(false) bool givenFeedback,
    @Default(0) int totalSharesAccepted,
    @Default('') String referrerUid,
    @Default(false) bool onboarededHypnotherapy,
    @Default(false) bool onboarededActive,
    @Default(false) bool onboarededBreathing,
    @Default(false) bool onboarededSleep,
    @Default(false) bool onboarededMeditation,
    @Default(AlarmSound.Default) AlarmSound alarmSound,
    @Default(AppSound.Default) AppSound defaultSound,
    @Default(4) int breathSeconds,
    @Default(false) bool emailSubscribed,
    @Default(0) int premiumUntil,
    @Default(false) bool isAnonymous,
    @Default(false) bool emailVerified,
    @Default(false) bool madePurchase,
    @Default('') String defaultPlaylist,
    @Default('') String oldUid,
    @Default(true) bool notificationsEnabled,
    @Default(false) bool needsMerge,
    @Default(false) bool isOnboarded,
    @Default(false) bool hasRatedApp,
    DateTime? createdTime,
    DateTime? lastSignInTime,
    @Default(UserRole.Basic) UserRole role,
    @Default(SigninMethod.None) SigninMethod signinMethod,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isOnboardingComplete,
    @Default(false) bool isPremium,
    @Default(false) bool isSubscribed,
    @Default('') String stripeCustomerId,
    @Default('') String subscriptionId,
    @Default('') String subscriptionStatus,
    @Default(0) int subscriptionPriceId,
    @Default(0) int subscriptionStart,
    @Default(0) int subscriptionEnd,
    @Default(0) int trialEnd,
    @Default('') String currentProductId,
    @Default(null) HypnotherapyMethod? hypnotherapyMethod,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

class UserModel {
  final String? uid;
  final String? email;
  final String? displayName;
  final BackgroundSound? backgroundSound;
  // ... other fields ...

  UserModel({
    this.uid,
    this.email,
    this.displayName,
    this.backgroundSound,
    // ... other fields ...
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    BackgroundSound? backgroundSound,
    // ... other fields ...
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      backgroundSound: backgroundSound ?? this.backgroundSound,
      // ... other fields ...
    );
  }

  // ... other methods ...
}
