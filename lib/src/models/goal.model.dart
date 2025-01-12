import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.model.freezed.dart';
part 'goal.model.g.dart';

enum GoalType { Specific, Broad }

@freezed
class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String uid,
    required String name,
    required String category,
    required String objective,
    @Default(GoalType.Specific) GoalType goalType,
    required String goalTopicId,
    @Default([]) List<GoalSuggestion> suggestions,
    @Default(false) bool isCompleted,
    @Default(false) bool isArchived,
    DateTime? completedAt,
    DateTime? archivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}

@freezed
class GoalSuggestion with _$GoalSuggestion {
  const factory GoalSuggestion({
    required String id,
    required String name,
    required int amount,
  }) = _GoalSuggestion;

  factory GoalSuggestion.fromJson(Map<String, dynamic> json) => _$GoalSuggestionFromJson(json);
}
