import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

final backgroundSoundProvider = StateNotifierProvider<BackgroundSoundState, double>((ref) {
  return BackgroundSoundState();
});

class BackgroundSoundState extends StateNotifier<double> {
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  BackgroundSoundState() : super(0.4); // Default volume is 0.4

  bool get isPlaying => _isPlaying;
  
  Future<void> init(String url, {double volume = 0.4}) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.setVolume(volume);
      state = volume;
      await _audioPlayer.play();
      _isPlaying = true;
    } catch (e) {
      print('Error initializing background sound: $e');
    }
  }

  Future<void> updateVolume(double volume) async {
    if (volume >= 0 && volume <= 1) {
      await _audioPlayer.setVolume(volume);
      state = volume;
    }
  }

  Future<void> playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    _isPlaying = !_isPlaying;
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
} 