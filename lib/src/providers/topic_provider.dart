import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/providers/auth_provider.dart';

part 'topic_provider.g.dart';

@riverpod
class TopicFavorites extends _$TopicFavorites {
  @override
  FutureOr<void> build() {
    // Initial state
  }

  Future<void> toggleFavorite(String topicId) async {
    state = const AsyncLoading();
    
    try {
      final user = ref.read(userProvider).value;
      if (user == null) {
        throw Exception('Must be logged in to favorite topics');
      }
      
      final firestoreService = locator<FirestoreService>();
      await firestoreService.toggleTopicFavorite(user.uid, topicId);
      
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
} 