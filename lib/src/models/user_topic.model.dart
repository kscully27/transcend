import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_topic.model.freezed.dart';
part 'user_topic.model.g.dart';

@freezed
class UserTopic with _$UserTopic {
  const factory UserTopic({
    required String id,
    required String uid,
    required String topicId,
    @Default(false) bool isFavorite,
    DateTime? lastAccessed,
    @Default(0) int accessCount,
  }) = _UserTopic;

  factory UserTopic.fromJson(Map<String, dynamic> json) => _$UserTopicFromJson(json);
}
