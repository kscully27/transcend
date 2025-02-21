import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/background_audio.service.dart';
import 'package:trancend/src/ui/background_sound/background_sound_selector.dart';

class UserSettings extends ConsumerStatefulWidget {
  const UserSettings({super.key});

  @override
  ConsumerState<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends ConsumerState<UserSettings> {
  final _backgroundAudioService = locator<BackgroundAudioService>();
  final bool _isPlaying = false;

  @override
  void dispose() {
    if (_isPlaying) {
      _backgroundAudioService.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          onTap: () => BackgroundSoundSelector.show(context, user),
        ),
        
        // ... other settings ...
      ],
    );
  }
} 