import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/services/audio_service.dart';

final backgroundAudioProvider = StateNotifierProvider<BackgroundAudioNotifier, bool>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return BackgroundAudioNotifier(audioService);
});

class BackgroundAudioNotifier extends StateNotifier<bool> {
  final AudioService _audioService;

  BackgroundAudioNotifier(this._audioService) : super(false);

  Future<void> setAudio(String audioUrl) async {
    await _audioService.setUrl(audioUrl);
  }

  Future<void> play() async {
    await _audioService.playBackgroundAudio();
    state = true;
  }

  Future<void> pause() async {
    await _audioService.pauseBackgroundAudio();
    state = false;
  }

  Future<void> stop() async {
    await _audioService.stopBackgroundAudio();
    state = false;
  }

  Future<void> setVolume(double volume) async {
    await _audioService.setBackgroundVolume(volume);
  }

  @override
  void dispose() {
    unawaited(_audioService.dispose());
    super.dispose();
  }
} 