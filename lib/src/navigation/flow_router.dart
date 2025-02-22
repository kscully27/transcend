import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The possible flow paths in the app (similar to your BLoC 'ModalSheetVisibleState').
enum FlowPathName {
  none,
  defaultIntentionFlow,
  customIntentionFlow,
  previousIntentionsFlow,
  goalsFlow,
}

/// A simple model containing the current path and (optionally) a page index.
class FlowRouterState {
  final FlowPathName path;
  final int pageIndex;
  FlowRouterState({required this.path, required this.pageIndex});
}

/// The Riverpod "routing" notifier that updates our FlowRouterState.
class FlowRouterNotifier extends StateNotifier<FlowRouterState> {
  FlowRouterNotifier() : super(FlowRouterState(path: FlowPathName.none, pageIndex: 0));

  /// Switch to the Default Intention Flow
  void showDefaultIntentionFlow() {
    state = FlowRouterState(path: FlowPathName.defaultIntentionFlow, pageIndex: 0);
  }

  /// Switch to the Custom Intention Flow
  void showCustomIntentionFlow() {
    state = FlowRouterState(path: FlowPathName.customIntentionFlow, pageIndex: 0);
  }

  /// Switch to the "previous intentions" flow
  void showPreviousIntentionsFlow() {
    state = FlowRouterState(path: FlowPathName.previousIntentionsFlow, pageIndex: 0);
  }

  /// Switch to a "goals" flow
  void showGoalsFlow() {
    state = FlowRouterState(path: FlowPathName.goalsFlow, pageIndex: 0);
  }

  /// Reset to "none" or home screen
  void closeFlow() {
    state = FlowRouterState(path: FlowPathName.none, pageIndex: 0);
  }

  /// If you ever need to jump to a specific page in a multi-page flow, set index:
  void setPageIndex(int pageIndex) {
    state = FlowRouterState(path: state.path, pageIndex: pageIndex);
  }
}

/// A provider for the router state (FlowRouterState).
final flowRouterProvider = StateNotifierProvider<FlowRouterNotifier, FlowRouterState>(
  (ref) => FlowRouterNotifier(),
); 