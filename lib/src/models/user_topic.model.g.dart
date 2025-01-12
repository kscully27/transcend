// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_topic.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserTopicImpl _$$UserTopicImplFromJson(Map<String, dynamic> json) =>
    _$UserTopicImpl(
      id: json['id'] as String,
      uid: json['uid'] as String,
      topicId: json['topicId'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      lastAccessed: json['lastAccessed'] == null
          ? null
          : DateTime.parse(json['lastAccessed'] as String),
      accessCount: (json['accessCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserTopicImplToJson(_$UserTopicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'topicId': instance.topicId,
      'isFavorite': instance.isFavorite,
      'lastAccessed': instance.lastAccessed?.toIso8601String(),
      'accessCount': instance.accessCount,
    };
