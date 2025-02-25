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

  Future<void> _loadSavedSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSelection = prefs.getString('intention_selection_type');
    final savedGoals = prefs.getStringList('selected_goal_ids');
    final savedCustomIntention = prefs.getString('custom_intention');
    
    if (savedSelection != null) {
      final type = IntentionSelectionType.values.firstWhere(
        (type) => type.toString() == savedSelection,
        orElse: () => IntentionSelectionType.none,
      );
      state = IntentionSelectionState(
        type: type,
        selectedGoalIds: savedGoals?.toSet() ?? {},
        customIntention: savedCustomIntention,
      );
    }
  }

  Future<void> setSelection(IntentionSelectionType type) async {
    state = state.copyWith(type: type);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('intention_selection_type', type.toString());
  }

  Future<void> setSelectedGoals(Set<String> goals) async {
    state = state.copyWith(selectedGoalIds: goals);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selected_goal_ids', goals.toList());
  }

  Future<void> setCustomIntention(String intention) async {
    state = state.copyWith(customIntention: intention);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_intention', intention);
  }

  void clearSelection() {
    state = IntentionSelectionState(type: IntentionSelectionType.none, selectedGoalIds: {});
  }
} 