import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/pages/settings.dart';
import 'package:trancend/src/services/background_audio.service.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
import 'package:trancend/src/ui/time_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/ui/background_sound/background_sound_selector.dart';

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

  const Hypnotherapy({
    super.key,
    required this.onBack,
    required this.onStart,
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
    final user = ref.watch(userProvider).value;
    if (user == null) return const SizedBox();
    final _backgroundAudioService = locator<BackgroundAudioService>();

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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Hypnotherapy',
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
                  Container(
                    width: .5,
                    height: 20,
                    color: theme.colorScheme.shadow,
                  ),
                  GestureDetector(
                    onTap: () => {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isDismissible: true,
                        enableDrag: true,
                        barrierColor: Colors.black54,
                        builder: (context) => BackgroundSoundBottomSheet(
                          isPlaying: _isPlaying,
                          onPlayStateChanged: (isPlaying) {
                            setState(() => _isPlaying = isPlaying);
                          },
                          currentSound: user.backgroundSound,
                          onSoundChanged: (sound) async {
                            await ref
                                .read(userProvider.notifier)
                                .updateBackgroundSound(sound);
                          },
                        ),
                      ).then((_) async {
                        await _backgroundAudioService.stop();
                        setState(() => _isPlaying = false);
                      })
                    },
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
            borderWidth: 0,
            opacity: 1,
            height: 60,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
