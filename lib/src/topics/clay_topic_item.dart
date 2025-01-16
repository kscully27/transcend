import 'package:flutter/material.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/ui/clay/clay_container.dart';
import 'package:trancend/src/ui/clay/clay_text.dart';

class ClayTopicItem extends StatelessWidget {
  final Topic topic;
  final VoidCallback? onTap;

  const ClayTopicItem({
    super.key,
    required this.topic,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: ClayContainer(
          color: theme.colorScheme.surface,
          parentColor: theme.colorScheme.surface,
          depth: 20,
          spread: 2,
          curveType: CurveType.convex,
          borderRadius: 12,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClayText(
                  topic.title,
                  color: theme.colorScheme.surface,
                  parentColor: theme.colorScheme.surface,
                  emboss: false,
                  size: 18,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  topic.description,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 