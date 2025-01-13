import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/models/track.model.dart';
import 'package:trancend/src/models/trance.model.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/providers/auth_provider.dart';

// Provide the FirestoreService instance
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreServiceAdapter();
});

final tranceStateProvider = StateNotifierProvider<TranceState, AsyncValue<Session>>((ref) {
  final auth = ref.watch(userProvider);
  final user = auth.value;
  return TranceState(ref.watch(firestoreServiceProvider), user?.uid);
});

class TranceState extends StateNotifier<AsyncValue<Session>> {
  final FirestoreService _firestoreService;
  final String? _uid;
  final _audioPlayer = AudioPlayer();
  Timer? _timer;
  bool _isPlaying = false;
  int _currentMillisecond = 0;
  Track? _currentTrack;
  List<String> _trackIds = [];
  Topic? _currentTopic;

  TranceState(this._firestoreService, this._uid) : super(const AsyncValue.loading());

  bool get isPlaying => _isPlaying;
  int get currentMillisecond => _currentMillisecond;
  Track? get currentTrack => _currentTrack;

  Future<void> startTranceSession({
    required Topic topic,
    required TranceMethod tranceMethod,
  }) async {
    print('Starting trance session');
    if (_uid == null) {
      print('User not authenticated');
      state = AsyncValue.error('User not authenticated', StackTrace.current);
      return;
    }

    try {
      state = const AsyncValue.loading();
      _currentTopic = topic;
      
      final session = Session(
        id: null,
        uid: _uid,
        topicId: topic.id,
        startTime: DateTime.now().millisecondsSinceEpoch,
        isComplete: false
      );
      print('Session: ${session}');
      final createdSession = await _firestoreService.createSession(session);
      print('Created session: ${createdSession.toJson()}');
      _startTimer();
      state = AsyncValue.data(createdSession);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _currentMillisecond = _audioPlayer.position.inMilliseconds;
      // print('Current millisecond: ${_currentMillisecond}');
      state.whenData((session) {
        // print('Updating session: ${session}');
        state = AsyncValue.data(session);
      });
    });
  }

  Future<void> _playNextTrack() async {
    print('Playing next track');
    try {
      _isPlaying = true;
      
      if (_trackIds.isEmpty && _currentTopic != null) {
        // Get tracks for current topic
        final tracks = await _firestoreService.getTracksFromTopic(_currentTopic!);
        _trackIds = tracks.map((t) => t.id!).toList();
      }

      if (_trackIds.isNotEmpty) {
        // Get random track
        final trackId = _trackIds.removeAt(0);
        final tracks = await _firestoreService.getTracksFromTopic(_currentTopic!);
        _currentTrack = tracks.firstWhere((t) => t.id == trackId);
        
        if (_currentTrack?.url != null) {
          await _audioPlayer.setUrl(_currentTrack!.url!);
          await _audioPlayer.play();
        }
      }
      
    } catch (e) {
      print('Error playing next track: $e');
    }
  }

  Future<void> togglePlayPause() async {
    print('Toggling play/pause from: $_isPlaying');
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        _isPlaying = false;
        _timer?.cancel();
      } else {
        await _audioPlayer.play();
        _isPlaying = true;
        _startTimer();
      }
      // Force a state update to trigger UI refresh
      state = AsyncValue.data(state.value!);
    } catch (e) {
      print('Error toggling play/pause: $e');
    }
  }

  Future<void> loadPreTrance({
    required Topic topic,
    required TranceMethod tranceMethod,
  }) async {
    try {
      print('Loading pre-trance');
      state = const AsyncValue.loading();
      _currentTopic = topic;
      print('Current topic: ${_currentTopic}');
      // Get tracks for current topic
      final tracks = await _firestoreService.getTracksFromTopic(topic);
      // print('Tracks: ${tracks.length}');
      _trackIds = tracks.map((t) => t.id!).toList();
      print('Tracks: ${_trackIds.length}');
      if (_trackIds.isNotEmpty) {
        await _playNextTrack();
      }
      
      state = AsyncValue.data(Session(
        topicId: topic.id,
        startTime: DateTime.now().millisecondsSinceEpoch,
        isComplete: false
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
} 