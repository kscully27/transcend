import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum IntentionSelectionType {
  none,
  goals,
  custom,
  previous,
  default_intention
}

final intentionSelectionProvider = StateNotifierProvider<IntentionSelectionNotifier, IntentionSelectionType>((ref) {
  return IntentionSelectionNotifier();
});

class IntentionSelectionNotifier extends StateNotifier<IntentionSelectionType> {
  IntentionSelectionNotifier() : super(IntentionSelectionType.none) {
    _loadSavedSelection();
  }

  Future<void> _loadSavedSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSelection = prefs.getString('intention_selection_type');
    if (savedSelection != null) {
      state = IntentionSelectionType.values.firstWhere(
        (type) => type.toString() == savedSelection,
        orElse: () => IntentionSelectionType.none,
      );
    }
  }

  Future<void> setSelection(IntentionSelectionType type) async {
    state = type;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('intention_selection_type', type.toString());
  }

  void clearSelection() {
    state = IntentionSelectionType.none;
  }
} 