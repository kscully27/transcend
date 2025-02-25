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

  Future<void> _loadSavedSettings() async {
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
  }

  Future<void> setTranceMethod(TranceMethod method) async {
    state = state.copyWith(tranceMethod: method);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('trance_method', method.name);
  }

  Future<void> setSessionDuration(int minutes) async {
    state = state.copyWith(sessionDuration: minutes);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('session_duration', minutes);
  }

  Future<void> setBackgroundSound(BackgroundSound sound) async {
    state = state.copyWith(backgroundSound: sound);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('background_sound', sound.name);
  }

  Future<void> setHypnotherapyMethod(HypnotherapyMethod method) async {
    state = state.copyWith(hypnotherapyMethod: method);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hypnotherapy_method', method.name);
  }
  
  Future<void> setBreathingMethod(BreathingMethod method) async {
    state = state.copyWith(breathingMethod: method);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('breathing_method', method.name);
  }
  
  Future<void> setMeditationMethod(MeditationMethod method) async {
    state = state.copyWith(meditationMethod: method);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('meditation_method', method.name);
  }

  Future<void> setBackgroundVolume(double volume) async {
    state = state.copyWith(backgroundVolume: volume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('background_volume', volume);
  }

  Future<void> setVoiceVolume(double volume) async {
    state = state.copyWith(voiceVolume: volume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('voice_volume', volume);
  }

  Future<void> setIntentionType(IntentionSelectionType type) async {
    state = state.copyWith(intentionType: type);
  }

  Future<void> setSelectedGoalIds(Set<String> goalIds) async {
    state = state.copyWith(selectedGoalIds: goalIds);
  }

  Future<void> setCustomIntention(String intention) async {
    state = state.copyWith(customIntention: intention);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_intention', intention);
  }

  /// Clears the trance method selection to ensure it's blank when reopening the modal
  Future<void> clearTranceMethod() async {
    // Only update the state in memory, don't write to SharedPreferences
    // This ensures the modality selection appears blank when opening the modal
    // but preserves the user's previous selection in storage for future sessions
    state = state.copyWith(
      tranceMethod: null // Use null to indicate no selection
    );
  }
} 