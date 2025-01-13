import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/models/track.model.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/firestore.service.dart';

// Provide the FirestoreService instance
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreServiceAdapter();
});

final tranceStateProvider = StateNotifierProvider<TranceState, AsyncValue<Session?>>(
  (ref) {
    final auth = ref.watch(userProvider);
    final user = auth.value;
    return TranceState(ref.watch(firestoreServiceProvider), user?.uid);
  },
);

class TranceState extends StateNotifier<AsyncValue<Session?>> {
  static const DEFAULT_SESSION_MINUTES = 20;
  
  final FirestoreService _firestoreService;
  final String? _uid;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;
  bool _isPlaying = false;
  bool _isLoadingAudio = false;
  int _currentMillisecond = 0;
  int _cumulativeMilliseconds = 0;
  int _previousTracksDuration = 0;
  DateTime? _lastTrackStartTime;
  List<Track> _tracks = [];
  int _currentTrackIndex = 0;
  Topic? _currentTopic;

  TranceState(this._firestoreService, this._uid) : super(AsyncValue<Session?>.data(null));

  bool get isPlaying => _isPlaying;
  bool get isLoadingAudio => _isLoadingAudio;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  int get currentMillisecond => _cumulativeMilliseconds;

  Future<void> startTranceSession({
    required Topic topic,
    required TranceMethod tranceMethod,
  }) async {
    if (!mounted) return;
    
    try {
      if (_uid == null) {
        if (!mounted) return;
        state = AsyncValue.error('User not authenticated', StackTrace.current);
        return;
      }

      if (!mounted) return;
      state = const AsyncValue.loading();

      // Create initial session
      final createdSession = Session(
        uid: _uid,
        topicId: topic.id,
        startTime: DateTime.now().millisecondsSinceEpoch,
        isComplete: false,
      );

      if (!mounted) return;
      state = AsyncValue.data(createdSession);

      // Load tracks if needed
      await _loadTracks(topic);
      
      // Play first track
      if (_tracks.isNotEmpty) {
        await _playNextTrack();
      }

    } catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _playNextTrack() async {
    if (_tracks.isEmpty || _currentTrackIndex >= _tracks.length) {
      _isPlaying = false;
      if (!mounted) return;
      state = AsyncValue.data(state.value);
      return;
    }

    try {
      // Store the previous track duration before loading the next track
      if (_currentTrackIndex > 0) {
        _previousTracksDuration += _audioPlayer.duration?.inMilliseconds ?? 0;
      }
      
      _isLoadingAudio = true;
      _isPlaying = true;
      _lastTrackStartTime = DateTime.now();
      
      // Ensure timer is running
      _ensureTimerIsRunning();
      
      if (!mounted) return;
      state = AsyncValue.data(state.value);

      final track = _tracks[_currentTrackIndex];
      await _audioPlayer.setUrl(track.url!);
      await _audioPlayer.play();
      
      _isLoadingAudio = false;
      _currentTrackIndex++;

      if (!mounted) return;
      state = AsyncValue.data(state.value);

      // Set up listener for track completion
      _audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          _playNextTrack();
        }
      });

    } catch (e) {
      print('Error playing track: $e');
      _isLoadingAudio = false;
      if (!mounted) return;
      state = AsyncValue.data(state.value);
    }
  }

  void _ensureTimerIsRunning() {
    if (_timer?.isActive != true) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted || state.value == null) return;
      
      try {
        // Calculate current position regardless of play state
        if (_isLoadingAudio && _lastTrackStartTime != null) {
          // During loading, use system clock
          final elapsedSinceLastTrack = DateTime.now().difference(_lastTrackStartTime!).inMilliseconds;
          _currentMillisecond = elapsedSinceLastTrack;
        } else {
          _currentMillisecond = _audioPlayer.position.inMilliseconds;
        }
        
        // Always update cumulative time
        _cumulativeMilliseconds = _previousTracksDuration + _currentMillisecond;
        
        // Update state to refresh UI
        state = AsyncValue.data(state.value!);
      } catch (e) {
        print('Error updating timer: $e');
      }
    });
  }

  Future<void> playCombinedAudio() async {
    if (!mounted) return;
    
    try {
      _isPlaying = true;
      _lastTrackStartTime = DateTime.now();
      
      // Ensure timer is running
      _ensureTimerIsRunning();
      
      if (_audioPlayer.processingState == ProcessingState.completed) {
        await _playNextTrack();
      } else {
        await _audioPlayer.play();
      }

      if (!mounted) return;
      state = AsyncValue.data(state.value);
    } catch (e) {
      print('Error playing audio: $e');
      _isPlaying = false;
      if (!mounted) return;
      state = AsyncValue.data(state.value);
    }
  }

  Future<void> pauseCombinedAudio() async {
    if (!mounted) return;
    
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
      state = AsyncValue.data(state.value);
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  Future<void> _loadTracks(Topic topic) async {
    // Only reload tracks if topic changed or no tracks loaded
    if (_currentTopic?.id != topic.id || _tracks.isEmpty) {
      _currentTopic = topic;
      _tracks = await _firestoreService.getTracksFromTopic(topic);
      _tracks.shuffle();
      _currentTrackIndex = 0;
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pauseCombinedAudio();
    } else {
      await playCombinedAudio();
    }
  }

  @override
  void dispose() {
    print('Disposing trance state');
    _timer?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }
} 