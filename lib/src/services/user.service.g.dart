// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userServiceInstanceHash() =>
    r'0bdbd62b7235a8942bceef79375e42f2df692428';

/// See also [userServiceInstance].
@ProviderFor(userServiceInstance)
final userServiceInstanceProvider = Provider<UserService>.internal(
  userServiceInstance,
  name: r'userServiceInstanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userServiceInstanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserServiceInstanceRef = ProviderRef<UserService>;
String _$userServiceHash() => r'98310ae21bf82c2fed99edbceab89ebe471a2b71';

/// See also [UserService].
@ProviderFor(UserService)
final userServiceProvider = AsyncNotifierProvider<UserService, User?>.internal(
  UserService.new,
  name: r'userServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserService = AsyncNotifier<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
