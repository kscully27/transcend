import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trancend/src/constants/app_colors.dart';

part 'topic.model.freezed.dart';
part 'topic.model.g.dart';

@freezed
class Topic with _$Topic {
  const Topic._();
  
  const factory Topic({
    required String id,
    required String title,
    required String description,
    required String icon,
    required String image,
    required String svg,
    required String group,
    required String goal,
    required String activeVerb,
    required double totalDuration,
    required int totalFileSize,
    required int totalTracks,
    @Default(false) bool isDefault,
    @Default(false) bool isPremium,
    @Default(false) bool isMentalHealth,
    @Default(false) bool isPriority,
    @Default(false) bool isLocked,
    @Default(0.0) double price,
    @Default(0.0) double strength,
  }) = _Topic;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  String get appColor => AppColors.getColorName(group);
  Color get flat => AppColors.flat(AppColors.getColorName(group));
  Color get light => AppColors.light(AppColors.getColorName(group));
  Color get dark => AppColors.dark(AppColors.getColorName(group));
}
