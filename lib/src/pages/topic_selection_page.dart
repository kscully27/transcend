import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/providers/topics_provider.dart';
import 'package:trancend/src/trance/trance_player.dart';
import 'package:trancend/src/topics/candy_topic_item.dart';

class TopicSelectionPage extends ConsumerWidget {
  final session.TranceMethod tranceMethod;
  final String? intention;

  const TopicSelectionPage({
    super.key,
    required this.tranceMethod,
    this.intention,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final topicsAsync = ref.watch(topicsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select a Topic for ${tranceMethod.name}',
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: topicsAsync.when(
        data: (topics) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            return CandyTopicItem(
              topic: topic,
              isFavorite: false, // We could add favorite functionality later
              onFavoritePressed: () {}, // We could add favorite functionality later
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrancePlayer(
                      topic: topic,
                      tranceMethod: tranceMethod,
                    ),
                  ),
                );
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading topics: $error'),
        ),
      ),
    );
  }
} 