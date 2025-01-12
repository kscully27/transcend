import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/user_topic.model.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/firestore.service.dart';

part 'user_topics_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<UserTopic>> userTopics(Ref ref) {
  final user = ref.watch(userProvider);
  final firestoreService = locator<FirestoreService>();
  
  return user.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      return firestoreService.watchUserTopics(user.uid);
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
} 