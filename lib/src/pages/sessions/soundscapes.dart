import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/user.model.dart' as user_model;
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/services/background_audio.service.dart';
import 'package:trancend/src/services/storage_service.dart';
import 'package:trancend/src/ui/glass/glass_radio_button.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';

final backgroundSoundProvider =
    StateProvider<user_model.BackgroundSound?>((ref) => null);

class Soundscapes extends ConsumerStatefulWidget {
  final Function(bool) onPlayStateChanged;
  final Function() onBack;
  const Soundscapes({
    super.key,
    required this.onPlayStateChanged,
    required this.onBack,
  });

  @override
  ConsumerState<Soundscapes> createState() =>
      _Soundscapes(onPlayStateChanged: onPlayStateChanged, onBack: onBack);
}

class _Soundscapes extends ConsumerState<Soundscapes> {
  final Function() onBack;
  // final bool isPlaying;
  // final Function(bool) onPlayStateChanged;
  // final user_model.BackgroundSound currentSound;
  // final Function(user_model.BackgroundSound) onSoundChanged;
  final _backgroundAudioService = locator<BackgroundAudioService>();
  final _cloudStorageService = locator<CloudStorageService>();
  late user_model.BackgroundSound _selectedSound =
      user_model.BackgroundSound.values.first;
  final Function(bool) onPlayStateChanged;
  bool _isPlaying = false;

  // late user_model.BackgroundSound _selectedSound;

  _Soundscapes({
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
    print('dispose');
    _stopAudio();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _selectedSound = _currentSound;
    // setState(() => _selectedSound = _currentSound);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: user_model.BackgroundSound.values.length,
              itemBuilder: (context, index) {
                final sound = user_model.BackgroundSound.values[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: GlassRadioButton<user_model.BackgroundSound>(
                    value: sound,
                    groupValue: _selectedSound,
                    onChanged: (value) async {
                      if (value == null) return;

                      // Stop current audio before playing new one
                      await _stopAudio();

                      setState(() => _selectedSound = value);

                      try {
                        final result = await _cloudStorageService.getFile(
                          bucket: "background_loops",
                          fileName: value.path,
                        );

                        if (mounted) {
                          await _backgroundAudioService.play(result.url);
                          widget.onPlayStateChanged(true);
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() => _selectedSound = _selectedSound);
                        }
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
  }
}
