import 'package:flutter/material.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

class PreviousIntentionsSheet extends StatelessWidget {
  final Function(String intention) onIntentionSelected;

  const PreviousIntentionsSheet({
    super.key,
    required this.onIntentionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // TODO: Replace with actual previous intentions from storage
    final previousIntentions = [
      "I want to feel more confident in social situations",
      "I want to sleep more deeply and wake up refreshed",
      "I want to develop a positive mindset",
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceTint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
                Text(
                  'Previous Intentions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 64), // Balance the cancel button
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: previousIntentions.length,
              itemBuilder: (context, index) {
                final intention = previousIntentions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
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
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: theme.colorScheme.shadow.withOpacity(0.7),
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        onIntentionSelected(intention);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 