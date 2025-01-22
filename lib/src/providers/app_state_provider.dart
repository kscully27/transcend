import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/settings.model.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/models/user.model.dart' as user_model;
import 'package:trancend/src/models/user_topic.model.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/firestore.service.dart';

part 'app_state_provider.g.dart';

@Riverpod(keepAlive: true)
class AppState extends _$AppState {
  late final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  Stream<AppStateData> build() async* {
    debugPrint('🔍 AppState: build() called');
    final user = ref.read(userProvider).value;
    debugPrint('🔍 AppState: userProvider read');

    if (user == null) {
      debugPrint('🔍 AppState: user is null, loading topics only');
      try {
        final topics = await _firestoreService.getTopics();
        debugPrint('🔍 AppState: fetched topics for unauthenticated user');
        yield AppStateData(
          isInitialized: true,
          user: null,
          settings: null,
          userTopics: [],
          topics: AsyncValue.data(topics),
        );
      } catch (e, st) {
        debugPrint('🔍 AppState: error fetching topics for unauthenticated user: $e');
        yield AppStateData(
          isInitialized: true,
          user: null,
          settings: null,
          userTopics: [],
          topics: AsyncValue.error(e, st),
        );
      }
      return;
    }

    debugPrint('🔍 AppState: user is authenticated, fetching all data');
    try {
      final settings = await _firestoreService.getSettings(user.uid);
      debugPrint('🔍 AppState: fetched settings');
      try {
        debugPrint('🔍 AppState: fetching topics');
        final topics = await _firestoreService.getTopics();
        debugPrint('🔍 AppState: fetched topics');
        final userTopics = await _firestoreService.getUserTopics(user.uid);
        debugPrint('🔍 AppState: fetched user topics');
        yield AppStateData(
          isInitialized: true,
          user: user,
          settings: settings,
          userTopics: userTopics,
          topics: AsyncValue.data(topics),
        );
      } catch (e, st) {
        debugPrint('🔍 AppState: error fetching topics: $e');
        yield AppStateData(
          isInitialized: true,
          user: user,
          settings: settings,
          userTopics: [],
          topics: AsyncValue.error(e, st),
        );
      }
    } catch (e) {
      debugPrint('🔍 AppState: error fetching settings: $e');
      // Create default settings for new user
      final settings = UserSettings(
        uid: user.uid,
        statsStartDate: DateTime.now().millisecondsSinceEpoch,
        statsEndDate: DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
        delaySeconds: 3,
        maxHours: 1,
        useCellularData: false,
        usesDeepening: true,
        usesOwnDeepening: false,
      );
      debugPrint('🔍 AppState: created default settings');

      try {
        final topics = await _firestoreService.getTopics();
        debugPrint('🔍 AppState: fetched topics for new user');
        yield AppStateData(
          isInitialized: true,
          user: user,
          settings: settings,
          userTopics: [],
          topics: AsyncValue.data(topics),
        );
      } catch (e, st) {
        debugPrint('🔍 AppState: error fetching topics for new user: $e');
        yield AppStateData(
          isInitialized: true,
          user: user,
          settings: settings,
          userTopics: [],
          topics: AsyncValue.error(e, st),
        );
      }
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
