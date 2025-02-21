import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:trancend/src/constants/strings.dart';
import 'package:trancend/src/models/goal.model.dart';
import 'package:trancend/src/models/played_track.model.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/models/track.model.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/services/audio_service.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/services/storage_service.dart';
import 'package:get_it/get_it.dart';

// Provide the FirestoreService instance
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreServiceAdapter();
});

final tranceStateProvider =
    StateNotifierProvider<TranceState, AsyncValue<Session?>>(
  (ref) {
    final auth = ref.watch(userProvider);
    final user = auth.value;
    final audioService = ref.watch(audioServiceProvider);
    return TranceState(ref.watch(firestoreServiceProvider), user?.uid, ref, audioService);
  },
);

class TranceState extends StateNotifier<AsyncValue<Session?>> {
  static const DEFAULT_SESSION_MINUTES = 20;

  final FirestoreService _firestoreService;
  final CloudStorageService _cloudStorageService = GetIt.I<CloudStorageService>();
  final String? _uid;
  late AudioPlayer _audioPlayer;
  final AudioService _audioService;
  final Ref ref;
  Timer? _timer;
  bool _isPlaying = false;
  bool _isLoadingAudio = true;
  int _cumulativeMilliseconds = 0;
  DateTime? _sessionStartTime;
  List<Track> _tracks = [];
  int _currentTrackIndex = 0;
  Topic? _currentTopic;
  Track? _inductionTrack;
  Track? _awakeningTrack;
  Track? _currentTrack;
  int _inductionDuration = 0;
  int _awakeningDuration = 0;
  double _backgroundVolume = 0.4;
  double _voiceVolume = 0.5;

  TranceState(this._firestoreService, this._uid, this.ref, this._audioService)
      : super(AsyncValue<Session?>.data(null)) {
    // Initialize audio player
    _initAudioPlayer();
    
    // Register cleanup when provider is disposed
    ref.onDispose(() {
      print('Disposing TranceState');
      _timer?.cancel();
      _disposeAudioPlayer();
      _audioService.dispose();
    });
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setVolume(_voiceVolume);
  }

  Future<void> _disposeAudioPlayer() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
    } catch (e) {
      print('Error disposing audio player: $e');
    }
  }

  bool get isPlaying => _isPlaying;
  bool get isLoadingAudio => _isLoadingAudio;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Track? get currentTrack => _currentTrack;
  double get backgroundVolume => _backgroundVolume;
  double get voiceVolume => _voiceVolume;

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
      _isLoadingAudio = true;  // Set loading state at start

      // Start background audio without blocking
      _firestoreService.getUser(_uid).then((user) async {
        if (user.backgroundSound != BackgroundSound.None) {
          final result = await _cloudStorageService.getFile(
            bucket: "background_loops",
            fileName: user.backgroundSound.path,
          );
          
          await _audioService.setUrl(result.url);
          _audioService.playBackgroundAudio(); // Don't await this
                }
      }); // Don't await the entire background audio setup

      // Create initial session
      Session createdSession = Session(
        uid: _uid,
        topicId: topic.id,
        startTime: DateTime.now().millisecondsSinceEpoch,
        isComplete: false,
        inductionId: tranceMethod == TranceMethod.Sleep ||
                tranceMethod == TranceMethod.Breathe ||
                tranceMethod == TranceMethod.Meditation
            ? null
            : tranceMethod == TranceMethod.Active
                ? defaultActiveInductionId
                : defaultInductionId,
        awakeningId: tranceMethod == TranceMethod.Sleep ||
                tranceMethod == TranceMethod.Breathe ||
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

      // Load tracks and set up initial state
      await _loadTracks(createdSession, topic);
      _isLoadingAudio = false;
      state = AsyncValue.data(state.value);
    } catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _loadTracks(Session session, Topic topic) async {
    if (_currentTopic?.id != topic.id || _tracks.isEmpty) {
      _currentTopic = topic;
      _tracks = [];

      // Load and shuffle suggestion tracks first
      List<Track> suggestions =
          await _firestoreService.getTracksFromTopic(topic);
      suggestions.shuffle();
      _tracks = suggestions; // Only suggestion tracks go in _tracks

      // Load induction and awakening for hypnotherapy
      if (session.tranceMethod == TranceMethod.Hypnosis) {
        _inductionTrack =
            await _firestoreService.getAudioTrackById(session.inductionId!);
        _awakeningTrack =
            await _firestoreService.getAudioTrackById(session.awakeningId!);

        if (_inductionTrack == null || _awakeningTrack == null) {
          throw Exception('Failed to load induction or awakening track');
        }

        // Get durations from metadata
        await _audioPlayer.setUrl(_inductionTrack!.url!);
        _inductionDuration = (_audioPlayer.duration)?.inMilliseconds ?? 0;

        await _audioPlayer.setUrl(_awakeningTrack!.url!);
        _awakeningDuration = (_audioPlayer.duration)?.inMilliseconds ?? 0;

        // Calculate available time for suggestions
        final totalSessionMs = getTranceTime() * 60 * 1000;
        final availableForSuggestions =
            totalSessionMs - _inductionDuration - _awakeningDuration;

        // Check if we have enough time for suggestions
        if (availableForSuggestions < 120000) {
          // 2 minutes in ms
          throw Exception(
              'Session time too short. Please extend your session duration to accommodate induction (${_inductionDuration ~/ 60000}min) and awakening (${_awakeningDuration ~/ 60000}min).');
        }

        // Start with induction track
        _currentTrack = _inductionTrack;
        await _audioPlayer.setUrl(_inductionTrack!.url!);

        // Set up completion listener for track transitions
        _audioPlayer.playerStateStream.listen((playerState) {
          if (playerState.processingState == ProcessingState.completed) {
            print('Track completed, moving to next track');
            _playNextTrack();
          }
        });
      } else {
        // For non-hypnotherapy, start with first suggestion track
        if (_tracks.isNotEmpty) {
          _currentTrack = _tracks[0];
          await _audioPlayer.setUrl(_currentTrack!.url!);

          // Set up completion listener for track transitions
          _audioPlayer.playerStateStream.listen((playerState) {
            if (playerState.processingState == ProcessingState.completed) {
              print('Track completed, moving to next track');
              _playNextTrack();
            }
          });
        }
      }

      _currentTrackIndex = 0;
    }
  }

  Future<void> _playNextTrack() async {
    try {
      print('Playing next track');

      // Special handling for hypnotherapy sequence
      if (state.value?.tranceMethod == TranceMethod.Hypnosis) {
        final totalSessionMs = getTranceTime() * 60 * 1000;

        // If we're playing induction
        if (_currentTrack == _inductionTrack) {
          print('Finished induction, moving to suggestions');
          _currentTrackIndex = 0; // Start with first suggestion
          if (_tracks.isNotEmpty) {
            _currentTrack = _tracks[_currentTrackIndex];
            _currentTrackIndex++;
            await _audioPlayer.setUrl(_currentTrack!.url!);
          }
        }
        // Check if it's time for awakening
        else if (_currentTrackIndex >= _tracks.length ||
            (_cumulativeMilliseconds >=
                    (totalSessionMs -
                        _awakeningDuration -
                        5000) && // 5 second buffer
                _currentTrack != _awakeningTrack)) {
          print('Time for awakening, moving to awakening track');
          _currentTrack = _awakeningTrack;
          await _audioPlayer.setUrl(_currentTrack!.url!);
        }
        // If we're done with awakening
        else if (_currentTrack == _awakeningTrack) {
          print('Finished awakening, ending session');
          _isPlaying = false;
          state = AsyncValue.data(state.value);
          return;
        }
        // Otherwise, play next suggestion
        else if (_currentTrackIndex < _tracks.length) {
          print('Playing next suggestion');
          _currentTrack = _tracks[_currentTrackIndex];
          _currentTrackIndex++;
          await _audioPlayer.setUrl(_currentTrack!.url!);
        }
      } else {
        // Non-hypnotherapy simple sequence
        if (_currentTrackIndex >= _tracks.length) {
          _isPlaying = false;
          state = AsyncValue.data(state.value);
          return;
        }
        _currentTrack = _tracks[_currentTrackIndex];
        _currentTrackIndex++;
        await _audioPlayer.setUrl(_currentTrack!.url!);
      }

      if (_currentTrack == null) {
        _isPlaying = false;
        state = AsyncValue.data(state.value);
        return;
      }

      _sessionStartTime = DateTime.now();
      _ensureTimerIsRunning();

      print('Set current track: ${_currentTrack!.id}');
      await _updateSession();

      if (_isPlaying) {
        // Play both audio sources simultaneously
        await Future.wait([
          _audioPlayer.play(),
          _audioService.playBackgroundAudio()
        ]);
      }

      state = AsyncValue.data(state.value);
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

  Future<void> _updateSession() async {
    // Record the track as played right before it starts playing
    if (state.value != null && _currentTrack != null) {
      final playedTrack = PlayedTrack(
        trackId: _currentTrack!.id!,
        uid: _uid,
        sessionId: state.value!.id,
        text: _currentTrack!.text,
        duration: _currentTrack!.duration,
        words: _currentTrack!.words,
        created: DateTime.now().millisecondsSinceEpoch,
        startedTime: _cumulativeMilliseconds,
      );
      final updatedSession = state.value!.copyWith(
        playedTracks: [...(state.value!.playedTracks ?? []), playedTrack],
      );
      await _firestoreService.updateSession(updatedSession);
      state = AsyncValue.data(updatedSession);
    }
  }

  Future<void> playCombinedAudio() async {
    if (!mounted) return;

    try {
      // Set playing state first to update UI immediately
      _isPlaying = true;
      state = AsyncValue.data(state.value);
      print('Playing combined audio');
      
      // Ensure we have a track to play
      if (_currentTrack == null) {
        await _playNextTrack();
      }
      
      if (_currentTrack != null) {
        // Start both audio sources simultaneously
        await Future.wait([
          _audioPlayer.play(),
          _audioService.playBackgroundAudio()
        ]);
        
        // Adjust session start time based on accumulated time
        if (_sessionStartTime == null) {
          _sessionStartTime = DateTime.now();
        } else {
          _sessionStartTime = DateTime.now()
              .subtract(Duration(milliseconds: _cumulativeMilliseconds));
        }
        
        _ensureTimerIsRunning();
      } else {
        // If we still don't have a track, revert playing state
        _isPlaying = false;
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
      // Set paused state first to update UI immediately
      _isPlaying = false;
      state = AsyncValue.data(state.value);
      
      // Pause both audio sources simultaneously
      await Future.wait([
        _audioPlayer.pause(),
        _audioService.pauseBackgroundAudio()
      ]);

      // Store current progress before pausing
      if (_sessionStartTime != null) {
        final pauseTime = DateTime.now();
        final elapsed = pauseTime.difference(_sessionStartTime!).inMilliseconds;
        _cumulativeMilliseconds = elapsed;
      }
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  Future<void> stopAllAudio() async {
    try {
      _isPlaying = false;
      _timer?.cancel();
      
      // Stop playback first
      await _audioPlayer.stop();
      await _audioService.pauseBackgroundAudio();  // Just pause background, don't stop
      
      // Reset state
      _cumulativeMilliseconds = 0;
      _sessionStartTime = null;
      _currentTrack = null;
      
      // Only dispose and recreate the voice player
      await _disposeAudioPlayer();
      _initAudioPlayer();
      
      state = AsyncValue.data(state.value);
    } catch (e) {
      print('Error stopping all audio: $e');
    }
  }

  void clearState() {
    print('Clearing trance state');
    
    // Stop and dispose audio first
    stopAllAudio();  // This will handle all audio cleanup and reinit the player
    
    // Reset all state variables
    _isLoadingAudio = true;
    _sessionStartTime = null;
    _tracks = [];
    _currentTrackIndex = 0;
    _currentTopic = null;
    _inductionTrack = null;
    _awakeningTrack = null;
    _inductionDuration = 0;
    _awakeningDuration = 0;
  }

  @override
  void dispose() {
    print('Disposing trance state');
    _timer?.cancel();
    
    // Only dispose the voice player
    _disposeAudioPlayer();
    _audioService.pauseBackgroundAudio();  // Just pause background audio
    
    super.dispose();
  }

  Future<void> togglePlayPause() async {
    if (!mounted) return;
    
    if (_isPlaying) {
      await pauseCombinedAudio();
    } else {
      await playCombinedAudio();
    }
  }

  Future<void> setBackgroundVolume(double volume) async {
    _backgroundVolume = volume;
    await _audioService.setBackgroundVolume(volume);
    state = AsyncValue.data(state.value);
  }

  Future<void> setVoiceVolume(double volume) async {
    _voiceVolume = volume;
    await _audioPlayer.setVolume(volume);
    state = AsyncValue.data(state.value);
  }
}
