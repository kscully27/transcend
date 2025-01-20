import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/settings.model.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/models/user.model.dart' as user_model;
import 'package:trancend/src/models/user_topic.model.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/authentication.service.dart';
import 'package:trancend/src/services/firestore.service.dart';

part 'app_state_provider.g.dart';

@Riverpod(keepAlive: true)
class AppState extends _$AppState {
  late final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  Stream<AppStateData> build() async* {
    final authService = locator<AuthenticationService>();
    final user = ref.watch(userProvider);
    if (user.value == null) {
      await authService.signinAnonymously();
      yield AppStateData(
        isInitialized: true,
        user: null,
        settings: null,
        userTopics: [],
        topics: const AsyncValue.loading(),
      );
      return;
    }

    try {
      final settings = await _firestoreService.getSettings(user.value!.uid);
      try {
        final topics = await _firestoreService.getTopics();
        final userTopics = await _firestoreService.getUserTopics(user.value!.uid);
        yield AppStateData(
          isInitialized: true,
          user: user.value,
          settings: settings,
          userTopics: userTopics,
          topics: AsyncValue.data(topics),
        );
      } catch (e, st) {
        yield AppStateData(
          isInitialized: true,
          user: user.value,
          settings: settings,
          userTopics: [],
          topics: AsyncValue.error(e, st),
        );
      }
    } catch (e) {
      // If user doesn't exist in Firestore yet, create them
      final newUser = user_model.User(
        uid: user.value!.uid,
        email: user.value!.email,
        displayName: user.value!.displayName,
        photoUrl: user.value!.photoUrl,
        isAnonymous: true,
      );
      await _firestoreService.createUser(newUser);

      // Get the initial state after creating user
      final settings = await _firestoreService.getSettings(user.value!.uid);
      final topics = await _firestoreService.getTopics();
      final userTopics = await _firestoreService.getUserTopics(user.value!.uid);
      
      yield AppStateData(
        isInitialized: true,
        user: newUser,
        settings: settings,
        userTopics: userTopics,
        topics: AsyncValue.data(topics),
      );
    }
  }

  Future<void> updateSettings(UserSettings settings) async {
    state.whenData((data) async {
      if (data.user != null) {
        await _firestoreService.updateSettings(data.user!.uid, settings);
      }
    });
  }

  Future<void> updateUserTopic(UserTopic userTopic) async {
    state.whenData((data) async {
      if (data.user != null) {
        await _firestoreService.updateUserTopic(data.user!.uid, userTopic);
      }
    });
  }
}

class AppStateData {
  final bool isInitialized;
  final user_model.User? user;
  final UserSettings? settings;
  final List<UserTopic> userTopics;
  final AsyncValue<List<Topic>> topics;

  const AppStateData({
    required this.isInitialized,
    required this.user,
    required this.settings,
    required this.userTopics,
    required this.topics,
  });

  AppStateData copyWith({
    bool? isInitialized,
    user_model.User? user,
    UserSettings? settings,
    List<UserTopic>? userTopics,
    AsyncValue<List<Topic>>? topics,
  }) {
    return AppStateData(
      isInitialized: isInitialized ?? this.isInitialized,
      user: user ?? this.user,
      settings: settings ?? this.settings,
      userTopics: userTopics ?? this.userTopics,
      topics: topics ?? this.topics,
    );
  }
}
