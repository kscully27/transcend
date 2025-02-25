import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';

class TranceSettingsState {
  final TranceMethod tranceMethod;
  final int sessionDuration;
  final BackgroundSound backgroundSound;
  final HypnotherapyMethod? hypnotherapyMethod;
  final BreathingMethod? breathingMethod;
  final MeditationMethod? meditationMethod;
  final double backgroundVolume;
  final double voiceVolume;
  final IntentionSelectionType intentionType;
  final Set<String> selectedGoalIds;
  final String? customIntention;

  TranceSettingsState({
    required this.tranceMethod,
    required this.sessionDuration,
    required this.backgroundSound,
    this.hypnotherapyMethod,
    this.breathingMethod,
    this.meditationMethod,
    required this.backgroundVolume,
    required this.voiceVolume,
    required this.intentionType,
    required this.selectedGoalIds,
    this.customIntention,
  });

  TranceSettingsState copyWith({
    TranceMethod? tranceMethod,
    int? sessionDuration,
    BackgroundSound? backgroundSound,
    HypnotherapyMethod? hypnotherapyMethod,
    BreathingMethod? breathingMethod,
    MeditationMethod? meditationMethod,
    double? backgroundVolume,
    double? voiceVolume,
    IntentionSelectionType? intentionType,
    Set<String>? selectedGoalIds,
    String? customIntention,
  }) {
    return TranceSettingsState(
      tranceMethod: tranceMethod ?? this.tranceMethod,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      backgroundSound: backgroundSound ?? this.backgroundSound,
      hypnotherapyMethod: hypnotherapyMethod ?? this.hypnotherapyMethod,
      breathingMethod: breathingMethod ?? this.breathingMethod,
      meditationMethod: meditationMethod ?? this.meditationMethod,
      backgroundVolume: backgroundVolume ?? this.backgroundVolume,
      voiceVolume: voiceVolume ?? this.voiceVolume,
      intentionType: intentionType ?? this.intentionType,
      selectedGoalIds: selectedGoalIds ?? this.selectedGoalIds,
      customIntention: customIntention ?? this.customIntention,
    );
  }
}

final tranceSettingsProvider = StateNotifierProvider<TranceSettingsNotifier, TranceSettingsState>((ref) {
  final intentionSelection = ref.watch(intentionSelectionProvider);
  return TranceSettingsNotifier(intentionSelection);
});

class TranceSettingsNotifier extends StateNotifier<TranceSettingsState> {
  TranceSettingsNotifier(IntentionSelectionState intentionSelection) 
    : super(TranceSettingsState(
        tranceMethod: TranceMethod.Hypnosis,
        sessionDuration: 20,
        backgroundSound: BackgroundSound.Waves,
        hypnotherapyMethod: HypnotherapyMethod.Guided,
        breathingMethod: BreathingMethod.BalancedBreathing,
        meditationMethod: MeditationMethod.Mindfulness,
        backgroundVolume: 0.4,
        voiceVolume: 0.8,
        intentionType: intentionSelection.type,
        selectedGoalIds: intentionSelection.selectedGoalIds,
        customIntention: intentionSelection.customIntention,
      )) {
    _loadSavedSettings();
  }

  // A flag to track additional state beyond the built-in mounted property
  bool _isSafeToUse = true;

  Future<void> _loadSavedSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final savedMethod = prefs.getString('trance_method');
      final savedDuration = prefs.getInt('session_duration');
      final savedBackgroundSound = prefs.getString('background_sound');
      final savedHypnoMethod = prefs.getString('hypnotherapy_method');
      final savedBreathingMethod = prefs.getString('breathing_method');
      final savedMeditationMethod = prefs.getString('meditation_method');
      final savedBackgroundVolume = prefs.getDouble('background_volume');
      final savedVoiceVolume = prefs.getDouble('voice_volume');
      final savedCustomIntention = prefs.getString('custom_intention');
      
      if (!mounted || !_isSafeToUse) return; // Safety check
      
      if (savedMethod != null || savedDuration != null || savedBackgroundSound != null || 
          savedHypnoMethod != null || savedBreathingMethod != null || savedMeditationMethod != null ||
          savedBackgroundVolume != null || savedVoiceVolume != null) {
        
        final tranceMethod = savedMethod != null 
            ? TranceMethod.values.firstWhere(
                (type) => type.name == savedMethod,
                orElse: () => TranceMethod.Hypnosis,
              )
            : state.tranceMethod;
        
        final backgroundSound = savedBackgroundSound != null 
            ? BackgroundSound.values.firstWhere(
                (sound) => sound.name == savedBackgroundSound,
                orElse: () => BackgroundSound.Waves,
              )
            : state.backgroundSound;
        
        final hypnotherapyMethod = savedHypnoMethod != null 
            ? HypnotherapyMethod.values.firstWhere(
                (method) => method.name == savedHypnoMethod,
                orElse: () => HypnotherapyMethod.Guided,
              )
            : state.hypnotherapyMethod;
            
        final breathingMethod = savedBreathingMethod != null 
            ? BreathingMethod.values.firstWhere(
                (method) => method.name == savedBreathingMethod,
                orElse: () => BreathingMethod.BalancedBreathing,
              )
            : state.breathingMethod;
            
        final meditationMethod = savedMeditationMethod != null 
            ? MeditationMethod.values.firstWhere(
                (method) => method.name == savedMeditationMethod,
                orElse: () => MeditationMethod.Mindfulness,
              )
            : state.meditationMethod;
        
        if (!mounted || !_isSafeToUse) return; // Check again after async operation
        
        state = state.copyWith(
          tranceMethod: tranceMethod,
          sessionDuration: savedDuration ?? state.sessionDuration,
          backgroundSound: backgroundSound,
          hypnotherapyMethod: hypnotherapyMethod,
          breathingMethod: breathingMethod,
          meditationMethod: meditationMethod,
          backgroundVolume: savedBackgroundVolume ?? state.backgroundVolume,
          voiceVolume: savedVoiceVolume ?? state.voiceVolume,
          customIntention: savedCustomIntention,
        );
      }
    } catch (e) {
      print('Error loading trance settings: $e');
    }
  }

  // Override the dispose method to set our custom flag
  @override
  void dispose() {
    _isSafeToUse = false;
    super.dispose();
  }

  // Safe wrapper for state updates
  void _safeUpdateState(TranceSettingsState newState) {
    if (!mounted || !_isSafeToUse) return; // Skip update if not safe
    state = newState;
  }

  Future<void> setTranceMethod(TranceMethod method) async {
    if (!mounted || !_isSafeToUse) return; // Early return if not safe
    
    _safeUpdateState(state.copyWith(tranceMethod: method));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('trance_method', method.name);
    } catch (e) {
      print('Error saving trance method: $e');
    }
  }

  Future<void> setSessionDuration(int minutes) async {
    if (!mounted || !_isSafeToUse) return;
    
    _safeUpdateState(state.copyWith(sessionDuration: minutes));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('session_duration', minutes);
    } catch (e) {
      print('Error saving session duration: $e');
    }
  }

  Future<void> setBackgroundSound(BackgroundSound sound) async {
    if (!mounted || !_isSafeToUse) return;
    
    _safeUpdateState(state.copyWith(backgroundSound: sound));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('background_sound', sound.name);
    } catch (e) {
      print('Error saving background sound: $e');
    }
  }

  Future<void> setHypnotherapyMethod(HypnotherapyMethod method) async {
    if (!mounted || !_isSafeToUse) return;
    
    _safeUpdateState(state.copyWith(hypnotherapyMethod: method));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('hypnotherapy_method', method.name);
    } catch (e) {
      print('Error saving hypnotherapy method: $e');
    }
  }
  
  Future<void> setBreathingMethod(BreathingMethod method) async {
    if (!mounted || !_isSafeToUse) return;
    
    _safeUpdateState(state.copyWith(breathingMethod: method));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('breathing_method', method.name);
    } catch (e) {
      print('Error saving breathing method: $e');
    }
  }
  
  Future<void> setMeditationMethod(MeditationMethod method) async {
    if (!mounted || !_isSafeToUse) return;
    
    _safeUpdateState(state.copyWith(meditationMethod: method));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('meditation_method', method.name);
    } catch (e) {
      print('Error saving meditation method: $e');
    }
  }

  Future<void> setBackgroundVolume(double volume) async {
    if (!mounted || !_isSafeToUse) return;
    
    _safeUpdateState(state.copyWith(backgroundVolume: volume));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('background_volume', volume);
    } catch (e) {
      print('Error saving background volume: $e');
    }
  }

  Future<void> setVoiceVolume(double volume) async {
    if (!mounted || !_isSafeToUse) return;
    
    _safeUpdateState(state.copyWith(voiceVolume: volume));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('voice_volume', volume);
    } catch (e) {
      print('Error saving voice volume: $e');
    }
  }

  Future<void> setIntentionType(IntentionSelectionType type) async {
    if (!mounted || !_isSafeToUse) return;
    
    _safeUpdateState(state.copyWith(intentionType: type));
  }

  Future<void> setSelectedGoalIds(Set<String> goalIds) async {
    if (!mounted || !_isSafeToUse) return;
    
    _safeUpdateState(state.copyWith(selectedGoalIds: goalIds));
  }

  Future<void> setCustomIntention(String intention) async {
    if (!mounted || !_isSafeToUse) return;
    
    _safeUpdateState(state.copyWith(customIntention: intention));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('custom_intention', intention);
    } catch (e) {
      print('Error saving custom intention: $e');
    }
  }

  /// Clears the trance method selection to ensure it's blank when reopening the modal
  Future<void> clearTranceMethod() async {
    if (!mounted || !_isSafeToUse) return;
    
    // Only update the state in memory, don't write to SharedPreferences
    // This ensures the modality selection appears blank when opening the modal
    // but preserves the user's previous selection in storage for future sessions
    _safeUpdateState(state.copyWith(
      tranceMethod: null // Use null to indicate no selection
    ));
  }
} 