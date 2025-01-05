import 'package:flutter/material.dart';
import 'package:trancend/src/constants/app_colors.dart';

class Topic {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String image;
  final String svg;
  final String group;
  final String goal;
  final String activeVerb;
  final double totalDuration;
  final int totalFileSize;
  final int totalTracks;
  final bool isDefault;
  final bool isPremium;
  final bool isMentalHealth;
  final bool isPriority;
  final double price;
  bool isLocked;
  double strength;

  Topic({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
    required this.svg,
    required this.group,
    required this.goal,
    required this.totalDuration,
    required this.totalFileSize,
    required this.totalTracks,
    required this.activeVerb,
    required this.price,
    required this.isDefault,
    required this.isPremium,
    required this.isMentalHealth,
    required this.strength,
    required this.isPriority,
    required this.isLocked,
  });

  String get appColor => AppColors.getColorName(group);
  Color get flat => AppColors.flat(AppColors.getColorName(group));
  Color get light => AppColors.light(AppColors.getColorName(group));
  Color get dark => AppColors.dark(AppColors.getColorName(group));
  Color get highlight => AppColors.highlight(AppColors.getColorName(group));
  Color get shadow => AppColors.shadow(AppColors.getColorName(group));

  factory Topic.fromMap(Map data) {
    return Topic(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      image: data['image'],
      icon: data['icon'],
      svg: data['svg'],
      goal: data['goal'],
      group: data['group'],
      activeVerb: data['activeVerb'],
      price: data['price'],
      totalTracks: data['totalTracks'],
      isPremium: data['isPremium'] ?? false,
      isDefault: data['isDefault'],
      isMentalHealth: data['isMentalHealth'],
      isPriority: data['isPriority'],
      strength: data['strength'],
      totalDuration: data['totalDuration'],
      totalFileSize: data['totalFileSize'],
      isLocked: data['isLocked'],
    );
  }
  // bool fromUser(User user) {
  //   return isLocked = user.isPremium ? false : isPremium;
  // }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'id': id,
      'title': title,
      'description': description,
      'totalDuration': totalDuration,
      'totalFileSize': totalFileSize,
      'totalTracks': totalTracks,
      'isMentalHealth': isMentalHealth,
      'isPremium': isPremium,
      'activeVerb': activeVerb,
      'isDefault': isDefault,
      'image': image,
      'svg': svg,
      'goal': goal,
      'price': price,
      'strength': strength,
      "group": group,
    };
    result.removeWhere((String key, dynamic value) => value == null);
    return result;
  }
}
