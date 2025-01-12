// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalImpl _$$GoalImplFromJson(Map<String, dynamic> json) => _$GoalImpl(
      id: json['id'] as String,
      uid: json['uid'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      objective: json['objective'] as String,
      goalType: $enumDecodeNullable(_$GoalTypeEnumMap, json['goalType']) ??
          GoalType.Specific,
      goalTopicId: json['goalTopicId'] as String,
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => GoalSuggestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      archivedAt: json['archivedAt'] == null
          ? null
          : DateTime.parse(json['archivedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$GoalImplToJson(_$GoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'name': instance.name,
      'category': instance.category,
      'objective': instance.objective,
      'goalType': _$GoalTypeEnumMap[instance.goalType]!,
      'goalTopicId': instance.goalTopicId,
      'suggestions': instance.suggestions,
      'isCompleted': instance.isCompleted,
      'isArchived': instance.isArchived,
      'completedAt': instance.completedAt?.toIso8601String(),
      'archivedAt': instance.archivedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$GoalTypeEnumMap = {
  GoalType.Specific: 'Specific',
  GoalType.Broad: 'Broad',
};

_$GoalSuggestionImpl _$$GoalSuggestionImplFromJson(Map<String, dynamic> json) =>
    _$GoalSuggestionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$$GoalSuggestionImplToJson(
        _$GoalSuggestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
    };
