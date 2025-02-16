import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/services/background_audio.service.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/services/storage_service.dart';

class BackgroundSoundSelector extends ConsumerStatefulWidget {
  final User user;
  final bool showTitle;
  final VoidCallback? onClose;

  const BackgroundSoundSelector({
    super.key,
    required this.user,
    this.showTitle = true,
    this.onClose,
  });

  static void show(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: BackgroundSoundSelector(
          user: user,
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  ConsumerState<BackgroundSoundSelector> createState() => _BackgroundSoundSelectorState();
}

class _BackgroundSoundSelectorState extends ConsumerState<BackgroundSoundSelector> {
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showTitle) ...[
          Text(
            'Select Background Sound',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
        ],
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
                  groupValue: widget.user.backgroundSound,
                  onChanged: (value) async {
                    if (value == null || !mounted) return;
                    
                    // Stop current sound first
                    if (_isPlaying) {
                      await _backgroundAudioService.stop();
                      if (!mounted) return;
                      setState(() => _isPlaying = false);
                    }

                    try {
                      // Update UI state immediately
                      setState(() => _isPlaying = true);
                      
                      // Perform async operations after state update
                      final result = await _cloudStorageService.getFile(
                        bucket: "background_loops",
                        fileName: value.path,
                      );
                      
                      if (!mounted) {
                        await _backgroundAudioService.stop();
                        return;
                      }

                      await _backgroundAudioService.play(result.url);
                      await _firestoreService.updateUser(
                        widget.user.copyWith(backgroundSound: value),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      setState(() => _isPlaying = false);
                      await _backgroundAudioService.stop();
                    }
                  },
                ),
                onTap: () async {
                  if (!mounted) return;

                  // Stop current sound first
                  if (_isPlaying) {
                    await _backgroundAudioService.stop();
                    if (!mounted) return;
                    setState(() => _isPlaying = false);
                  }

                  try {
                    // Update UI state immediately
                    setState(() => _isPlaying = true);

                    // Perform async operations after state update
                    final result = await _cloudStorageService.getFile(
                      bucket: "background_loops",
                      fileName: sound.path,
                    );

                    if (!mounted) {
                      await _backgroundAudioService.stop();
                      return;
                    }

                    await _backgroundAudioService.play(result.url);
                    await _firestoreService.updateUser(
                      widget.user.copyWith(backgroundSound: sound),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    setState(() => _isPlaying = false);
                    await _backgroundAudioService.stop();
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
} 