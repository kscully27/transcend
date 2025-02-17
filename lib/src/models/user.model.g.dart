// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String,
      phoneNumber: json['phoneNumber'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      friends: (json['friends'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      age: (json['age'] as num?)?.toInt() ?? 0,
      gender: $enumDecodeNullable(_$AppGenderEnumMap, json['gender']) ??
          AppGender.Other,
      breathingMethod: $enumDecodeNullable(
              _$BreathingMethodEnumMap, json['breathingMethod']) ??
          BreathingMethod.Focus,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$CategoryEnumMap, e))
              .toList() ??
          const [],
      entitlements: (json['entitlements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      topCategory:
          $enumDecodeNullable(_$CategoryEnumMap, json['topCategory']) ??
              Category.Mental,
      experienceLevel: $enumDecodeNullable(
              _$ExperienceLevelEnumMap, json['experienceLevel']) ??
          ExperienceLevel.Beginner,
      reminderPreference: $enumDecodeNullable(
              _$ReminderPreferenceEnumMap, json['reminderPreference']) ??
          ReminderPreference.None,
      reminderHour: (json['reminderHour'] as num?)?.toInt() ?? 0,
      reminderMinute: (json['reminderMinute'] as num?)?.toInt() ?? 0,
      created: (json['created'] as num?)?.toInt() ?? 0,
      categoriesSorted: json['categoriesSorted'] as bool? ?? false,
      notificationsAuthorized:
          json['notificationsAuthorized'] as bool? ?? false,
      tranceInterests: (json['tranceInterests'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$TranceMethodEnumMap, e))
              .toList() ??
          const [],
      primaryGoalId: json['primaryGoalId'] as String? ?? '',
      lastTranceMethod: $enumDecodeNullable(
              _$TranceMethodEnumMap, json['lastTranceMethod']) ??
          TranceMethod.Meditation,
      doesntLikeVoice: json['doesntLikeVoice'] as bool? ?? false,
      completedTraining: json['completedTraining'] as bool? ?? false,
      accepted10DayChallenge: json['accepted10DayChallenge'] as bool? ?? false,
      shownPremiumOption: json['shownPremiumOption'] as bool? ?? false,
      tranceTypesCompleted: (json['tranceTypesCompleted'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$TranceMethodEnumMap, e))
              .toList() ??
          const [],
      skillsCompleted: (json['skillsCompleted'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$HypnotherapySkillEnumMap, e))
              .toList() ??
          const [],
      defaultBreathTime: (json['defaultBreathTime'] as num?)?.toInt() ?? 0,
      defaultMeditationTime:
          (json['defaultMeditationTime'] as num?)?.toInt() ?? 0,
      defaultHypnotherapyTime:
          (json['defaultHypnotherapyTime'] as num?)?.toInt() ?? 0,
      defaultActiveHypnotherapyTime:
          (json['defaultActiveHypnotherapyTime'] as num?)?.toInt() ?? 0,
      defaultSleepDelay: (json['defaultSleepDelay'] as num?)?.toInt() ?? 0,
      usesSleepDelay: json['usesSleepDelay'] as bool? ?? false,
      activeBackgroundSound: $enumDecodeNullable(
              _$ActiveBackgroundSoundEnumMap, json['activeBackgroundSound']) ??
          ActiveBackgroundSound.Fire,
      backgroundSound: $enumDecodeNullable(
              _$BackgroundSoundEnumMap, json['backgroundSound']) ??
          BackgroundSound.Waves,
      backgroundVolume: (json['backgroundVolume'] as num?)?.toDouble() ?? 0.2,
      voiceVolume: (json['voiceVolume'] as num?)?.toDouble() ?? 0.8,
      defaultInduction: json['defaultInduction'] as String? ?? '',
      defaultDeepening: json['defaultDeepening'] as String? ?? '',
      defaultAwakening: json['defaultAwakening'] as String? ?? '',
      usesDeepening: json['usesDeepening'] as bool? ?? false,
      isStripe: json['isStripe'] as bool? ?? false,
      secondsDelayBetweenTracks:
          (json['secondsDelayBetweenTracks'] as num?)?.toInt() ?? 4,
      score: (json['score'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
      totalMinutes: (json['totalMinutes'] as num?)?.toInt() ?? 0,
      mindfulDays: (json['mindfulDays'] as num?)?.toInt() ?? 0,
      lastStreakSave: (json['lastStreakSave'] as num?)?.toInt() ?? 0,
      totalBreaths: (json['totalBreaths'] as num?)?.toInt() ?? 0,
      givenFeedback: json['givenFeedback'] as bool? ?? false,
      totalSharesAccepted: (json['totalSharesAccepted'] as num?)?.toInt() ?? 0,
      referrerUid: json['referrerUid'] as String? ?? '',
      onboarededHypnotherapy: json['onboarededHypnotherapy'] as bool? ?? false,
      onboarededActive: json['onboarededActive'] as bool? ?? false,
      onboarededBreathing: json['onboarededBreathing'] as bool? ?? false,
      onboarededSleep: json['onboarededSleep'] as bool? ?? false,
      onboarededMeditation: json['onboarededMeditation'] as bool? ?? false,
      alarmSound:
          $enumDecodeNullable(_$AlarmSoundEnumMap, json['alarmSound']) ??
              AlarmSound.Default,
      defaultSound:
          $enumDecodeNullable(_$AppSoundEnumMap, json['defaultSound']) ??
              AppSound.Default,
      breathSeconds: (json['breathSeconds'] as num?)?.toInt() ?? 4,
      emailSubscribed: json['emailSubscribed'] as bool? ?? false,
      premiumUntil: (json['premiumUntil'] as num?)?.toInt() ?? 0,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      emailVerified: json['emailVerified'] as bool? ?? false,
      madePurchase: json['madePurchase'] as bool? ?? false,
      defaultPlaylist: json['defaultPlaylist'] as String? ?? '',
      oldUid: json['oldUid'] as String? ?? '',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      needsMerge: json['needsMerge'] as bool? ?? false,
      isOnboarded: json['isOnboarded'] as bool? ?? false,
      hasRatedApp: json['hasRatedApp'] as bool? ?? false,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
      lastSignInTime: json['lastSignInTime'] == null
          ? null
          : DateTime.parse(json['lastSignInTime'] as String),
      role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ??
          UserRole.Basic,
      signinMethod:
          $enumDecodeNullable(_$SigninMethodEnumMap, json['signinMethod']) ??
              SigninMethod.None,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isOnboardingComplete: json['isOnboardingComplete'] as bool? ?? false,
      isPremium: json['isPremium'] as bool? ?? false,
      isSubscribed: json['isSubscribed'] as bool? ?? false,
      stripeCustomerId: json['stripeCustomerId'] as String? ?? '',
      subscriptionId: json['subscriptionId'] as String? ?? '',
      subscriptionStatus: json['subscriptionStatus'] as String? ?? '',
      subscriptionPriceId: (json['subscriptionPriceId'] as num?)?.toInt() ?? 0,
      subscriptionStart: (json['subscriptionStart'] as num?)?.toInt() ?? 0,
      subscriptionEnd: (json['subscriptionEnd'] as num?)?.toInt() ?? 0,
      trialEnd: (json['trialEnd'] as num?)?.toInt() ?? 0,
      currentProductId: json['currentProductId'] as String? ?? '',
      hypnotherapyMethod: $enumDecodeNullable(
              _$HypnotherapyMethodEnumMap, json['hypnotherapyMethod']) ??
          null,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'phoneNumber': instance.phoneNumber,
      'firstName': instance.firstName,
      'friends': instance.friends,
      'age': instance.age,
      'gender': _$AppGenderEnumMap[instance.gender]!,
      'breathingMethod': _$BreathingMethodEnumMap[instance.breathingMethod]!,
      'categories':
          instance.categories.map((e) => _$CategoryEnumMap[e]!).toList(),
      'entitlements': instance.entitlements,
      'topCategory': _$CategoryEnumMap[instance.topCategory]!,
      'experienceLevel': _$ExperienceLevelEnumMap[instance.experienceLevel]!,
      'reminderPreference':
          _$ReminderPreferenceEnumMap[instance.reminderPreference]!,
      'reminderHour': instance.reminderHour,
      'reminderMinute': instance.reminderMinute,
      'created': instance.created,
      'categoriesSorted': instance.categoriesSorted,
      'notificationsAuthorized': instance.notificationsAuthorized,
      'tranceInterests': instance.tranceInterests
          .map((e) => _$TranceMethodEnumMap[e]!)
          .toList(),
      'primaryGoalId': instance.primaryGoalId,
      'lastTranceMethod': _$TranceMethodEnumMap[instance.lastTranceMethod]!,
      'doesntLikeVoice': instance.doesntLikeVoice,
      'completedTraining': instance.completedTraining,
      'accepted10DayChallenge': instance.accepted10DayChallenge,
      'shownPremiumOption': instance.shownPremiumOption,
      'tranceTypesCompleted': instance.tranceTypesCompleted
          .map((e) => _$TranceMethodEnumMap[e]!)
          .toList(),
      'skillsCompleted': instance.skillsCompleted
          .map((e) => _$HypnotherapySkillEnumMap[e]!)
          .toList(),
      'defaultBreathTime': instance.defaultBreathTime,
      'defaultMeditationTime': instance.defaultMeditationTime,
      'defaultHypnotherapyTime': instance.defaultHypnotherapyTime,
      'defaultActiveHypnotherapyTime': instance.defaultActiveHypnotherapyTime,
      'defaultSleepDelay': instance.defaultSleepDelay,
      'usesSleepDelay': instance.usesSleepDelay,
      'activeBackgroundSound':
          _$ActiveBackgroundSoundEnumMap[instance.activeBackgroundSound]!,
      'backgroundSound': _$BackgroundSoundEnumMap[instance.backgroundSound]!,
      'backgroundVolume': instance.backgroundVolume,
      'voiceVolume': instance.voiceVolume,
      'defaultInduction': instance.defaultInduction,
      'defaultDeepening': instance.defaultDeepening,
      'defaultAwakening': instance.defaultAwakening,
      'usesDeepening': instance.usesDeepening,
      'isStripe': instance.isStripe,
      'secondsDelayBetweenTracks': instance.secondsDelayBetweenTracks,
      'score': instance.score,
      'longestStreak': instance.longestStreak,
      'currentStreak': instance.currentStreak,
      'totalSessions': instance.totalSessions,
      'totalMinutes': instance.totalMinutes,
      'mindfulDays': instance.mindfulDays,
      'lastStreakSave': instance.lastStreakSave,
      'totalBreaths': instance.totalBreaths,
      'givenFeedback': instance.givenFeedback,
      'totalSharesAccepted': instance.totalSharesAccepted,
      'referrerUid': instance.referrerUid,
      'onboarededHypnotherapy': instance.onboarededHypnotherapy,
      'onboarededActive': instance.onboarededActive,
      'onboarededBreathing': instance.onboarededBreathing,
      'onboarededSleep': instance.onboarededSleep,
      'onboarededMeditation': instance.onboarededMeditation,
      'alarmSound': _$AlarmSoundEnumMap[instance.alarmSound]!,
      'defaultSound': _$AppSoundEnumMap[instance.defaultSound]!,
      'breathSeconds': instance.breathSeconds,
      'emailSubscribed': instance.emailSubscribed,
      'premiumUntil': instance.premiumUntil,
      'isAnonymous': instance.isAnonymous,
      'emailVerified': instance.emailVerified,
      'madePurchase': instance.madePurchase,
      'defaultPlaylist': instance.defaultPlaylist,
      'oldUid': instance.oldUid,
      'notificationsEnabled': instance.notificationsEnabled,
      'needsMerge': instance.needsMerge,
      'isOnboarded': instance.isOnboarded,
      'hasRatedApp': instance.hasRatedApp,
      'createdTime': instance.createdTime?.toIso8601String(),
      'lastSignInTime': instance.lastSignInTime?.toIso8601String(),
      'role': _$UserRoleEnumMap[instance.role]!,
      'signinMethod': _$SigninMethodEnumMap[instance.signinMethod]!,
      'isEmailVerified': instance.isEmailVerified,
      'isOnboardingComplete': instance.isOnboardingComplete,
      'isPremium': instance.isPremium,
      'isSubscribed': instance.isSubscribed,
      'stripeCustomerId': instance.stripeCustomerId,
      'subscriptionId': instance.subscriptionId,
      'subscriptionStatus': instance.subscriptionStatus,
      'subscriptionPriceId': instance.subscriptionPriceId,
      'subscriptionStart': instance.subscriptionStart,
      'subscriptionEnd': instance.subscriptionEnd,
      'trialEnd': instance.trialEnd,
      'currentProductId': instance.currentProductId,
      'hypnotherapyMethod':
          _$HypnotherapyMethodEnumMap[instance.hypnotherapyMethod],
    };

const _$AppGenderEnumMap = {
  AppGender.Male: 'Male',
  AppGender.Female: 'Female',
  AppGender.Other: 'Other',
};

const _$BreathingMethodEnumMap = {
  BreathingMethod.Energize: 'Energize',
  BreathingMethod.Focus: 'Focus',
  BreathingMethod.Relax: 'Relax',
};

const _$CategoryEnumMap = {
  Category.Mental: 'Mental',
  Category.Physical: 'Physical',
  Category.Emotional: 'Emotional',
  Category.Spiritual: 'Spiritual',
  Category.Lifestyle: 'Lifestyle',
  Category.Success: 'Success',
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.Beginner: 'Beginner',
  ExperienceLevel.Intermediate: 'Intermediate',
  ExperienceLevel.Advanced: 'Advanced',
};

const _$ReminderPreferenceEnumMap = {
  ReminderPreference.Morning: 'Morning',
  ReminderPreference.Evening: 'Evening',
  ReminderPreference.None: 'None',
};

const _$TranceMethodEnumMap = {
  TranceMethod.Hypnosis: 'Hypnosis',
  TranceMethod.Breathe: 'Breathe',
  TranceMethod.Meditation: 'Meditation',
  TranceMethod.Active: 'Active',
  TranceMethod.Sleep: 'Sleep',
};

const _$HypnotherapySkillEnumMap = {
  HypnotherapySkill.Mindfulness: 'Mindfulness',
  HypnotherapySkill.Basic_Hypnotherapy: 'Basic_Hypnotherapy',
  HypnotherapySkill.Awareness: 'Awareness',
  HypnotherapySkill.Breath_Focus: 'Breath_Focus',
  HypnotherapySkill.Active_Hypnosis: 'Active_Hypnosis',
  HypnotherapySkill.Mindful_Hypnosis: 'Mindful_Hypnosis',
  HypnotherapySkill.Body_Scan: 'Body_Scan',
  HypnotherapySkill.Labeling: 'Labeling',
  HypnotherapySkill.Empathy: 'Empathy',
  HypnotherapySkill.Spotlighting: 'Spotlighting',
  HypnotherapySkill.Oxygenated_Breathing: 'Oxygenated_Breathing',
  HypnotherapySkill.Boxed_Breathing: 'Boxed_Breathing',
  HypnotherapySkill.Visualization: 'Visualization',
  HypnotherapySkill.Innovation: 'Innovation',
  HypnotherapySkill.Self_Direction: 'Self_Direction',
  HypnotherapySkill.Sleep_Soothing: 'Sleep_Soothing',
  HypnotherapySkill.Sleep_Breathing: 'Sleep_Breathing',
  HypnotherapySkill.Sleep_Rythm: 'Sleep_Rythm',
  HypnotherapySkill.Sleep_Programming: 'Sleep_Programming',
};

const _$ActiveBackgroundSoundEnumMap = {
  ActiveBackgroundSound.Fire: 'Fire',
  ActiveBackgroundSound.Electricity: 'Electricity',
  ActiveBackgroundSound.Encouragement: 'Encouragement',
  ActiveBackgroundSound.Energy: 'Energy',
  ActiveBackgroundSound.Enhance: 'Enhance',
  ActiveBackgroundSound.Flight: 'Flight',
  ActiveBackgroundSound.Force: 'Force',
  ActiveBackgroundSound.Ignition: 'Ignition',
  ActiveBackgroundSound.Motivation: 'Motivation',
  ActiveBackgroundSound.Passion: 'Passion',
  ActiveBackgroundSound.Power: 'Power',
  ActiveBackgroundSound.Spark: 'Spark',
  ActiveBackgroundSound.Stamina: 'Stamina',
  ActiveBackgroundSound.Strength: 'Strength',
  ActiveBackgroundSound.None: 'None',
};

const _$BackgroundSoundEnumMap = {
  BackgroundSound.Waves: 'Waves',
  BackgroundSound.Rain: 'Rain',
  BackgroundSound.Campfire: 'Campfire',
  BackgroundSound.Chimes: 'Chimes',
  BackgroundSound.Stream: 'Stream',
  BackgroundSound.Saturn: 'Saturn',
  BackgroundSound.Sun: 'Sun',
  BackgroundSound.City: 'City',
  BackgroundSound.Farm: 'Farm',
  BackgroundSound.Wetlands: 'Wetlands',
  BackgroundSound.Forest: 'Forest',
  BackgroundSound.Train: 'Train',
  BackgroundSound.Rainforest: 'Rainforest',
  BackgroundSound.Nature: 'Nature',
  BackgroundSound.None: 'None',
};

const _$AlarmSoundEnumMap = {
  AlarmSound.Default: 'Default',
  AlarmSound.Marimba: 'Marimba',
  AlarmSound.Glissando: 'Glissando',
  AlarmSound.Twinkle: 'Twinkle',
  AlarmSound.Flutter: 'Flutter',
  AlarmSound.Fantasy: 'Fantasy',
  AlarmSound.Simple: 'Simple',
  AlarmSound.Beep: 'Beep',
  AlarmSound.Godmother: 'Godmother',
  AlarmSound.Watch_Alarm: 'Watch_Alarm',
  AlarmSound.Magic_Wand: 'Magic_Wand',
};

const _$AppSoundEnumMap = {
  AppSound.Default: 'Default',
  AppSound.Calm_Finish: 'Calm_Finish',
  AppSound.Done_Chime: 'Done_Chime',
  AppSound.Simple: 'Simple',
  AppSound.Alien_Chime: 'Alien_Chime',
  AppSound.Breath_Out: 'Breath_Out',
  AppSound.Close_Out: 'Close_Out',
  AppSound.Efficient: 'Efficient',
  AppSound.Electronic_Chime: 'Electronic_Chime',
  AppSound.Future_Chime: 'Future_Chime',
  AppSound.Magic_Computer: 'Magic_Computer',
  AppSound.Magic_Wand: 'Magic_Wand',
  AppSound.Marimba: 'Marimba',
  AppSound.Music_Box: 'Music_Box',
  AppSound.Mystery: 'Mystery',
  AppSound.Open_Sky: 'Open_Sky',
  AppSound.Quick_Complete: 'Quick_Complete',
  AppSound.Record_Scratch: 'Record_Scratch',
  AppSound.Retro_Computer: 'Retro_Computer',
  AppSound.Shooting_Star: 'Shooting_Star',
  AppSound.Store_Door: 'Store_Door',
  AppSound.Sustain_Complete: 'Sustain_Complete',
  AppSound.Tally: 'Tally',
  AppSound.Temple_Bell: 'Temple_Bell',
  AppSound.Triple_Bop: 'Triple_Bop',
  AppSound.Upbeat: 'Upbeat',
  AppSound.Vinyl_Rewind: 'Vinyl_Rewind',
  AppSound.Water_Drop: 'Water_Drop',
};

const _$UserRoleEnumMap = {
  UserRole.Basic: 'Basic',
  UserRole.Premium: 'Premium',
  UserRole.Platinum: 'Platinum',
};

const _$SigninMethodEnumMap = {
  SigninMethod.Email: 'Email',
  SigninMethod.Facebook: 'Facebook',
  SigninMethod.Google: 'Google',
  SigninMethod.Apple: 'Apple',
  SigninMethod.EmailLink: 'EmailLink',
  SigninMethod.Anonymous: 'Anonymous',
  SigninMethod.None: 'None',
};

const _$HypnotherapyMethodEnumMap = {
  HypnotherapyMethod.Guided: 'Guided',
  HypnotherapyMethod.Cognitive: 'Cognitive',
  HypnotherapyMethod.Relaxed: 'Relaxed',
};
