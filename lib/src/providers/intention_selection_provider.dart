import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum IntentionSelectionType {
  none,
  goals,
  custom,
  previous,
  default_intention
}

class IntentionSelectionState {
  final IntentionSelectionType type;
  final Set<String> selectedGoalIds;
  final String? customIntention;

  IntentionSelectionState({
    required this.type,
    required this.selectedGoalIds,
    this.customIntention,
  });

  IntentionSelectionState copyWith({
    IntentionSelectionType? type,
    Set<String>? selectedGoalIds,
    String? customIntention,
  }) {
    return IntentionSelectionState(
      type: type ?? this.type,
      selectedGoalIds: selectedGoalIds ?? this.selectedGoalIds,
      customIntention: customIntention ?? this.customIntention,
    );
  }
}

final intentionSelectionProvider = StateNotifierProvider<IntentionSelectionNotifier, IntentionSelectionState>((ref) {
  return IntentionSelectionNotifier();
});

class IntentionSelectionNotifier extends StateNotifier<IntentionSelectionState> {
  IntentionSelectionNotifier() : super(IntentionSelectionState(type: IntentionSelectionType.none, selectedGoalIds: {})) {
    _loadSavedSelection();
  }
  
  // Track safety status
  bool _isSafeToUse = true;
  
  // Safe state update method
  void _safeUpdateState(IntentionSelectionState newState) {
    if (!mounted || !_isSafeToUse) return;
    state = newState;
  }
  
  @override
  void dispose() {
    _isSafeToUse = false;
    super.dispose();
  }

  Future<void> _loadSavedSelection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedSelection = prefs.getString('intention_selection_type');
      final savedGoals = prefs.getStringList('selected_goal_ids');
      final savedCustomIntention = prefs.getString('custom_intention');
      
      if (!mounted || !_isSafeToUse) return; // Check if safe to use
      
      if (savedSelection != null) {
        final type = IntentionSelectionType.values.firstWhere(
          (type) => type.toString() == savedSelection,
          orElse: () => IntentionSelectionType.none,
        );
        _safeUpdateState(IntentionSelectionState(
          type: type,
          selectedGoalIds: savedGoals?.toSet() ?? {},
          customIntention: savedCustomIntention,
        ));
      }
    } catch (e) {
      print('Error loading intention selection: $e');
    }
  }

  Future<void> setSelection(IntentionSelectionType type) async {
    if (!mounted || !_isSafeToUse) return;
    
    _safeUpdateState(state.copyWith(type: type));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('intention_selection_type', type.toString());
    } catch (e) {
      print('Error saving intention selection type: $e');
    }
  }

  Future<void> setSelectedGoals(Set<String> goals) async {
    if (!mounted || !_isSafeToUse) return;
    
    _safeUpdateState(state.copyWith(selectedGoalIds: goals));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('selected_goal_ids', goals.toList());
    } catch (e) {
      print('Error saving selected goals: $e');
    }
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

  void clearSelection() {
    if (!mounted || !_isSafeToUse) return;
    
    _safeUpdateState(IntentionSelectionState(
      type: IntentionSelectionType.none, 
      selectedGoalIds: {}
    ));
  }
} 