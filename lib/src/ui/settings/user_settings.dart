import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/background_audio.service.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/services/storage_service.dart';

class UserSettings extends ConsumerStatefulWidget {
  const UserSettings({super.key});

  @override
  ConsumerState<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends ConsumerState<UserSettings> {
  final _cloudStorageService = locator<CloudStorageService>();
  final _backgroundAudioService = locator<BackgroundAudioService>();
  final _firestoreService = locator<FirestoreService>();
  bool _isPlaying = false;

  @override
  void dispose() {
    if (_isPlaying) {
      _backgroundAudioService.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(userProvider).value;
    if (user == null) return const SizedBox();

    return Column(
      children: [
        // ... existing settings ...
        
        const Divider(),
        
        ListTile(
          leading: const Icon(Icons.music_note),
          title: const Text('Set Default Background Sound'),
          subtitle: Text(user.backgroundSound.string),
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select Background Sound',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: BackgroundSound.values.length,
                        itemBuilder: (context, index) {
                          final sound = BackgroundSound.values[index];
                          
                          return ListTile(
                            leading: Icon(sound.icon),
                            title: Text(sound.string),
                            trailing: Radio<BackgroundSound>(
                              value: sound,
                              groupValue: user.backgroundSound,
                              onChanged: (value) async {
                                if (value == null) return;
                                
                                // Stop current audio if playing
                                if (_isPlaying) {
                                  await _backgroundAudioService.stop();
                                }

                                // Get audio URL and play
                                final result = await _cloudStorageService.getFile(
                                  bucket: "background_loops",
                                  fileName: value.path,
                                );
                                
                                await _backgroundAudioService.play(result.url);
                                setState(() => _isPlaying = true);
                              
                                // Update user preference
                                await _firestoreService.updateUser(
                                  user.copyWith(backgroundSound: value),
                                );
                              },
                            ),
                            onTap: () async {
                              // Stop current audio if playing
                              if (_isPlaying) {
                                await _backgroundAudioService.stop();
                              }

                              // Get audio URL and play
                              final result = await _cloudStorageService.getFile(
                                bucket: "background_loops",
                                fileName: sound.path,
                              );
                              
                              await _backgroundAudioService.play(result.url);
                              setState(() => _isPlaying = true);
                            
                              // Update user preference
                              await _firestoreService.updateUser(
                                user.copyWith(backgroundSound: sound),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ).whenComplete(() {
              // Stop audio when bottom sheet is closed
              if (_isPlaying) {
                _backgroundAudioService.stop();
                setState(() => _isPlaying = false);
              }
            });
          },
        ),
        
        // ... other settings ...
      ],
    );
  }
} 