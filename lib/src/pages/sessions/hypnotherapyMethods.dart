import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/models/user.model.dart' as user_model;
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/ui/glass/glass_radio_button.dart';

final hypnotherapyMethodProvider =
    StateProvider<user_model.HypnotherapyMethod?>((ref) => null);

class HypnosisMethods extends ConsumerStatefulWidget {
  final Function() onBack;
  const HypnosisMethods({
    super.key,
    required this.onBack,
  });

  @override
  ConsumerState<HypnosisMethods> createState() =>
      _HypnosisMethods(onBack: onBack);
}

class _HypnosisMethods extends ConsumerState<HypnosisMethods> {
  final Function() onBack;

  _HypnosisMethods({
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(userProvider);
    
    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox();

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: user_model.HypnotherapyMethod.values.length,
                  itemBuilder: (context, index) {
                    final hypnosisMethod =
                        user_model.HypnotherapyMethod.values[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: GlassRadioButton<user_model.HypnotherapyMethod>(
                        value: hypnosisMethod,
                        groupValue: user.hypnotherapyMethod ?? user_model.HypnotherapyMethod.values.first,
                        onChanged: (value) async {
                          if (value == null) return;

                          try {
                            // First update the local state provider
                            ref.read(hypnotherapyMethodProvider.notifier).state = value;
                            
                            // Then update Firestore
                            await ref
                                .read(userProvider.notifier)
                                .updateHypnotherapyMethod(value);
                            
                            // Navigate back
                            widget.onBack();
                          } catch (e) {
                            print("error updating hypnotherapy method: $e");
                          }
                        },
                        title: hypnosisMethod.name,
                        titleStyle: TextStyle(
                          color: theme.colorScheme.shadow,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
      error: (e, _) => Text('Error: $e'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
