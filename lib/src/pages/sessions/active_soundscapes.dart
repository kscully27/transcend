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
        // Store user?.activeBackgroundSound in a variable first to avoid null check issues
        final activeBackgroundSound = user?.activeBackgroundSound;
        
        // Convert from user model enum to local enum
        final userSound = activeBackgroundSound != null 
            ? ActiveBackgroundSound.values.firstWhere(
                (s) => s.toString().split('.').last == activeBackgroundSound.toString().split('.').last,
                orElse: () => ActiveBackgroundSound.None)
            : ActiveBackgroundSound.None;
            
        final currentSound = ref.watch(activeSoundscapeProvider) ?? userSound;
        
        // Use a Material widget to ensure proper rendering in modal context
        return Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: [
                // Sound options
                ...ActiveBackgroundSound.values
                    .where((sound) => sound != ActiveBackgroundSound.None)
                    .map((sound) {
                      final isSelected = sound == currentSound;
                      
                      return ListTile(
                        title: Text(
                          sound.string,
                          style: TextStyle(
                            color: theme.colorScheme.shadow,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        leading: Icon(sound.icon, color: theme.colorScheme.shadow),
                        trailing: isSelected ? Icon(Icons.check, color: theme.colorScheme.primary) : null,
                        onTap: () async {
                          try {
                            // Stop current audio
                            await _stopAudio();
                            
                            // Update state
                            ref.read(activeSoundscapeProvider.notifier).state = sound;
                            
                            // Play new sound
                            final result = await _cloudStorageService.getFile(
                              bucket: "background_loops",
                              fileName: sound.path,
                            );
                            
                            await _backgroundAudioService.play(result.url);
                            widget.onPlayStateChanged(true);
                            setState(() => _isPlaying = true);
                            
                            // Update user preference if user exists
                            if (user != null) {
                              final userModelSound = user_model.ActiveBackgroundSound.values.firstWhere(
                                (s) => s.toString().split('.').last == sound.toString().split('.').last,
                                orElse: () => user_model.ActiveBackgroundSound.None
                              );
                              
                              await ref.read(userProvider.notifier).updateActiveBackgroundSound(userModelSound);
                            }
                          } catch (e) {
                            // Show error to user via SnackBar instead of printing to console
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Could not play sound: $e")),
                            );
                          }
                        },
                      );
                    }).toList(),
                
                // Done button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _stopAudio();
                      widget.onBack();
                    },
                    child: const Text("Done"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.colorScheme.shadow,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (e, _) => Center(child: Text('Error: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
} 