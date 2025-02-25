import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/user.model.dart' as user_model;
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/background_audio.service.dart';
import 'package:trancend/src/services/storage_service.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';
import 'package:trancend/src/ui/glass/glass_radio_button.dart';
import 'package:trancend/src/shared/icons.dart';

enum ActiveBackgroundSound {
  Fire,
  Electricity,
  Encouragement,
  Energy,
  Enhance,
  Flight,
  Force,
  Ignition,
  Motivation,
  Passion,
  Power,
  Spark,
  Stamina,
  Strength,
  None
}

Map<ActiveBackgroundSound, IconData> activeBackgroundIcons = {
  ActiveBackgroundSound.Fire: AppIcons.fire,
  ActiveBackgroundSound.Electricity: AppIcons.electricity,
  ActiveBackgroundSound.Encouragement: AppIcons.encouragement,
  ActiveBackgroundSound.Energy: AppIcons.energy,
  ActiveBackgroundSound.Enhance: AppIcons.enhance,
  ActiveBackgroundSound.Flight: AppIcons.flight,
  ActiveBackgroundSound.Force: AppIcons.force,
  ActiveBackgroundSound.Ignition: AppIcons.ignition,
  ActiveBackgroundSound.Motivation: AppIcons.motivation,
  ActiveBackgroundSound.Passion: AppIcons.passion,
  ActiveBackgroundSound.Power: AppIcons.power,
  ActiveBackgroundSound.Spark: AppIcons.spark,
  ActiveBackgroundSound.Stamina: AppIcons.stamina,
  ActiveBackgroundSound.Strength: AppIcons.strength,
  ActiveBackgroundSound.None: AppIcons.none,
};

extension ActiveBackgroundSoundX on ActiveBackgroundSound {
  String get string => _enumToString(this);
  String get id => string.toLowerCase();
  IconData get icon => activeBackgroundIcons[this] ?? AppIcons.none;
  String get path => 'active/$id.mp3';
  
  static String _enumToString(ActiveBackgroundSound value) {
    return value.toString().split('.').last;
  }
  
  static ActiveBackgroundSound fromString(String string) {
    return ActiveBackgroundSound.values.firstWhere(
      (e) => _enumToString(e).toLowerCase() == string.toLowerCase(),
      orElse: () => ActiveBackgroundSound.None,
    );
  }
}

final activeSoundscapeProvider =
    StateProvider<ActiveBackgroundSound?>((ref) => null);

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

        // Convert from user model enum to local enum
        final userSound = user.activeBackgroundSound != null 
            ? ActiveBackgroundSound.values.firstWhere(
                (s) => s.toString().split('.').last == user.activeBackgroundSound.toString().split('.').last,
                orElse: () => ActiveBackgroundSound.None)
            : ActiveBackgroundSound.None;
            
        final currentSound = ref.watch(activeSoundscapeProvider) ?? userSound;

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
                  itemCount: ActiveBackgroundSound.values.length,
                  itemBuilder: (context, index) {
                    final sound = ActiveBackgroundSound.values[index];
                    if (sound == ActiveBackgroundSound.None) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: GlassRadioButton<ActiveBackgroundSound>(
                        value: sound,
                        groupValue: currentSound,
                        onChanged: (value) {
                          if (value == null) return;

                          // Schedule state updates to happen after the build phase is complete
                          Future.microtask(() async {
                            try {
                              // Make sure we're still mounted before proceeding
                              if (!mounted) return;
                              
                              // Stop current audio before playing new one
                              await _stopAudio();
                              
                              // Update local state outside of build phase
                              if (mounted) {
                                ref.read(activeSoundscapeProvider.notifier).state = value;
                              }

                              // Play the new sound
                              final result = await _cloudStorageService.getFile(
                                bucket: "background_loops",
                                fileName: value.path,
                              );

                              if (mounted) {
                                await _backgroundAudioService.play(result.url);
                                widget.onPlayStateChanged(true);
                                setState(() => _isPlaying = true);
                                
                                // Then update Firestore - only if still mounted
                                try {
                                  // Convert to user model enum for storage
                                  final userModelSound = user_model.ActiveBackgroundSound.values.firstWhere(
                                    (s) => s.toString().split('.').last == value.toString().split('.').last,
                                    orElse: () => user_model.ActiveBackgroundSound.None
                                  );
                                  
                                  await ref
                                      .read(userProvider.notifier)
                                      .updateActiveBackgroundSound(userModelSound);
                                } catch (e) {
                                  print("Error updating user preference: $e");
                                  // Continue even if Firestore update fails - it's not critical
                                }
                              }
                            } catch (e) {
                              print("Error handling soundscape selection: $e");
                              // Make sure error doesn't break the UI
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Could not play soundscape: $e")),
                                );
                              }
                            }
                          });
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