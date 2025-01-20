import 'package:clay_containers/widgets/clay_container.dart' as clay_containers;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/pages/theme_editor.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/background_audio.service.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/services/storage_service.dart';
import 'package:trancend/src/ui/clay/clay_radio_button.dart';

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  return DarkModeNotifier();
});

final backgroundSoundProvider = StateProvider<BackgroundSound?>((ref) => null);

class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier() : super(false) {
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('darkMode') ?? false;
  }

  Future<void> toggle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', !state);
    state = !state;
  }
}

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<SettingsPage> {
  final _backgroundAudioService = locator<BackgroundAudioService>();
  final _firestoreService = locator<FirestoreService>();
  bool _isPlaying = false;

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
    final isDarkMode = ref.watch(darkModeProvider);
    final user = ref.watch(userProvider);
    final selectedSound = ref.watch(backgroundSoundProvider) ?? user.value?.backgroundSound;
    
    if (user.value == null) return const SizedBox();

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: theme.textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              clay_containers.ClayContainer(
                color: theme.colorScheme.surface,
                parentColor: theme.colorScheme.surface,
                borderRadius: 12,
                width: double.infinity,
                height: 100,
                depth: 20,
                spread: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dark Mode',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          ref.read(darkModeProvider.notifier).toggle();
                        },
                        activeColor: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              if (kIsWeb) ...[
                const SizedBox(height: 16),
                clay_containers.ClayContainer(
                  color: theme.colorScheme.surface,
                  parentColor: theme.colorScheme.surface,
                  borderRadius: 12,
                  width: double.infinity,
                  height: 100,
                  depth: 20,
                  spread: 2,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ThemeEditor(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Theme Editor',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: theme.colorScheme.onSurface,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              const Divider(),
              clay_containers.ClayContainer(
                color: theme.colorScheme.surface,
                parentColor: theme.colorScheme.surface,
                borderRadius: 12,
                width: double.infinity,
                height: 100,
                depth: 20,
                spread: 2,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
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
                          currentSound: user.value!.backgroundSound,
                          onSoundChanged: (sound) async {
                            await ref.read(userProvider.notifier).updateBackgroundSound(sound);
                          },
                        ),
                      ).then((_) async {
                        await _backgroundAudioService.stop();
                        setState(() => _isPlaying = false);
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Set Default Background Sound',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: theme.colorScheme.onSurface,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackgroundSoundBottomSheet extends ConsumerStatefulWidget {
  final bool isPlaying;
  final Function(bool) onPlayStateChanged;
  final BackgroundSound currentSound;
  final Function(BackgroundSound) onSoundChanged;

  const BackgroundSoundBottomSheet({
    super.key,
    required this.isPlaying,
    required this.onPlayStateChanged,
    required this.currentSound,
    required this.onSoundChanged,
  });

  @override
  ConsumerState<BackgroundSoundBottomSheet> createState() => _BackgroundSoundBottomSheetState();
}

class _BackgroundSoundBottomSheetState extends ConsumerState<BackgroundSoundBottomSheet> {
  final _backgroundAudioService = locator<BackgroundAudioService>();
  final _cloudStorageService = locator<CloudStorageService>();
  late BackgroundSound _selectedSound;

  Future<void> _stopAudio() async {
    if (widget.isPlaying) {
      await _backgroundAudioService.stop();
      widget.onPlayStateChanged(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedSound = widget.currentSound;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      onPopInvoked: (_) {
        _stopAudio();
        if (_selectedSound != widget.currentSound) {
          widget.onSoundChanged(_selectedSound);
        }
      },
      child: Container(
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

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ClayRadioButton<BackgroundSound>(
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

                          if (mounted && result.url != null) {
                            await _backgroundAudioService.play(result.url!);
                            widget.onPlayStateChanged(true);
                          }
                        } catch (e) {
                          if (mounted) {
                            setState(() => _selectedSound = widget.currentSound);
                          }
                          print("error playing audio: $e");
                        }
                      },
                      color: theme.colorScheme.surface,
                      parentColor: theme.colorScheme.surface,
                      depth: 20,
                      spread: 2,
                      size: 24,
                      icon: sound.icon,
                      title: sound.string,
                      titleStyle: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
