import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

class PreviousIntentions extends ConsumerWidget {
  final VoidCallback onBack;
  final Function(String intention) onIntentionSelected;

  const PreviousIntentions({
    super.key,
    required this.onBack,
    required this.onIntentionSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final intentionState = ref.watch(intentionSelectionProvider);
    final placeholders = [
      "I want to feel more confident in social situations",
      "I want to sleep more deeply and wake up refreshed",
      "I want to develop a positive mindset",
      "I want to overcome my fear of public speaking",
      "I want to increase my focus and productivity",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: placeholders.length,
          itemBuilder: (context, index) {
            final intention = placeholders[index];
            final isSelected = intentionState.type == IntentionSelectionType.previous && 
                              intentionState.customIntention == intention;
            
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
                  trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: theme.colorScheme.primary,
                        size: 22.0,
                      )
                    : Icon(
                        Icons.arrow_forward_ios,
                        color: theme.colorScheme.shadow.withOpacity(0.7),
                        size: 20,
                      ),
                  onTap: () async {
                    // Update the provider
                    ref.read(intentionSelectionProvider.notifier).setCustomIntention(intention);
                    ref.read(intentionSelectionProvider.notifier).setSelection(IntentionSelectionType.previous);
                    
                    // Close the modal
                    Navigator.of(context).pop();
                    
                    // Add a 300ms delay to wait for the animation to complete
                    await Future.delayed(const Duration(milliseconds: 300));
                    
                    // Then navigate to the next screen
                    if (context.mounted) { // Check if still mounted after the delay
                      onIntentionSelected(intention);
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
} 