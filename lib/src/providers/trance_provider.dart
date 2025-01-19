import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:trancend/src/constants/strings.dart';
import 'package:trancend/src/models/goal.model.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/models/track.model.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/firestore.service.dart';

// Provide the FirestoreService instance
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreServiceAdapter();
});

final tranceStateProvider =
    StateNotifierProvider<TranceState, AsyncValue<Session?>>(
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
  final int _currentMillisecond = 0;
  int _cumulativeMilliseconds = 0;
  int _previousTracksDuration = 0;
  DateTime? _lastTrackStartTime;
  DateTime? _sessionStartTime;
  List<Track> _tracks = [];
  int _currentTrackIndex = 0;
  Topic? _currentTopic;
  Track? _inductionTrack;
  Track? _awakeningTrack;
  int _inductionDuration = 0;
  int _awakeningDuration = 0;

  TranceState(this._firestoreService, this._uid)
      : super(AsyncValue<Session?>.data(null));

  bool get isPlaying => _isPlaying;
  bool get isLoadingAudio => _isLoadingAudio;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  int get currentMillisecond => _cumulativeMilliseconds;

  int getTranceTime() {
    return state.value?.totalMinutes ?? DEFAULT_SESSION_MINUTES;
  }

  Future<void> startTranceSession({
    required Topic topic,
    required TranceMethod tranceMethod,
    Goal? goal,
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
      Session createdSession = Session(
        uid: _uid,
        topicId: topic.id,
        startTime: DateTime.now().millisecondsSinceEpoch,
        isComplete: false,
        inductionId: tranceMethod == TranceMethod.Sleep ||
                tranceMethod == TranceMethod.Breathing ||
                tranceMethod == TranceMethod.Meditation
            ? null
            : tranceMethod == TranceMethod.Active
                ? defaultActiveInductionId
                : defaultInductionId,
        awakeningId: tranceMethod == TranceMethod.Sleep ||
                tranceMethod == TranceMethod.Breathing ||
                tranceMethod == TranceMethod.Meditation
            ? null
            : tranceMethod == TranceMethod.Active
                ? defaultActiveAwakeningId
                : defaultAwakeningId,
        totalMinutes: getTranceTime(),
        goalId: goal?.id,
        goalName: goal?.name,
        tranceMethod: tranceMethod,
        startedTime: DateTime.now().millisecondsSinceEpoch,
        totalTracks: 0,
      );
      createdSession = await _firestoreService.createSession(createdSession);

      if (!mounted) return;
      state = AsyncValue.data(createdSession);

      // Load tracks if needed
      await _loadTracks(createdSession, topic);

      // Don't auto-play, just prepare the first track
      if (_tracks.isNotEmpty) {
        await _prepareNextTrack();
      }
    } catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _prepareNextTrack() async {
    if (_tracks.isEmpty || _currentTrackIndex >= _tracks.length) {
      _currentTrackIndex = 0;
      state = AsyncValue.data(state.value);
      return;
    }

    try {
      // Store the previous track duration before loading the next track
      if (_currentTrackIndex > 0) {
        _previousTracksDuration += _audioPlayer.duration?.inMilliseconds ?? 0;
      }

      final track = _tracks[_currentTrackIndex];
      await _audioPlayer.setUrl(track.url!);

      // Set up listener for track completion
      _audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          _playNextTrack();
        }
      });

      // If we were playing before, continue playing
      if (_isPlaying) {
        await _audioPlayer.play();
      }

      state = AsyncValue.data(state.value);
    } catch (e) {
      print('Error preparing track: $e');
      if (!mounted) return;
      state = AsyncValue.data(state.value);
    }
  }

  Future<void> _playNextTrack() async {
    if (_tracks.isEmpty) {
      state = AsyncValue.data(state.value);
      return;
    }

    try {
      // Check if it's time for awakening
      if (_awakeningTrack != null && _currentTrackIndex < _tracks.length) {
        final totalSessionMs = getTranceTime() * 60 * 1000;
        final elapsedTime = _cumulativeMilliseconds;
        final timeUntilEnd = totalSessionMs - elapsedTime;
        
        // If less than 10 seconds until session end, play awakening
        if (timeUntilEnd <= 10000) {
          _tracks.add(_awakeningTrack!);
          _currentTrackIndex = _tracks.length - 1;
        }
      }

      // Handle end of track list
      if (_currentTrackIndex >= _tracks.length) {
        _isPlaying = false;
        state = AsyncValue.data(state.value);
        return;
      }

      _lastTrackStartTime = DateTime.now();
      _ensureTimerIsRunning();

      final track = _tracks[_currentTrackIndex];
      await _audioPlayer.setUrl(track.url!);

      if (_isPlaying) {
        await _audioPlayer.play();
      }

      _currentTrackIndex++;
      state = AsyncValue.data(state.value);

      _audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          _playNextTrack();
        }
      });
    } catch (e) {
      print('Error playing track: $e');
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
        if (_isPlaying) {
          _sessionStartTime ??= DateTime.now();

          final now = DateTime.now();
          _cumulativeMilliseconds =
              now.difference(_sessionStartTime!).inMilliseconds;
        }

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

      // Adjust session start time based on accumulated time
      if (_sessionStartTime == null) {
        _sessionStartTime = DateTime.now();
      } else {
        _sessionStartTime = DateTime.now()
            .subtract(Duration(milliseconds: _cumulativeMilliseconds));
      }

      // Ensure timer is running
      _ensureTimerIsRunning();

      await _audioPlayer.play();

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
      _isPlaying = false;
      await _audioPlayer.pause();

      // Store current progress before pausing
      if (_sessionStartTime != null) {
        final pauseTime = DateTime.now();
        final elapsed = pauseTime.difference(_sessionStartTime!).inMilliseconds;
        _cumulativeMilliseconds = elapsed;
      }
      state = AsyncValue.data(state.value);
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  Future<void> _loadTracks(Session session, Topic topic) async {
    if (_currentTopic?.id != topic.id || _tracks.isEmpty) {
      _currentTopic = topic;
      _tracks = [];
      
      // Load induction and awakening for hypnotherapy
      if (session.tranceMethod == TranceMethod.Hypnotherapy) {
        _inductionTrack = await _firestoreService.getAudioTrackById(session.inductionId!);
        _awakeningTrack = await _firestoreService.getAudioTrackById(session.awakeningId!);
        
        if (_inductionTrack == null || _awakeningTrack == null) {
          throw Exception('Failed to load induction or awakening track');
        }

        // Get durations from metadata
        await _audioPlayer.setUrl(_inductionTrack!.url!);
        _inductionDuration = (await _audioPlayer.duration)?.inMilliseconds ?? 0;
        
        await _audioPlayer.setUrl(_awakeningTrack!.url!);
        _awakeningDuration = (await _audioPlayer.duration)?.inMilliseconds ?? 0;
        
        // Calculate available time for suggestions
        final totalSessionMs = getTranceTime() * 60 * 1000;
        final availableForSuggestions = totalSessionMs - _inductionDuration - _awakeningDuration;
        
        // Check if we have enough time for suggestions
        if (availableForSuggestions < 120000) { // 2 minutes in ms
          throw Exception('Session time too short. Please extend your session duration to accommodate induction (${_inductionDuration ~/ 60000}min) and awakening (${_awakeningDuration ~/ 60000}min).');
        }

        _tracks.add(_inductionTrack!);
      }
      
      // Load and shuffle suggestion tracks
      List<Track> suggestions = await _firestoreService.getTracksFromTopic(topic);
      suggestions.shuffle();
      _tracks.addAll(suggestions);
      
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
    _isPlaying = false;
    _isLoadingAudio = false;
    _cumulativeMilliseconds = 0;
    _previousTracksDuration = 0;
    _lastTrackStartTime = null;
    _sessionStartTime = null;
    _tracks = [];
    _currentTrackIndex = 0;
    _currentTopic = null;
    _inductionTrack = null;
    _awakeningTrack = null;
    _inductionDuration = 0;
    _awakeningDuration = 0;
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }
}
