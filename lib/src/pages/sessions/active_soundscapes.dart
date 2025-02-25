import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/user.model.dart' as user_model;
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/background_audio.service.dart';
import 'package:trancend/src/services/storage_service.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';
import 'package:trancend/src/ui/glass/glass_radio_button.dart';

final activeSoundscapeProvider =
    StateProvider<user_model.ActiveBackgroundSound?>((ref) => null);

class ActiveSoundscapes extends ConsumerStatefulWidget {
  final Function(bool) onPlayStateChanged;
  final Function() onBack;
  
  const ActiveSoundscapes({
    super.key,
    required this.onPlayStateChanged,
    required this.onBack,
  });

  @override
  ConsumerState<ActiveSoundscapes> createState() =>
      _ActiveSoundscapesState(onPlayStateChanged: onPlayStateChanged, onBack: onBack);
}

class _ActiveSoundscapesState extends ConsumerState<ActiveSoundscapes> {
  final Function() onBack;
  final _backgroundAudioService = locator<BackgroundAudioService>();
  final _cloudStorageService = locator<CloudStorageService>();
  final Function(bool) onPlayStateChanged;
  bool _isPlaying = false;

  _ActiveSoundscapesState({
    required this.onPlayStateChanged,
    required this.onBack,
  });

  Future<void> _stopAudio() async {
    if (_isPlaying) {
      await _backgroundAudioService.stop();
      setState(() => _isPlaying = false);
    }
  }

  @override
  void dispose() {
    _stopAudio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(userProvider);
    
    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox();

        final currentSound = ref.watch(activeSoundscapeProvider) ?? user.activeBackgroundSound;

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Active Soundscapes",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.shadow,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: user_model.ActiveBackgroundSound.values.length,
                  itemBuilder: (context, index) {
                    final sound = user_model.ActiveBackgroundSound.values[index];
                    if (sound == user_model.ActiveBackgroundSound.None) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: GlassRadioButton<user_model.ActiveBackgroundSound>(
                        value: sound,
                        groupValue: currentSound,
                        onChanged: (value) async {
                          if (value == null) return;

                          // Stop current audio before playing new one
                          await _stopAudio();

                          // Update local state immediately
                          ref.read(activeSoundscapeProvider.notifier).state = value;

                          try {
                            // Play the new sound
                            final result = await _cloudStorageService.getFile(
                              bucket: "background_loops",
                              fileName: value.path,
                            );

                            if (mounted) {
                              await _backgroundAudioService.play(result.url);
                              widget.onPlayStateChanged(true);
                              setState(() => _isPlaying = true);
                            }

                            // Then update Firestore
                            await ref
                                .read(userProvider.notifier)
                                .updateActiveBackgroundSound(value);
                          } catch (e) {
                            print("error playing audio: $e");
                          }
                        },
                        icon: sound.icon,
                        title: sound.string,
                        titleStyle: TextStyle(
                          color: theme.colorScheme.shadow,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                child: GlassButton(
                  onPressed: () {
                    _stopAudio();
                    widget.onBack();
                  },
                  text: "Done",
                  textColor: theme.colorScheme.shadow,
                  glassColor: Colors.white10,
                  borderWidth: 0,
                  opacity: .4,
                  height: 60,
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