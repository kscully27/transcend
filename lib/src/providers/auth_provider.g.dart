// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userSettingsHash() => r'c80ba99c09fadb231088ccb9b5012cc244981856';

/// See also [userSettings].
@ProviderFor(userSettings)
final userSettingsProvider = AutoDisposeStreamProvider<UserSettings?>.internal(
  userSettings,
  name: r'userSettingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserSettingsRef = AutoDisposeStreamProviderRef<UserSettings?>;
String _$authServiceHash() => r'25fcd76d52a85be6664ae55a188e70eab4d9938e';

/// See also [authService].
@ProviderFor(authService)
final authServiceProvider = AutoDisposeProvider<AuthenticationService>.internal(
  authService,
  name: r'authServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthServiceRef = AutoDisposeProviderRef<AuthenticationService>;
String _$currentUserHash() => r'3fbd5061ed562f674660a506b073a2cc44980796';

/// See also [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeStreamProvider<user_model.User>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeStreamProviderRef<user_model.User>;
String _$userHash() => r'd70dc146a7904ca10b54ab0c0df2ba141b07faa3';

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
String _$backgroundSoundHash() => r'b81162b450c7d6e1a8299d139c4158fcd81cc8b2';

/// See also [BackgroundSound].
@ProviderFor(BackgroundSound)
final backgroundSoundProvider = AutoDisposeNotifierProvider<BackgroundSound,
    user_model.BackgroundSound>.internal(
  BackgroundSound.new,
  name: r'backgroundSoundProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backgroundSoundHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BackgroundSound = AutoDisposeNotifier<user_model.BackgroundSound>;
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
