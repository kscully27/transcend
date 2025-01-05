// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:trancend/src/constants/enums.dart';
import 'package:trancend/src/shared/icons.dart';

enum ExperienceLevel { Beginner, Intermediate, Advanced }

class ExperienceLevelDetails {
  final String longTitle;
  final IconData icon;
  ExperienceLevelDetails({
    required this.longTitle,
    required this.icon,
  });
}

final Map<ExperienceLevel, ExperienceLevelDetails> experienceLevelDetails = {
  ExperienceLevel.Beginner: ExperienceLevelDetails(
    longTitle: "Complete beginner",
    icon: AppIcons.acorn,
  ),
  ExperienceLevel.Intermediate: ExperienceLevelDetails(
    longTitle: "I've done it a few times",
    icon: AppIcons.plant,
  ),
  ExperienceLevel.Advanced: ExperienceLevelDetails(
    longTitle: "I hypnotize myself weekly",
    icon: AppIcons.tree,
  ),
};

extension ExperienceLevelX on ExperienceLevel {
  String get string => enumToString(this);
  String get id => string.toLowerCase();
  String get longName => experienceLevelDetails[this]!.longTitle;
  IconData get icon => experienceLevelDetails[this]!.icon;
  ExperienceLevel fromString(String string) =>
      enumFromString(string, ExperienceLevel.values);
}
