// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:trancend/src/constants/enums.dart';
import 'package:trancend/src/shared/icons.dart';

enum BreathType {
  In,
  Out,
  HoldIn,
  HoldOut,
}

enum BreathingType {
  InOut,
  InHoldOut,
  InOutHold,
  InHoldOutHold,
}

enum BreathingMethod {
  // Oxygenate,
  Energize,
  Focus,
  Relax,
}

class BreathMethod {
  final int breathIn;
  final int breathOut;
  final int breathInHold;
  final int breathOutHold;
  final BreathingType breathingType;
  final String appColor;
  final bool loop;
  final String description;
  final String title;
  final String longTitle;
  final IconData icon;
  BreathMethod({
    this.breathIn = 4,
    this.breathInHold = 4,
    this.breathOut = 4,
    this.breathOutHold = 4,
    this.breathingType = BreathingType.InOut,
    this.appColor = "red",
    this.description = "",
    this.title = "",
    this.longTitle = "",
    this.loop = false,
    this.icon = Icons.circle,
  });
}

final Map<BreathingMethod, BreathMethod> breathMethods = {
  // BreathingMethod.Oxygenate: BreathMethod(title:"Oxygenate", description:"Fill your blood up with oxygen. Great to do before a workout or to start your day.", breathIn: 8, breathInHold: 8, breathOut: 4, breathOutHold: 4),
  BreathingMethod.Energize: BreathMethod(
    title: "Energize",
    longTitle: "Energized Breathwork",
    icon: Icons.directions_bike,
    appColor: "blue",
    description:
        "Fill your blood up with oxygen. Great to do before a workout or activity",
    breathIn: 2,
    breathInHold: 2,
    breathOut: 1,
    breathOutHold: 1,
    loop: true,
  ),
  BreathingMethod.Focus: BreathMethod(
    title: "Focus",
    longTitle: "Focused Breathwork",
    icon: AppIcons.target,
    appColor: "red",
    description:
        "This technique is used by marine snipers to stay alert and calm",
    breathIn: 1,
    breathInHold: 1,
    breathOut: 1,
    breathOutHold: 1,
    loop: true,
  ),
  BreathingMethod.Relax: BreathMethod(
    title: "Relax",
    longTitle: "Relaxation Breathwork",
    icon: AppIcons.yawning,
    appColor: "dark",
    description:
        "A necessity before bedtime. Get all of that oxygen out of your system",
    breathIn: 1,
    breathInHold: 1,
    breathOut: 2,
    breathOutHold: 2,
    loop: true,
  ),
};

extension BreathingMethodX on BreathingMethod {
  BreathingMethod fromString(String string) =>
      enumFromString(string, BreathingMethod.values);
  String get string => enumToString(this);
  BreathMethod get method => breathMethods[this] ?? BreathMethod();
  String get title => method.title;
  String get longTitle => method.longTitle;
  String get description => method.description;
  String get appColor => method.appColor;
  IconData get icon => method.icon;
}
