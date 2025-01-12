// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TopicImpl _$$TopicImplFromJson(Map<String, dynamic> json) => _$TopicImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      image: json['image'] as String,
      svg: json['svg'] as String,
      group: json['group'] as String,
      goal: json['goal'] as String,
      activeVerb: json['activeVerb'] as String,
      totalDuration: (json['totalDuration'] as num).toDouble(),
      totalFileSize: (json['totalFileSize'] as num).toInt(),
      totalTracks: (json['totalTracks'] as num).toInt(),
      isDefault: json['isDefault'] as bool? ?? false,
      isPremium: json['isPremium'] as bool? ?? false,
      isMentalHealth: json['isMentalHealth'] as bool? ?? false,
      isPriority: json['isPriority'] as bool? ?? false,
      isLocked: json['isLocked'] as bool? ?? false,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      strength: (json['strength'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$TopicImplToJson(_$TopicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'image': instance.image,
      'svg': instance.svg,
      'group': instance.group,
      'goal': instance.goal,
      'activeVerb': instance.activeVerb,
      'totalDuration': instance.totalDuration,
      'totalFileSize': instance.totalFileSize,
      'totalTracks': instance.totalTracks,
      'isDefault': instance.isDefault,
      'isPremium': instance.isPremium,
      'isMentalHealth': instance.isMentalHealth,
      'isPriority': instance.isPriority,
      'isLocked': instance.isLocked,
      'price': instance.price,
      'strength': instance.strength,
    };
