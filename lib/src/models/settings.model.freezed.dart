// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) {
  return _UserSettings.fromJson(json);
}

/// @nodoc
mixin _$UserSettings {
  String get uid => throw _privateConstructorUsedError;
  int get statsStartDate => throw _privateConstructorUsedError;
  int get statsEndDate => throw _privateConstructorUsedError;
  int get delaySeconds => throw _privateConstructorUsedError;
  int get maxHours => throw _privateConstructorUsedError;
  bool get useCellularData => throw _privateConstructorUsedError;
  bool get usesDeepening => throw _privateConstructorUsedError;
  bool get usesOwnDeepening => throw _privateConstructorUsedError;

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) then) =
      _$UserSettingsCopyWithImpl<$Res, UserSettings>;
  @useResult
  $Res call(
      {String uid,
      int statsStartDate,
      int statsEndDate,
      int delaySeconds,
      int maxHours,
      bool useCellularData,
      bool usesDeepening,
      bool usesOwnDeepening});
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res, $Val extends UserSettings>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? statsStartDate = null,
    Object? statsEndDate = null,
    Object? delaySeconds = null,
    Object? maxHours = null,
    Object? useCellularData = null,
    Object? usesDeepening = null,
    Object? usesOwnDeepening = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      statsStartDate: null == statsStartDate
          ? _value.statsStartDate
          : statsStartDate // ignore: cast_nullable_to_non_nullable
              as int,
      statsEndDate: null == statsEndDate
          ? _value.statsEndDate
          : statsEndDate // ignore: cast_nullable_to_non_nullable
              as int,
      delaySeconds: null == delaySeconds
          ? _value.delaySeconds
          : delaySeconds // ignore: cast_nullable_to_non_nullable
              as int,
      maxHours: null == maxHours
          ? _value.maxHours
          : maxHours // ignore: cast_nullable_to_non_nullable
              as int,
      useCellularData: null == useCellularData
          ? _value.useCellularData
          : useCellularData // ignore: cast_nullable_to_non_nullable
              as bool,
      usesDeepening: null == usesDeepening
          ? _value.usesDeepening
          : usesDeepening // ignore: cast_nullable_to_non_nullable
              as bool,
      usesOwnDeepening: null == usesOwnDeepening
          ? _value.usesOwnDeepening
          : usesOwnDeepening // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSettingsImplCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$UserSettingsImplCopyWith(
          _$UserSettingsImpl value, $Res Function(_$UserSettingsImpl) then) =
      __$$UserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      int statsStartDate,
      int statsEndDate,
      int delaySeconds,
      int maxHours,
      bool useCellularData,
      bool usesDeepening,
      bool usesOwnDeepening});
}

/// @nodoc
class __$$UserSettingsImplCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res, _$UserSettingsImpl>
    implements _$$UserSettingsImplCopyWith<$Res> {
  __$$UserSettingsImplCopyWithImpl(
      _$UserSettingsImpl _value, $Res Function(_$UserSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? statsStartDate = null,
    Object? statsEndDate = null,
    Object? delaySeconds = null,
    Object? maxHours = null,
    Object? useCellularData = null,
    Object? usesDeepening = null,
    Object? usesOwnDeepening = null,
  }) {
    return _then(_$UserSettingsImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      statsStartDate: null == statsStartDate
          ? _value.statsStartDate
          : statsStartDate // ignore: cast_nullable_to_non_nullable
              as int,
      statsEndDate: null == statsEndDate
          ? _value.statsEndDate
          : statsEndDate // ignore: cast_nullable_to_non_nullable
              as int,
      delaySeconds: null == delaySeconds
          ? _value.delaySeconds
          : delaySeconds // ignore: cast_nullable_to_non_nullable
              as int,
      maxHours: null == maxHours
          ? _value.maxHours
          : maxHours // ignore: cast_nullable_to_non_nullable
              as int,
      useCellularData: null == useCellularData
          ? _value.useCellularData
          : useCellularData // ignore: cast_nullable_to_non_nullable
              as bool,
      usesDeepening: null == usesDeepening
          ? _value.usesDeepening
          : usesDeepening // ignore: cast_nullable_to_non_nullable
              as bool,
      usesOwnDeepening: null == usesOwnDeepening
          ? _value.usesOwnDeepening
          : usesOwnDeepening // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSettingsImpl implements _UserSettings {
  const _$UserSettingsImpl(
      {required this.uid,
      required this.statsStartDate,
      required this.statsEndDate,
      required this.delaySeconds,
      required this.maxHours,
      required this.useCellularData,
      required this.usesDeepening,
      required this.usesOwnDeepening});

  factory _$UserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsImplFromJson(json);

  @override
  final String uid;
  @override
  final int statsStartDate;
  @override
  final int statsEndDate;
  @override
  final int delaySeconds;
  @override
  final int maxHours;
  @override
  final bool useCellularData;
  @override
  final bool usesDeepening;
  @override
  final bool usesOwnDeepening;

  @override
  String toString() {
    return 'UserSettings(uid: $uid, statsStartDate: $statsStartDate, statsEndDate: $statsEndDate, delaySeconds: $delaySeconds, maxHours: $maxHours, useCellularData: $useCellularData, usesDeepening: $usesDeepening, usesOwnDeepening: $usesOwnDeepening)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.statsStartDate, statsStartDate) ||
                other.statsStartDate == statsStartDate) &&
            (identical(other.statsEndDate, statsEndDate) ||
                other.statsEndDate == statsEndDate) &&
            (identical(other.delaySeconds, delaySeconds) ||
                other.delaySeconds == delaySeconds) &&
            (identical(other.maxHours, maxHours) ||
                other.maxHours == maxHours) &&
            (identical(other.useCellularData, useCellularData) ||
                other.useCellularData == useCellularData) &&
            (identical(other.usesDeepening, usesDeepening) ||
                other.usesDeepening == usesDeepening) &&
            (identical(other.usesOwnDeepening, usesOwnDeepening) ||
                other.usesOwnDeepening == usesOwnDeepening));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      statsStartDate,
      statsEndDate,
      delaySeconds,
      maxHours,
      useCellularData,
      usesDeepening,
      usesOwnDeepening);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      __$$UserSettingsImplCopyWithImpl<_$UserSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsImplToJson(
      this,
    );
  }
}

abstract class _UserSettings implements UserSettings {
  const factory _UserSettings(
      {required final String uid,
      required final int statsStartDate,
      required final int statsEndDate,
      required final int delaySeconds,
      required final int maxHours,
      required final bool useCellularData,
      required final bool usesDeepening,
      required final bool usesOwnDeepening}) = _$UserSettingsImpl;

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$UserSettingsImpl.fromJson;

  @override
  String get uid;
  @override
  int get statsStartDate;
  @override
  int get statsEndDate;
  @override
  int get delaySeconds;
  @override
  int get maxHours;
  @override
  bool get useCellularData;
  @override
  bool get usesDeepening;
  @override
  bool get usesOwnDeepening;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
