// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Goal _$GoalFromJson(Map<String, dynamic> json) {
  return _Goal.fromJson(json);
}

/// @nodoc
mixin _$Goal {
  String get id => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get objective => throw _privateConstructorUsedError;
  GoalType get goalType => throw _privateConstructorUsedError;
  String get goalTopicId => throw _privateConstructorUsedError;
  List<GoalSuggestion> get suggestions => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get archivedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Goal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalCopyWith<Goal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalCopyWith<$Res> {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) then) =
      _$GoalCopyWithImpl<$Res, Goal>;
  @useResult
  $Res call(
      {String id,
      String uid,
      String name,
      String category,
      String objective,
      GoalType goalType,
      String goalTopicId,
      List<GoalSuggestion> suggestions,
      bool isCompleted,
      bool isArchived,
      DateTime? completedAt,
      DateTime? archivedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$GoalCopyWithImpl<$Res, $Val extends Goal>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uid = null,
    Object? name = null,
    Object? category = null,
    Object? objective = null,
    Object? goalType = null,
    Object? goalTopicId = null,
    Object? suggestions = null,
    Object? isCompleted = null,
    Object? isArchived = null,
    Object? completedAt = freezed,
    Object? archivedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      objective: null == objective
          ? _value.objective
          : objective // ignore: cast_nullable_to_non_nullable
              as String,
      goalType: null == goalType
          ? _value.goalType
          : goalType // ignore: cast_nullable_to_non_nullable
              as GoalType,
      goalTopicId: null == goalTopicId
          ? _value.goalTopicId
          : goalTopicId // ignore: cast_nullable_to_non_nullable
              as String,
      suggestions: null == suggestions
          ? _value.suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<GoalSuggestion>,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      archivedAt: freezed == archivedAt
          ? _value.archivedAt
          : archivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalImplCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$$GoalImplCopyWith(
          _$GoalImpl value, $Res Function(_$GoalImpl) then) =
      __$$GoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String uid,
      String name,
      String category,
      String objective,
      GoalType goalType,
      String goalTopicId,
      List<GoalSuggestion> suggestions,
      bool isCompleted,
      bool isArchived,
      DateTime? completedAt,
      DateTime? archivedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$GoalImplCopyWithImpl<$Res>
    extends _$GoalCopyWithImpl<$Res, _$GoalImpl>
    implements _$$GoalImplCopyWith<$Res> {
  __$$GoalImplCopyWithImpl(_$GoalImpl _value, $Res Function(_$GoalImpl) _then)
      : super(_value, _then);

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uid = null,
    Object? name = null,
    Object? category = null,
    Object? objective = null,
    Object? goalType = null,
    Object? goalTopicId = null,
    Object? suggestions = null,
    Object? isCompleted = null,
    Object? isArchived = null,
    Object? completedAt = freezed,
    Object? archivedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$GoalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      objective: null == objective
          ? _value.objective
          : objective // ignore: cast_nullable_to_non_nullable
              as String,
      goalType: null == goalType
          ? _value.goalType
          : goalType // ignore: cast_nullable_to_non_nullable
              as GoalType,
      goalTopicId: null == goalTopicId
          ? _value.goalTopicId
          : goalTopicId // ignore: cast_nullable_to_non_nullable
              as String,
      suggestions: null == suggestions
          ? _value._suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<GoalSuggestion>,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      archivedAt: freezed == archivedAt
          ? _value.archivedAt
          : archivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalImpl implements _Goal {
  const _$GoalImpl(
      {required this.id,
      required this.uid,
      required this.name,
      required this.category,
      required this.objective,
      this.goalType = GoalType.Specific,
      required this.goalTopicId,
      final List<GoalSuggestion> suggestions = const [],
      this.isCompleted = false,
      this.isArchived = false,
      this.completedAt,
      this.archivedAt,
      this.createdAt,
      this.updatedAt})
      : _suggestions = suggestions;

  factory _$GoalImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalImplFromJson(json);

  @override
  final String id;
  @override
  final String uid;
  @override
  final String name;
  @override
  final String category;
  @override
  final String objective;
  @override
  @JsonKey()
  final GoalType goalType;
  @override
  final String goalTopicId;
  final List<GoalSuggestion> _suggestions;
  @override
  @JsonKey()
  List<GoalSuggestion> get suggestions {
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestions);
  }

  @override
  @JsonKey()
  final bool isCompleted;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? archivedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Goal(id: $id, uid: $uid, name: $name, category: $category, objective: $objective, goalType: $goalType, goalTopicId: $goalTopicId, suggestions: $suggestions, isCompleted: $isCompleted, isArchived: $isArchived, completedAt: $completedAt, archivedAt: $archivedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.objective, objective) ||
                other.objective == objective) &&
            (identical(other.goalType, goalType) ||
                other.goalType == goalType) &&
            (identical(other.goalTopicId, goalTopicId) ||
                other.goalTopicId == goalTopicId) &&
            const DeepCollectionEquality()
                .equals(other._suggestions, _suggestions) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.archivedAt, archivedAt) ||
                other.archivedAt == archivedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      uid,
      name,
      category,
      objective,
      goalType,
      goalTopicId,
      const DeepCollectionEquality().hash(_suggestions),
      isCompleted,
      isArchived,
      completedAt,
      archivedAt,
      createdAt,
      updatedAt);

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      __$$GoalImplCopyWithImpl<_$GoalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalImplToJson(
      this,
    );
  }
}

abstract class _Goal implements Goal {
  const factory _Goal(
      {required final String id,
      required final String uid,
      required final String name,
      required final String category,
      required final String objective,
      final GoalType goalType,
      required final String goalTopicId,
      final List<GoalSuggestion> suggestions,
      final bool isCompleted,
      final bool isArchived,
      final DateTime? completedAt,
      final DateTime? archivedAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$GoalImpl;

  factory _Goal.fromJson(Map<String, dynamic> json) = _$GoalImpl.fromJson;

  @override
  String get id;
  @override
  String get uid;
  @override
  String get name;
  @override
  String get category;
  @override
  String get objective;
  @override
  GoalType get goalType;
  @override
  String get goalTopicId;
  @override
  List<GoalSuggestion> get suggestions;
  @override
  bool get isCompleted;
  @override
  bool get isArchived;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get archivedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GoalSuggestion _$GoalSuggestionFromJson(Map<String, dynamic> json) {
  return _GoalSuggestion.fromJson(json);
}

/// @nodoc
mixin _$GoalSuggestion {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;

  /// Serializes this GoalSuggestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GoalSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalSuggestionCopyWith<GoalSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalSuggestionCopyWith<$Res> {
  factory $GoalSuggestionCopyWith(
          GoalSuggestion value, $Res Function(GoalSuggestion) then) =
      _$GoalSuggestionCopyWithImpl<$Res, GoalSuggestion>;
  @useResult
  $Res call({String id, String name, int amount});
}

/// @nodoc
class _$GoalSuggestionCopyWithImpl<$Res, $Val extends GoalSuggestion>
    implements $GoalSuggestionCopyWith<$Res> {
  _$GoalSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoalSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalSuggestionImplCopyWith<$Res>
    implements $GoalSuggestionCopyWith<$Res> {
  factory _$$GoalSuggestionImplCopyWith(_$GoalSuggestionImpl value,
          $Res Function(_$GoalSuggestionImpl) then) =
      __$$GoalSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, int amount});
}

/// @nodoc
class __$$GoalSuggestionImplCopyWithImpl<$Res>
    extends _$GoalSuggestionCopyWithImpl<$Res, _$GoalSuggestionImpl>
    implements _$$GoalSuggestionImplCopyWith<$Res> {
  __$$GoalSuggestionImplCopyWithImpl(
      _$GoalSuggestionImpl _value, $Res Function(_$GoalSuggestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoalSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
  }) {
    return _then(_$GoalSuggestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalSuggestionImpl implements _GoalSuggestion {
  const _$GoalSuggestionImpl(
      {required this.id, required this.name, required this.amount});

  factory _$GoalSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalSuggestionImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int amount;

  @override
  String toString() {
    return 'GoalSuggestion(id: $id, name: $name, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalSuggestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, amount);

  /// Create a copy of GoalSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalSuggestionImplCopyWith<_$GoalSuggestionImpl> get copyWith =>
      __$$GoalSuggestionImplCopyWithImpl<_$GoalSuggestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalSuggestionImplToJson(
      this,
    );
  }
}

abstract class _GoalSuggestion implements GoalSuggestion {
  const factory _GoalSuggestion(
      {required final String id,
      required final String name,
      required final int amount}) = _$GoalSuggestionImpl;

  factory _GoalSuggestion.fromJson(Map<String, dynamic> json) =
      _$GoalSuggestionImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get amount;

  /// Create a copy of GoalSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalSuggestionImplCopyWith<_$GoalSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
