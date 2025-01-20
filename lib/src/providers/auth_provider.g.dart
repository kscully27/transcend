// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userSettingsHash() => r'a71e02a95ffc1417109cd1bd5e4d4365f19eafa7';

/// See also [userSettings].
@ProviderFor(userSettings)
final userSettingsProvider = StreamProvider<UserSettings?>.internal(
  userSettings,
  name: r'userSettingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserSettingsRef = StreamProviderRef<UserSettings?>;
String _$authServiceHash() => r'efb55d738a0cb0956053574ccdeb88e2387653f8';

/// See also [authService].
@ProviderFor(authService)
final authServiceProvider = Provider<AuthenticationService>.internal(
  authService,
  name: r'authServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthServiceRef = ProviderRef<AuthenticationService>;
String _$userHash() => r'85a3264209b9fbbe5c14ebc4277484e9f8782cac';

/// See also [User].
@ProviderFor(User)
final userProvider = AsyncNotifierProvider<User, user_model.User?>.internal(
  User.new,
  name: r'userProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$User = AsyncNotifier<user_model.User?>;
String _$userRefreshHash() => r'398baa73cdce5c19082f06c4abcc523e8e05328a';

/// See also [UserRefresh].
@ProviderFor(UserRefresh)
final userRefreshProvider =
    AutoDisposeNotifierProvider<UserRefresh, int>.internal(
  UserRefresh.new,
  name: r'userRefreshProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userRefreshHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserRefresh = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
