import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioServiceProvider = Provider<AudioService>((ref) => AudioService());

class AudioService {
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  bool _isBackgroundPlaying = false;

  // Getter for the current playing state
  bool get isBackgroundPlaying => _isBackgroundPlaying;

  // Initialize with a URL audio source
  Future<void> setUrl(String url) async {
    try {
      await _backgroundPlayer.setUrl(url);
      await _backgroundPlayer.setLoopMode(LoopMode.one); // Set to loop
      await _backgroundPlayer.setVolume(0.5); // Set default volume
    } catch (e) {
      print('Error setting background audio URL: $e');
    }
  }

  // Initialize with a local asset
  Future<void> setAsset(String assetPath) async {
    try {
      await _backgroundPlayer.setAsset(assetPath);
      await _backgroundPlayer.setLoopMode(LoopMode.one); // Set to loop
      await _backgroundPlayer.setVolume(0.5); // Set default volume
    } catch (e) {
      print('Error setting background audio asset: $e');
    }
  }

  // Play background audio
  Future<void> playBackgroundAudio() async {
    try {
      await _backgroundPlayer.play();
      _isBackgroundPlaying = true;
    } catch (e) {
      print('Error playing background audio: $e');
    }
  }

  // Pause background audio
  Future<void> pauseBackgroundAudio() async {
    try {
      await _backgroundPlayer.pause();
      _isBackgroundPlaying = false;
    } catch (e) {
      print('Error pausing background audio: $e');
    }
  }

  // Stop background audio
  Future<void> stopBackgroundAudio() async {
    try {
      await _backgroundPlayer.stop();
      _isBackgroundPlaying = false;
    } catch (e) {
      print('Error stopping background audio: $e');
    }
  }

  // Set volume (0.0 to 1.0)
  Future<void> setBackgroundVolume(double volume) async {
    try {
      await _backgroundPlayer.setVolume(volume);
    } catch (e) {
      print('Error setting background volume: $e');
    }
  }

  // Dispose the player when no longer needed
  Future<void> dispose() async {
    try {
      _isBackgroundPlaying = false;
      await _backgroundPlayer.stop();
      await Future.delayed(const Duration(milliseconds: 100));  // Add small delay to ensure stop completes
      await _backgroundPlayer.dispose();
    } catch (e) {
      print('Error disposing audio service: $e');
    }
  }
} 