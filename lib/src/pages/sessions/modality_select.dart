import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/ui/glass/glass_container.dart';

class ModalitySelect extends ConsumerWidget {
  final Function(session.TranceMethod method, int index) onSelectMethod;
  final session.TranceMethod? selectedMethod;
  final int? selectedIndex;
  final VoidCallback onBack;

  const ModalitySelect({
    super.key,
    required this.onSelectMethod,
    required this.selectedMethod,
    required this.selectedIndex,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final methods = session.TranceMethod.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: theme.colorScheme.shadow,
                  size: 20,
                ),
                onPressed: onBack,
              ),
              Text(
                'Select Modality',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.shadow,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 48), // Balance the back button
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: methods.length,
            itemBuilder: (context, index) {
              final method = methods[index];
              final isSelected = selectedMethod == method && selectedIndex == index;
              
              return GlassContainer(
                margin: const EdgeInsets.only(bottom: 12),
                borderRadius: BorderRadius.circular(12),
                backgroundColor: Colors.white12,
                child: ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.shadow.withOpacity(0.7),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        )
                      : null,
                  ),
                  title: Text(
                    _getMethodTitle(method),
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
                  onTap: () => onSelectMethod(method, index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getMethodTitle(session.TranceMethod method) {
    switch (method) {
      case session.TranceMethod.Hypnosis:
        return 'Hypnotherapy';
      case session.TranceMethod.Meditation:
        return 'Meditation';
      case session.TranceMethod.Breathe:
        return 'Breathwork';
      case session.TranceMethod.Active:
        return 'Active Hypnotherapy';
      case session.TranceMethod.Sleep:
        return 'Sleep Programming';
    }
  }
} 