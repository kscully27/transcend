// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      uid: json['uid'] as String,
      statsStartDate: (json['statsStartDate'] as num).toInt(),
      statsEndDate: (json['statsEndDate'] as num).toInt(),
      delaySeconds: (json['delaySeconds'] as num).toInt(),
      maxHours: (json['maxHours'] as num).toInt(),
      useCellularData: json['useCellularData'] as bool,
      usesDeepening: json['usesDeepening'] as bool,
      usesOwnDeepening: json['usesOwnDeepening'] as bool,
      voiceVolume: (json['voiceVolume'] as num?)?.toDouble() ?? 0.8,
      backgroundVolume: (json['backgroundVolume'] as num?)?.toDouble() ?? 0.2,
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'statsStartDate': instance.statsStartDate,
      'statsEndDate': instance.statsEndDate,
      'delaySeconds': instance.delaySeconds,
      'maxHours': instance.maxHours,
      'useCellularData': instance.useCellularData,
      'usesDeepening': instance.usesDeepening,
      'usesOwnDeepening': instance.usesOwnDeepening,
      'voiceVolume': instance.voiceVolume,
      'backgroundVolume': instance.backgroundVolume,
    };
