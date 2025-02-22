import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bottomsheet_declarative_routing.dart';

class BottomSheetFlowState {
  final bool isOpen;
  final BottomSheetFlowName? flow;
  final int pageIndex;

  const BottomSheetFlowState({
    this.isOpen = false,
    this.flow,
    this.pageIndex = 0,
  });

  BottomSheetFlowState copyWith({
    bool? isOpen,
    BottomSheetFlowName? flow,
    int? pageIndex,
  }) {
    return BottomSheetFlowState(
      isOpen: isOpen ?? this.isOpen,
      flow: flow ?? this.flow,
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BottomSheetFlowState &&
        other.isOpen == isOpen &&
        other.flow == flow &&
        other.pageIndex == pageIndex;
  }

  @override
  int get hashCode => Object.hash(isOpen, flow, pageIndex);
}

/// A notifier that sets the current bottom-sheet flow
class BottomSheetFlowNotifier extends StateNotifier<BottomSheetFlowState> {
  BottomSheetFlowNotifier() : super(const BottomSheetFlowState());

  /// Open a specific flow at a given page index (default 0).
  void openFlow(BottomSheetFlowName flow, {int pageIndex = 0}) {
    state = BottomSheetFlowState(
      isOpen: true,
      flow: flow,
      pageIndex: pageIndex,
    );
  }

  /// Close the bottom sheet
  void closeFlow() {
    state = const BottomSheetFlowState(isOpen: false);
  }

  /// If you want to go to a new page index inside the same flow
  void goToPage(int pageIndex) {
    final current = state;
    if (!current.isOpen || current.flow == null) return;
    state = BottomSheetFlowState(
      isOpen: true,
      flow: current.flow,
      pageIndex: pageIndex,
    );
  }
}

final bottomSheetFlowProvider =
    StateNotifierProvider<BottomSheetFlowNotifier, BottomSheetFlowState>(
  (ref) => BottomSheetFlowNotifier(),
); 