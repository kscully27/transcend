import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.model.freezed.dart';
part 'settings.model.g.dart';

@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    required String uid,
    required int statsStartDate,
    required int statsEndDate,
    required int delaySeconds,
    required int maxHours,
    required bool useCellularData,
    required bool usesDeepening,
    required bool usesOwnDeepening,
    @Default(0.8) double voiceVolume,
    @Default(0.2) double backgroundVolume,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);
}
