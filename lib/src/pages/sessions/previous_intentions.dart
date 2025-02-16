import 'package:flutter/material.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

class PreviousIntentions extends StatelessWidget {
  final VoidCallback onBack;
  final Function(String intention) onIntentionSelected;

  const PreviousIntentions({
    super.key,
    required this.onBack,
    required this.onIntentionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final placeholders = [
      "I want to feel more confident in social situations",
      "I want to sleep more deeply and wake up refreshed",
      "I want to develop a positive mindset",
      "I want to overcome my fear of public speaking",
      "I want to increase my focus and productivity",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Positioned(
              left: 4,
              top: 8,
              bottom: 8,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: theme.colorScheme.shadow.withOpacity(0.7),
                  size: 20,
                ),
                onPressed: onBack,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48.0,
                  vertical: 16.0,
                ),
                child: Text(
                  'Previous Intentions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.shadow,
                    fontWeight: FontWeight.w600,
                    fontSize: 20
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: placeholders.length,
            itemBuilder: (context, index) {
              final intention = placeholders[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == placeholders.length - 1 ? 48 : 12,
                ),
                child: GlassContainer(
                  borderRadius: BorderRadius.circular(12),
                  backgroundColor: Colors.white12,
                  child: ListTile(
                    title: Text(
                      intention,
                      style: TextStyle(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: theme.colorScheme.shadow.withOpacity(0.7),
                      size: 20,
                    ),
                    onTap: () => onIntentionSelected(intention),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 