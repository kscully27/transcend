// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Topic _$TopicFromJson(Map<String, dynamic> json) {
  return _Topic.fromJson(json);
}

/// @nodoc
mixin _$Topic {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  String get svg => throw _privateConstructorUsedError;
  String get group => throw _privateConstructorUsedError;
  String get goal => throw _privateConstructorUsedError;
  String get activeVerb => throw _privateConstructorUsedError;
  double get totalDuration => throw _privateConstructorUsedError;
  int get totalFileSize => throw _privateConstructorUsedError;
  int get totalTracks => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;
  bool get isMentalHealth => throw _privateConstructorUsedError;
  bool get isPriority => throw _privateConstructorUsedError;
  bool get isLocked => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get strength => throw _privateConstructorUsedError;

  /// Serializes this Topic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicCopyWith<Topic> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicCopyWith<$Res> {
  factory $TopicCopyWith(Topic value, $Res Function(Topic) then) =
      _$TopicCopyWithImpl<$Res, Topic>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String icon,
      String image,
      String svg,
      String group,
      String goal,
      String activeVerb,
      double totalDuration,
      int totalFileSize,
      int totalTracks,
      bool isDefault,
      bool isPremium,
      bool isMentalHealth,
      bool isPriority,
      bool isLocked,
      double price,
      double strength});
}

/// @nodoc
class _$TopicCopyWithImpl<$Res, $Val extends Topic>
    implements $TopicCopyWith<$Res> {
  _$TopicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? icon = null,
    Object? image = null,
    Object? svg = null,
    Object? group = null,
    Object? goal = null,
    Object? activeVerb = null,
    Object? totalDuration = null,
    Object? totalFileSize = null,
    Object? totalTracks = null,
    Object? isDefault = null,
    Object? isPremium = null,
    Object? isMentalHealth = null,
    Object? isPriority = null,
    Object? isLocked = null,
    Object? price = null,
    Object? strength = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      svg: null == svg
          ? _value.svg
          : svg // ignore: cast_nullable_to_non_nullable
              as String,
      group: null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String,
      activeVerb: null == activeVerb
          ? _value.activeVerb
          : activeVerb // ignore: cast_nullable_to_non_nullable
              as String,
      totalDuration: null == totalDuration
          ? _value.totalDuration
          : totalDuration // ignore: cast_nullable_to_non_nullable
              as double,
      totalFileSize: null == totalFileSize
          ? _value.totalFileSize
          : totalFileSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalTracks: null == totalTracks
          ? _value.totalTracks
          : totalTracks // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      isMentalHealth: null == isMentalHealth
          ? _value.isMentalHealth
          : isMentalHealth // ignore: cast_nullable_to_non_nullable
              as bool,
      isPriority: null == isPriority
          ? _value.isPriority
          : isPriority // ignore: cast_nullable_to_non_nullable
              as bool,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      strength: null == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopicImplCopyWith<$Res> implements $TopicCopyWith<$Res> {
  factory _$$TopicImplCopyWith(
          _$TopicImpl value, $Res Function(_$TopicImpl) then) =
      __$$TopicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String icon,
      String image,
      String svg,
      String group,
      String goal,
      String activeVerb,
      double totalDuration,
      int totalFileSize,
      int totalTracks,
      bool isDefault,
      bool isPremium,
      bool isMentalHealth,
      bool isPriority,
      bool isLocked,
      double price,
      double strength});
}

/// @nodoc
class __$$TopicImplCopyWithImpl<$Res>
    extends _$TopicCopyWithImpl<$Res, _$TopicImpl>
    implements _$$TopicImplCopyWith<$Res> {
  __$$TopicImplCopyWithImpl(
      _$TopicImpl _value, $Res Function(_$TopicImpl) _then)
      : super(_value, _then);

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? icon = null,
    Object? image = null,
    Object? svg = null,
    Object? group = null,
    Object? goal = null,
    Object? activeVerb = null,
    Object? totalDuration = null,
    Object? totalFileSize = null,
    Object? totalTracks = null,
    Object? isDefault = null,
    Object? isPremium = null,
    Object? isMentalHealth = null,
    Object? isPriority = null,
    Object? isLocked = null,
    Object? price = null,
    Object? strength = null,
  }) {
    return _then(_$TopicImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      svg: null == svg
          ? _value.svg
          : svg // ignore: cast_nullable_to_non_nullable
              as String,
      group: null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String,
      activeVerb: null == activeVerb
          ? _value.activeVerb
          : activeVerb // ignore: cast_nullable_to_non_nullable
              as String,
      totalDuration: null == totalDuration
          ? _value.totalDuration
          : totalDuration // ignore: cast_nullable_to_non_nullable
              as double,
      totalFileSize: null == totalFileSize
          ? _value.totalFileSize
          : totalFileSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalTracks: null == totalTracks
          ? _value.totalTracks
          : totalTracks // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      isMentalHealth: null == isMentalHealth
          ? _value.isMentalHealth
          : isMentalHealth // ignore: cast_nullable_to_non_nullable
              as bool,
      isPriority: null == isPriority
          ? _value.isPriority
          : isPriority // ignore: cast_nullable_to_non_nullable
              as bool,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      strength: null == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicImpl extends _Topic {
  const _$TopicImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.icon,
      required this.image,
      required this.svg,
      required this.group,
      required this.goal,
      required this.activeVerb,
      required this.totalDuration,
      required this.totalFileSize,
      required this.totalTracks,
      this.isDefault = false,
      this.isPremium = false,
      this.isMentalHealth = false,
      this.isPriority = false,
      this.isLocked = false,
      this.price = 0.0,
      this.strength = 0.0})
      : super._();

  factory _$TopicImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String icon;
  @override
  final String image;
  @override
  final String svg;
  @override
  final String group;
  @override
  final String goal;
  @override
  final String activeVerb;
  @override
  final double totalDuration;
  @override
  final int totalFileSize;
  @override
  final int totalTracks;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  @JsonKey()
  final bool isPremium;
  @override
  @JsonKey()
  final bool isMentalHealth;
  @override
  @JsonKey()
  final bool isPriority;
  @override
  @JsonKey()
  final bool isLocked;
  @override
  @JsonKey()
  final double price;
  @override
  @JsonKey()
  final double strength;

  @override
  String toString() {
    return 'Topic(id: $id, title: $title, description: $description, icon: $icon, image: $image, svg: $svg, group: $group, goal: $goal, activeVerb: $activeVerb, totalDuration: $totalDuration, totalFileSize: $totalFileSize, totalTracks: $totalTracks, isDefault: $isDefault, isPremium: $isPremium, isMentalHealth: $isMentalHealth, isPriority: $isPriority, isLocked: $isLocked, price: $price, strength: $strength)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.svg, svg) || other.svg == svg) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.activeVerb, activeVerb) ||
                other.activeVerb == activeVerb) &&
            (identical(other.totalDuration, totalDuration) ||
                other.totalDuration == totalDuration) &&
            (identical(other.totalFileSize, totalFileSize) ||
                other.totalFileSize == totalFileSize) &&
            (identical(other.totalTracks, totalTracks) ||
                other.totalTracks == totalTracks) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.isMentalHealth, isMentalHealth) ||
                other.isMentalHealth == isMentalHealth) &&
            (identical(other.isPriority, isPriority) ||
                other.isPriority == isPriority) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.strength, strength) ||
                other.strength == strength));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        description,
        icon,
        image,
        svg,
        group,
        goal,
        activeVerb,
        totalDuration,
        totalFileSize,
        totalTracks,
        isDefault,
        isPremium,
        isMentalHealth,
        isPriority,
        isLocked,
        price,
        strength
      ]);

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicImplCopyWith<_$TopicImpl> get copyWith =>
      __$$TopicImplCopyWithImpl<_$TopicImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicImplToJson(
      this,
    );
  }
}

abstract class _Topic extends Topic {
  const factory _Topic(
      {required final String id,
      required final String title,
      required final String description,
      required final String icon,
      required final String image,
      required final String svg,
      required final String group,
      required final String goal,
      required final String activeVerb,
      required final double totalDuration,
      required final int totalFileSize,
      required final int totalTracks,
      final bool isDefault,
      final bool isPremium,
      final bool isMentalHealth,
      final bool isPriority,
      final bool isLocked,
      final double price,
      final double strength}) = _$TopicImpl;
  const _Topic._() : super._();

  factory _Topic.fromJson(Map<String, dynamic> json) = _$TopicImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get icon;
  @override
  String get image;
  @override
  String get svg;
  @override
  String get group;
  @override
  String get goal;
  @override
  String get activeVerb;
  @override
  double get totalDuration;
  @override
  int get totalFileSize;
  @override
  int get totalTracks;
  @override
  bool get isDefault;
  @override
  bool get isPremium;
  @override
  bool get isMentalHealth;
  @override
  bool get isPriority;
  @override
  bool get isLocked;
  @override
  double get price;
  @override
  double get strength;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicImplCopyWith<_$TopicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
