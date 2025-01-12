// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_topic.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserTopic _$UserTopicFromJson(Map<String, dynamic> json) {
  return _UserTopic.fromJson(json);
}

/// @nodoc
mixin _$UserTopic {
  String get id => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String get topicId => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  DateTime? get lastAccessed => throw _privateConstructorUsedError;
  int get accessCount => throw _privateConstructorUsedError;

  /// Serializes this UserTopic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserTopic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserTopicCopyWith<UserTopic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserTopicCopyWith<$Res> {
  factory $UserTopicCopyWith(UserTopic value, $Res Function(UserTopic) then) =
      _$UserTopicCopyWithImpl<$Res, UserTopic>;
  @useResult
  $Res call(
      {String id,
      String uid,
      String topicId,
      bool isFavorite,
      DateTime? lastAccessed,
      int accessCount});
}

/// @nodoc
class _$UserTopicCopyWithImpl<$Res, $Val extends UserTopic>
    implements $UserTopicCopyWith<$Res> {
  _$UserTopicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserTopic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uid = null,
    Object? topicId = null,
    Object? isFavorite = null,
    Object? lastAccessed = freezed,
    Object? accessCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      topicId: null == topicId
          ? _value.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      lastAccessed: freezed == lastAccessed
          ? _value.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      accessCount: null == accessCount
          ? _value.accessCount
          : accessCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserTopicImplCopyWith<$Res>
    implements $UserTopicCopyWith<$Res> {
  factory _$$UserTopicImplCopyWith(
          _$UserTopicImpl value, $Res Function(_$UserTopicImpl) then) =
      __$$UserTopicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String uid,
      String topicId,
      bool isFavorite,
      DateTime? lastAccessed,
      int accessCount});
}

/// @nodoc
class __$$UserTopicImplCopyWithImpl<$Res>
    extends _$UserTopicCopyWithImpl<$Res, _$UserTopicImpl>
    implements _$$UserTopicImplCopyWith<$Res> {
  __$$UserTopicImplCopyWithImpl(
      _$UserTopicImpl _value, $Res Function(_$UserTopicImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserTopic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uid = null,
    Object? topicId = null,
    Object? isFavorite = null,
    Object? lastAccessed = freezed,
    Object? accessCount = null,
  }) {
    return _then(_$UserTopicImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      topicId: null == topicId
          ? _value.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      lastAccessed: freezed == lastAccessed
          ? _value.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      accessCount: null == accessCount
          ? _value.accessCount
          : accessCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserTopicImpl implements _UserTopic {
  const _$UserTopicImpl(
      {required this.id,
      required this.uid,
      required this.topicId,
      this.isFavorite = false,
      this.lastAccessed,
      this.accessCount = 0});

  factory _$UserTopicImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserTopicImplFromJson(json);

  @override
  final String id;
  @override
  final String uid;
  @override
  final String topicId;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  final DateTime? lastAccessed;
  @override
  @JsonKey()
  final int accessCount;

  @override
  String toString() {
    return 'UserTopic(id: $id, uid: $uid, topicId: $topicId, isFavorite: $isFavorite, lastAccessed: $lastAccessed, accessCount: $accessCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserTopicImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.lastAccessed, lastAccessed) ||
                other.lastAccessed == lastAccessed) &&
            (identical(other.accessCount, accessCount) ||
                other.accessCount == accessCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, uid, topicId, isFavorite, lastAccessed, accessCount);

  /// Create a copy of UserTopic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserTopicImplCopyWith<_$UserTopicImpl> get copyWith =>
      __$$UserTopicImplCopyWithImpl<_$UserTopicImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserTopicImplToJson(
      this,
    );
  }
}

abstract class _UserTopic implements UserTopic {
  const factory _UserTopic(
      {required final String id,
      required final String uid,
      required final String topicId,
      final bool isFavorite,
      final DateTime? lastAccessed,
      final int accessCount}) = _$UserTopicImpl;

  factory _UserTopic.fromJson(Map<String, dynamic> json) =
      _$UserTopicImpl.fromJson;

  @override
  String get id;
  @override
  String get uid;
  @override
  String get topicId;
  @override
  bool get isFavorite;
  @override
  DateTime? get lastAccessed;
  @override
  int get accessCount;

  /// Create a copy of UserTopic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserTopicImplCopyWith<_$UserTopicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
