import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/settings.model.dart';
import 'package:trancend/src/models/user.model.dart' as user_model;
import 'package:trancend/src/services/authentication.service.dart';
import 'package:trancend/src/services/firestore.service.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class User extends AsyncNotifier<user_model.User?> {
  @override
  Future<user_model.User?> build() async {
    final firestoreService = locator<FirestoreService>();
    final firebaseUser = auth.FirebaseAuth.instance.currentUser;
    
    if (firebaseUser == null) return null;
    
    try {
      return await firestoreService.getUser(firebaseUser.uid);
    } catch (e) {
      print("🚀 ~ error getting user: $e");
      return user_model.User(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? 'Anonymous User',
        photoUrl: firebaseUser.photoURL ?? '',
        isAnonymous: firebaseUser.isAnonymous,
      );
    }
  }

  Future<void> updateBackgroundSound(user_model.BackgroundSound sound) async {
    final user = state.value;
    if (user == null) return;

    final firestoreService = locator<FirestoreService>();
    await firestoreService.updateUserFromData(user.uid, {
      'backgroundSound': sound.toString().split('.').last
    });
    
    // Refresh user data after saving
    state = await AsyncValue.guard(() => build());
  }
}

@Riverpod(keepAlive: true)
Stream<UserSettings?> userSettings(Ref ref) {
  final user = ref.watch(userProvider);
  final firestoreService = locator<FirestoreService>();
  
  return user.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return firestoreService.watchSettings(user.uid);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
}

@Riverpod(keepAlive: true)
AuthenticationService authService(Ref ref) {
  return AuthenticationServiceAdapter(ref);
}

final backgroundSoundProvider = StateNotifierProvider<BackgroundSoundNotifier, user_model.BackgroundSound>((ref) {
  final user = ref.read(userProvider).value;
  return BackgroundSoundNotifier(user?.backgroundSound ?? user_model.BackgroundSound.Waves);
});

class BackgroundSoundNotifier extends StateNotifier<user_model.BackgroundSound> {
  BackgroundSoundNotifier(user_model.BackgroundSound initialState) : super(initialState);

  Future<void> updateSound(user_model.BackgroundSound sound) async {
    state = sound;
  }
}

@riverpod
class UserRefresh extends _$UserRefresh {
  @override
  int build() => 0;

  void refresh() => state++;
} 