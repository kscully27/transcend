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
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: methods.length,
          itemBuilder: (context, index) {
            final method = methods[index];
            final isSelected = selectedMethod == method;
            
            return GlassContainer(
              margin: const EdgeInsets.only(bottom: 12),
              borderRadius: BorderRadius.circular(12),
              backgroundColor: Colors.white12,
              child: ListTile(
                title: Text(
                  _getMethodTitle(method),
                  style: TextStyle(
                    color: theme.colorScheme.shadow,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: isSelected 
                  ? Icon(
                      Icons.check,
                      color: theme.colorScheme.primary,
                      size: 24.0,
                    )
                  : null,
                onTap: () => onSelectMethod(method, index),
              ),
            );
          },
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