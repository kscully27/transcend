// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

// import 'package:apple_sign_in_safety/apple_sign_in_safety.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/goal.model.dart';
import 'package:trancend/src/models/settings.model.dart';
import 'package:trancend/src/models/user.model.dart' as user_model;
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/services/user.service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'firestore_service.dart';

enum DataType { Document, Collection }

class AuthResult {
  final bool success;
  final bool error;
  final String errorMessage;
  AuthResult(
      {required this.success, required this.error, required this.errorMessage});
}

abstract class AuthenticationService {
  String get uid;
  Stream<user_model.User> get onAuthStateChanged;
  Future<user_model.User> get getUser;
  Future<user_model.User> get getUserWithoutSignout;
  Stream<auth.User> get user;
  user_model.User get currentUser;
  Goal get defaultGoal;
  UserSettings get userSettings;
  set defaultGoal(Goal data);
  set userSettings(UserSettings data);
  set currentUser(user_model.User data);
  Future<bool> isUserLoggedIn();
  Future<AuthResult> appleLogin({
    user_model.User user,
  });
  Future<AuthResult> facebookLogin({
    user_model.User user,
  });
  Future<AuthResult> googleSignIn({
    user_model.User? user,
  });
  Future forgotPassword(String email);
  Future<void> signOut();
  Future<AuthResult> loginWithEmail({
    required String email,
    required String password,
  });
  Future<void> sendSignInLinkToEmail(email, {isPremium = false});
  Future<AuthResult> signInWithEmailAndLink(
      {required String email, required String emailLink});
  Future<AuthResult> signUpWithEmail({
    required user_model.User user,
    required String password,
  });
  // Future getUserProperties;
}

class AuthenticationServiceAdapter implements AuthenticationService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = Get.put(UserService());

  user_model.User? _currentUser;
  Goal? _defaultGoal;
  UserSettings? _userSettings;

  Future<user_model.User?> _populateCurrentUser(auth.User user,
      {required user_model.SigninMethod signinMethod}) async {
    try {
      // Get the user from firebase
      _currentUser = await _firestoreService.getUser(user.uid);
      print('_currentUser.value ${_currentUser}');

      if (_currentUser != null) {
        if (_currentUser?.uid != null) _getSettings(_currentUser!);
        if (_currentUser?.primaryGoalId != null) {
          _getDefaultGoal(_currentUser!.primaryGoalId);
        }
      }
      return _currentUser;
    } catch (e) {
      print("error populating user --> $e");
      throw e;
    }
  }

  Future<UserSettings> _getSettings(user_model.User user) async {
    try {
      if (user != null && user.uid != null) {
        // Get the settings from firebase
        _userSettings = await _firestoreService.getSettings(user.uid);
        if (_userSettings == null) {
          UserSettings __userSettings = UserSettings.fromMap({"uid": user.uid});
          _userSettings =
              await _firestoreService.createSettings(__userSettings);
        }
      }
      return _userSettings!;
    } catch (e) {
      print("error populating settings --> $e");
      throw e;
    }
  }

  Future<Goal> _getDefaultGoal(String id) async {
    try {
      // Get the user from firebase
      _defaultGoal = await _firestoreService.getGoal(id);
      return _defaultGoal!;
    } catch (e) {
      print("error populating goal --> $e");
      throw e;
    }
  }

  @override
  String get uid => _firebaseAuth.currentUser?.uid ?? '';

  @override
  Stream<user_model.User> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map((user) {
        if (user == null) throw Exception('No authenticated user!');
        return _currentUser ?? user_model.User(uid: user.uid);
      });

  @override
  Future<user_model.User> get getUser async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No authenticated user!');

      final userData = await _firestoreService.getUser(user.uid);
      _userService.setUser(userData);
      return userData;
    } catch (e) {
      await signOut();
      throw Exception('Error getting user: $e');
    }
  }

  @override
  Future<AuthResult> googleSignIn({user_model.User? user}) async {
    try {
      _userService.setLoading(true);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return AuthResult(
          success: false,
          error: true,
          errorMessage: 'Google sign in was cancelled by user',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase user is null after Google sign in');
      }

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final newUser = user_model.User(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
          photoUrl: firebaseUser.photoURL ?? '',
        );

        await _firestoreService.createUser(newUser);
        _userService.setUser(newUser);
      } else {
        final existingUser = await _firestoreService.getUser(firebaseUser.uid);
        _userService.setUser(existingUser);
      }

      return AuthResult(
        success: true,
        error: false,
        errorMessage: '',
      );
    } catch (e) {
      print('Error during Google sign in: $e');
      return AuthResult(
        success: false,
        error: true,
        errorMessage: e.toString(),
      );
    } finally {
      _userService.setLoading(false);
    }
  }

  @override
  user_model.User get currentUser =>
      _userService.currentUser ?? (throw Exception('No current user set'));

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _userService.clearUser();
  }

  // Implement other required methods...
  @override
  Future<user_model.User> get getUserWithoutSignout async {
    var user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user!');
    }
    return (await _populateCurrentUser(user,
        signinMethod: user_model.SigninMethod.None))!;
  }

  @override
  Stream<auth.User> get user => throw UnimplementedError();

  @override
  Goal get defaultGoal =>
      _defaultGoal ?? (throw Exception('Default goal is not set'));

  @override
  UserSettings get userSettings =>
      _userSettings ?? (throw Exception('User settings not set'));

  @override
  set defaultGoal(Goal data) => throw UnimplementedError();

  @override
  set userSettings(UserSettings data) {
    _userSettings = data;
  }

  @override
  set currentUser(user_model.User data) => throw UnimplementedError();

  @override
  Future<bool> isUserLoggedIn() => throw UnimplementedError();

  @override
  Future<AuthResult> appleLogin({user_model.User? user}) async {
    try {
      _userService.setLoading(true);

      // Trigger the Apple sign-in flow
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuthCredential from the credential
      final oauthCredential = auth.OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      // Sign in to Firebase with the Apple OAuth credential
      final userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase user is null after Apple sign in');
      }

      // Handle new user creation
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        // Combine given name and family name if available
        String? displayName;
        if (credential.givenName != null || credential.familyName != null) {
          displayName =
              '${credential.givenName ?? ''} ${credential.familyName ?? ''}'
                  .trim();
        }

        final newUser = user_model.User(
          uid: firebaseUser.uid,
          email: credential.email ?? firebaseUser.email ?? '',
          displayName: displayName ?? '',
          photoUrl: firebaseUser.photoURL ?? '',
        );

        await _firestoreService.createUser(newUser);
        _userService.setUser(newUser);
      } else {
        final existingUser = await _firestoreService.getUser(firebaseUser.uid);
        _userService.setUser(existingUser);
      }

      return AuthResult(
        success: true,
        error: false,
        errorMessage: '',
      );
    } catch (e) {
      print('Error during Apple sign in: $e');
      return AuthResult(
        success: false,
        error: true,
        errorMessage: e.toString(),
      );
    } finally {
      _userService.setLoading(false);
    }
  }

  @override
  Future<AuthResult> facebookLogin({user_model.User? user}) async {
    try {
      _userService.setLoading(true);

      // Trigger the Facebook sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status != LoginStatus.success) {
        throw Exception('Facebook login failed: ${loginResult.message}');
      }

      // Get the access token
      final AccessToken? accessToken = loginResult.accessToken;
      if (accessToken == null) {
        throw Exception('Facebook access token is null');
      }

      // Create a Facebook credential for Firebase
      final auth.OAuthCredential credential =
          auth.FacebookAuthProvider.credential(
        accessToken.token,
      );

      // Sign in to Firebase with the Facebook credential
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase user is null after Facebook sign in');
      }

      // Get additional user data from Facebook
      final userData = await FacebookAuth.instance.getUserData();

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final newUser = user_model.User(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? userData['email'] ?? '',
          displayName: firebaseUser.displayName ?? userData['name'] ?? '',
          photoUrl:
              firebaseUser.photoURL ?? userData['picture']['data']['url'] ?? '',
        );

        await _firestoreService.createUser(newUser);
        _userService.setUser(newUser);
      } else {
        final existingUser = await _firestoreService.getUser(firebaseUser.uid);
        _userService.setUser(existingUser);
      }

      return AuthResult(
        success: true,
        error: false,
        errorMessage: '',
      );
    } catch (e) {
      print('Error during Facebook sign in: $e');
      return AuthResult(
        success: false,
        error: true,
        errorMessage: e.toString(),
      );
    } finally {
      _userService.setLoading(false);
    }
  }

  @override
  Future forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<AuthResult> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _userService.setLoading(true);

      if (email == null || email.isEmpty) {
        throw Exception('Email is required');
      }
      if (password == null || password.isEmpty) {
        throw Exception('Password is required');
      }

      // Sign in with email and password
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Firebase user is null after email sign in');
      }

      // Get the user from Firestore
      final existingUser = await _firestoreService.getUser(firebaseUser.uid);
      _userService.setUser(existingUser);

      return AuthResult(
        success: true,
        error: false,
        errorMessage: '',
      );
    } on auth.FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        default:
          errorMessage = 'An error occurred during sign in: ${e.message}';
      }
      return AuthResult(
        success: false,
        error: true,
        errorMessage: errorMessage,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        error: true,
        errorMessage: e.toString(),
      );
    } finally {
      _userService.setLoading(false);
    }
  }

  @override
  Future<void> sendSignInLinkToEmail(email, {isPremium = false}) =>
      throw UnimplementedError();

  @override
  Future<AuthResult> signInWithEmailAndLink(
          {required String email, required String emailLink}) =>
      throw UnimplementedError();

  @override
  Future<AuthResult> signUpWithEmail(
          {required user_model.User user, required String password}) =>
      throw UnimplementedError();
}
