import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trancend/src/providers/base/safe_state_notifier.dart';

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

class IntentionSelectionNotifier extends SafeStateNotifier<IntentionSelectionState> {
  IntentionSelectionNotifier() 
    : super(IntentionSelectionState(
        type: IntentionSelectionType.none, 
        selectedGoalIds: {}
      )) {
    _loadSavedSelection();
  }

  Future<void> _loadSavedSelection() async {
    await safeAsyncUpdate(() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final savedSelection = prefs.getString('intention_selection_type');
        final savedGoals = prefs.getStringList('selected_goal_ids');
        final savedCustomIntention = prefs.getString('custom_intention');
        
        if (savedSelection != null) {
          final type = IntentionSelectionType.values.firstWhere(
            (type) => type.toString() == savedSelection,
            orElse: () => IntentionSelectionType.none,
          );
          safeUpdateState(IntentionSelectionState(
            type: type,
            selectedGoalIds: savedGoals?.toSet() ?? {},
            customIntention: savedCustomIntention,
          ));
        }
      } catch (e) {
        debugPrint('Error loading intention selection: $e');
      }
    });
  }

  Future<void> setSelection(IntentionSelectionType type) async {
    safeUpdateState(state.copyWith(type: type));
    
    await safeAsyncUpdate(() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('intention_selection_type', type.toString());
      } catch (e) {
        debugPrint('Error saving intention selection type: $e');
      }
    });
  }

  Future<void> setSelectedGoals(Set<String> goals) async {
    safeUpdateState(state.copyWith(selectedGoalIds: goals));
    
    await safeAsyncUpdate(() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('selected_goal_ids', goals.toList());
      } catch (e) {
        debugPrint('Error saving selected goals: $e');
      }
    });
  }

  Future<void> setCustomIntention(String intention) async {
    safeUpdateState(state.copyWith(customIntention: intention));
    
    await safeAsyncUpdate(() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('custom_intention', intention);
      } catch (e) {
        debugPrint('Error saving custom intention: $e');
      }
    });
  }

  void clearSelection() {
    safeUpdateState(IntentionSelectionState(
      type: IntentionSelectionType.none, 
      selectedGoalIds: {}
    ));
  }
} 