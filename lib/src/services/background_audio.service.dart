import 'package:just_audio/just_audio.dart';

class BackgroundAudioService {
  static final BackgroundAudioService _instance = BackgroundAudioService._internal();
  factory BackgroundAudioService() => _instance;
  BackgroundAudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  double _volume = 0.4;
  String? _currentSoundUrl;

  bool get isPlaying => _isPlaying;
  double get volume => _volume;
  String? get currentSound => _currentSoundUrl;

  /// Initialize the background audio with a URL
  Future<void> initialize(String soundUrl) async {
    try {
      _currentSoundUrl = soundUrl;
      await _player.setUrl(soundUrl);
      await _player.setLoopMode(LoopMode.one); // Loop the background sound
      await _player.setVolume(_volume);
    } catch (e) {
      print('Error initializing background audio: $e');
      rethrow;
    }
  }

  /// Start playing the background audio
  Future<void> play(String url) async {
    try {
      await _player.setUrl(url);
      await _player.setLoopMode(LoopMode.one);
      await _player.play();
      _isPlaying = true;
    } catch (e) {
      print('Error playing background audio: $e');
    }
  }

  /// Pause the background audio
  Future<void> pause() async {
    try {
      await _player.pause();
      _isPlaying = false;
    } catch (e) {
      print('Error pausing background audio: $e');
      rethrow;
    }
  }

  /// Toggle play/pause state
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await play(_currentSoundUrl!);
    }
  }

  /// Update the volume of the background audio
  Future<void> updateVolume(double newVolume) async {
    try {
      if (newVolume >= 0 && newVolume <= 1) {
        _volume = newVolume;
        await _player.setVolume(_volume);
      }
    } catch (e) {
      print('Error updating background audio volume: $e');
      rethrow;
    }
  }

  /// Change the background sound
  Future<void> changeSound(String newSoundUrl) async {
    try {
      final wasPlaying = _isPlaying;
      _currentSoundUrl = newSoundUrl;
      
      // Stop current playback
      await _player.stop();
      
      // Set up new sound
      await _player.setUrl(newSoundUrl);
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(_volume);
      
      // Resume playback if it was playing before
      if (wasPlaying) {
        await play(newSoundUrl);
      }
    } catch (e) {
      print('Error changing background sound: $e');
      rethrow;
    }
  }

  /// Stop the background audio
  Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
    } catch (e) {
      print('Error stopping background audio: $e');
    }
  }

  /// Clean up resources
  Future<void> dispose() async {
    try {
      await stop();
      await _player.dispose();
    } catch (e) {
      print('Error disposing background audio: $e');
    }
  }
}
