import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/pages/sessions/active_soundscapes.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/background_audio.service.dart';
import 'package:trancend/src/services/storage_service.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
import 'package:trancend/src/ui/time_slider.dart';

class Active extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  final void Function(Duration) onStart;

  const Active({
    Key? key,
    required this.onBack,
    required this.onStart,
  }) : super(key: key);

  @override
  ConsumerState<Active> createState() => _ActiveState();
}

class _ActiveState extends ConsumerState<Active> {
  final _backgroundAudioService = locator<BackgroundAudioService>();
  final _cloudStorageService = locator<CloudStorageService>();
  bool _isPlaying = false;
  int _selectedDuration = 20;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void dispose() {
    _stopAudio();
    super.dispose();
  }

  Future<void> _stopAudio() async {
    if (_isPlaying) {
      await _backgroundAudioService.stop();
      setState(() => _isPlaying = false);
    }
  }

  void _handlePlayStateChanged(bool isPlaying) {
    setState(() {
      _isPlaying = isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(userProvider);
    final selectedSound = ref.watch(activeSoundscapeProvider);
    
    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox();

        final userSound = user.activeBackgroundSound != null 
            ? ActiveBackgroundSound.values.firstWhere(
                (s) => s.toString().split('.').last == user.activeBackgroundSound.toString().split('.').last,
                orElse: () => ActiveBackgroundSound.None)
            : ActiveBackgroundSound.None;
            
        final activeSound = selectedSound ?? userSound;

        return Navigator(
          key: _navigatorKey,
          initialRoute: '/main',
          onGenerateRoute: (settings) {
            if (settings.name == '/active_soundscapes') {
              return MaterialPageRoute(
                builder: (context) => ActiveSoundscapes(
                  onPlayStateChanged: _handlePlayStateChanged,
                  onBack: () => _navigatorKey.currentState!.pop(),
                ),
              );
            }
            
            return MaterialPageRoute(
              builder: (context) => Column(
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigatorKey.currentState!.pushNamed('/active_soundscapes'),
                      child: GlassContainer(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        borderRadius: BorderRadius.circular(16),
                        backgroundColor: Colors.white10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              activeSound.icon,
                              size: 80,
                              color: theme.colorScheme.shadow,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              activeSound.string,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.shadow,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'TAP TO CHANGE SOUNDSCAPE',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.shadow.withOpacity(0.7),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: GlassButton(
                      onPressed: () => widget.onStart(Duration(minutes: _selectedDuration)),
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
              ),
            );
          },
        );
      },
      error: (e, _) => Text('Error: $e'),
      loading: () => const CircularProgressIndicator(),
    );
  }
} 