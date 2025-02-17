import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/pages/settings.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/background_audio.service.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
import 'package:trancend/src/ui/time_slider.dart';
import 'package:trancend/src/models/user.model.dart' as user_model;
import 'package:trancend/src/pages/sessions/hypnotherapyMethods.dart';

class HypnotherapySettings extends ConsumerWidget {
  const HypnotherapySettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        // Settings content will go here
        );
  }
}

class Hypnotherapy extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  final Function(int duration) onStart;
  final Function(String pageName) changePage;
  const Hypnotherapy({
    super.key,
    required this.onBack,
    required this.onStart,
    required this.changePage,
  });

  @override
  ConsumerState<Hypnotherapy> createState() => _HypnotherapyState();
}

class _HypnotherapyState extends ConsumerState<Hypnotherapy> {
  int _selectedDuration = 20;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(userProvider);
    final selectedMethod = ref.watch(hypnotherapyMethodProvider);
    
    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox();

        final _backgroundAudioService = locator<BackgroundAudioService>();
        final method = selectedMethod ?? user.hypnotherapyMethod ?? user_model.HypnotherapyMethod.values.first;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 100,
              child: TimeSlider(
                values: const [3, 5, 8, 10, 15, 20, 25, 30],
                onValueChanged: (value) {
                  setState(() {
                    _selectedDuration = value;
                  });
                },
                color: theme.colorScheme.shadow,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GlassContainer(
                borderRadius: BorderRadius.circular(10),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                border: Border.all(color: theme.colorScheme.shadow, width: .1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => widget.changePage('/hypnotherapy_methods'),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                method.name,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.shadow,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Method',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.shadow,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: .5,
                        height: 20,
                        color: theme.colorScheme.shadow,
                      ),
                      GestureDetector(
                        onTap: () => widget.changePage('/soundscapes'),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                user.backgroundSound.name.toUpperCase(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.shadow,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'SoundScape',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.shadow,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GlassButton(
                onPressed: () => widget.onStart(_selectedDuration),
                text: "Start Session",
                textColor: theme.colorScheme.shadow,
                glassColor: Colors.white10,
                opacity: .15,
                borderWidth: 0,
                height: 60,
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
      error: (e, _) => Text('Error: $e'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
