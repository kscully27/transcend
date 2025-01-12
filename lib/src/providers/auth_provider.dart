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
Stream<user_model.User?> user(Ref ref) {
  final firestoreService = locator<FirestoreService>();
  return auth.FirebaseAuth.instance.authStateChanges().asyncMap((firebaseUser) async {
    if (firebaseUser == null) return null;
    try {
      return await firestoreService.getUser(firebaseUser.uid);
    } catch (e) {
      print("🚀 ~ returnauth.FirebaseAuth.instance.authStateChanges ~ e: $e");
      return user_model.User(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? 'Anonymous User',
        photoUrl: firebaseUser.photoURL ?? '',
        isAnonymous: firebaseUser.isAnonymous,
      );
    }
  });
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