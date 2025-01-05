
// // ignore_for_file: constant_identifier_names

// import 'package:flutter/material.dart';
// import 'package:trancend/src/constants/app_colors.dart';

// enum HasTranceOption { Yes, No, Optional }

// class TranceDetails {
//   String name;
//   IconData icon;
//   CategoryColor color;
//   String longName;
//   String description;
//   String reason;
//   // SliderGroup onboarding;

//   final HasTranceOption hasInduction;
//   final HasTranceOption hasDeepening;
//   final HasTranceOption hasAwakening;
//   final HasTranceOption hasSuggestions;

//   TranceDetails(
//       {required this.name,
//       required this.icon,
//       required this.color,
//       required this.longName,
//       required this.description,
//       required this.hasInduction,
//       required this.hasDeepening,
//       required this.hasAwakening,
//       required this.hasSuggestions,
//       // required this.onboarding,
//       required this.reason});
// }

// enum TranceMethod { Hypnotherapy, Meditation, Breathing, Active, Sleep }

// final Map<TranceMethod, TranceDetails> tranceMethod = {
//   TranceMethod.Hypnotherapy: TranceDetails(
//     name: "Hypnotherapy",
//     icon: Icons.airline_seat_flat_angled,
//     color: CategoryColor.Blue,
//     longName: "Relaxed Hypnotherapy",
//     description: "Guided hypnosis session",
//     reason:
//         "Regular hypnotherapy sessions will produce lasting change in your brain",
//     hasInduction: HasTranceOption.Yes,
//     hasDeepening: HasTranceOption.Optional,
//     hasSuggestions: HasTranceOption.Yes,
//     hasAwakening: HasTranceOption.Yes,
//     onboarding: SliderGroup(
//       folder: "hypnotherapy",
//       slides: [
//         Slide(
//           title: "Relax and settle in",
//           subtitle: "Find a peaceful, quiet place",
//           subtitle2: "for you to lay down",
//         ),
//         Slide(
//           title: "Close your eyes",
//           subtitle: "Find a peaceful, quiet place",
//           subtitle2: "for you to lay down",
//         ),
//       ],
//     ),
//   ),
//   TranceMethod.Meditation: TranceDetails(
//     name: "Meditation",
//     icon: AppIcons.meditate,
//     color: CategoryColor.Orange,
//     longName: "Affirmation Meditation",
//     description: "A form of light hypnosis grounded in mindful meditation",
//     reason: "Focus on mindfulness while you program your subconscious",
//     hasInduction: HasTranceOption.No,
//     hasDeepening: HasTranceOption.No,
//     hasSuggestions: HasTranceOption.Yes,
//     hasAwakening: HasTranceOption.No,
//     onboarding: SliderGroup(
//       folder: "meditation",
//       slides: [],
//     ),
//   ),
//   TranceMethod.Breathing: TranceDetails(
//     name: "Breathwork",
//     icon: AppIcons.lungs,
//     color: CategoryColor.Red,
//     longName: "Suggestive Breathing",
//     reason: "Changing your breathing helps to change patterns in your brain",
//     description: "Breathing exercises combined with hypnotherapy suggestions",
//     hasInduction: HasTranceOption.No,
//     hasDeepening: HasTranceOption.No,
//     hasSuggestions: HasTranceOption.Yes,
//     hasAwakening: HasTranceOption.No,
//     onboarding: SliderGroup(
//       folder: "breathwork",
//       slides: [],
//     ),
//   ),
//   TranceMethod.Active: TranceDetails(
//     name: "Active",
//     icon: Icons.directions_bike,
//     color: CategoryColor.Green,
//     longName: "Active-State Hypnosis",
//     description: "Work out while under hypnosis",
//     reason: "Focus on an active state, allowing patterns to take hold",
//     hasInduction: HasTranceOption.Yes,
//     hasDeepening: HasTranceOption.Optional,
//     hasSuggestions: HasTranceOption.Yes,
//     hasAwakening: HasTranceOption.Yes,
//     onboarding: SliderGroup(
//       folder: "active",
//       slides: [],
//     ),
//   ),
//   TranceMethod.Sleep: TranceDetails(
//     name: "Sleep",
//     icon: AppIcons.bed,
//     color: CategoryColor.Purple,
//     longName: "Sleep Programming",
//     reason: "Plant desired behaviors deep in your brain while you sleep",
//     description:
//         "Suggestions are played lightly while you sleep, anchoring change in your dreams",
//     hasInduction: HasTranceOption.Optional,
//     hasDeepening: HasTranceOption.Optional,
//     hasSuggestions: HasTranceOption.Yes,
//     hasAwakening: HasTranceOption.No,
//     onboarding: SliderGroup(
//       folder: "sleep",
//       slides: [],
//     ),
//   ),
// };

// extension TranceMethodX on TranceMethod {
//   TranceMethod fromString(String string) =>
//       enumFromString(string, TranceMethod.values);
//   String get string => enumToString(this);
//   String get id => enumToString(this).toLowerCase();
//   String get name => tranceMethod[this]?.name ?? '';
//   String get longName => tranceMethod[this]?.longName ?? '';
//   String get reason => tranceMethod[this]?.reason ?? '';
//   String get description => tranceMethod[this]?.description ?? '';
//   IconData get icon => tranceMethod[this]?.icon ?? AppIcons.none;
//   CategoryColor get color => tranceMethod[this]?.color ?? CategoryColor.Blue;
//   HasTranceOption get hasInduction =>
//       tranceMethod[this]?.hasInduction ?? HasTranceOption.No;
//   HasTranceOption get hasDeepening => tranceMethod[this]?.hasDeepening ?? HasTranceOption.No;
//   HasTranceOption get hasSuggestions => tranceMethod[this]?.hasSuggestions ?? HasTranceOption.No;
//   HasTranceOption get hasAwakening => tranceMethod[this]?.hasAwakening ?? HasTranceOption.No;
// }
