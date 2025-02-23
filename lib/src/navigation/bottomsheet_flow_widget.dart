import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'bottomsheet_flow_notifier.dart';
import 'bottomsheet_declarative_routing.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A widget that listens to bottom sheet flow state changes and shows/updates the sheet accordingly
class BottomSheetFlowWidget extends HookConsumerWidget {
  const BottomSheetFlowWidget({
    super.key, 
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetIsVisible = useState(false);
    final currentFlow = useState<BottomSheetFlowName?>(null);
    final pageIndexNotifier = useState(0);
    final pageListBuilderNotifier = useState<WoltModalSheetPageListBuilder>(
      (context) => buildFlowPages(context, BottomSheetFlowName.defaultIntentionFlow),
    );

    void showOrUpdateSheet(BottomSheetFlowState state) {
      if (!sheetIsVisible.value) {
        // sheet not currently open -> show it
        pageIndexNotifier.value = state.pageIndex;
        pageListBuilderNotifier.value = (context) => buildFlowPages(
          context, 
          state.flow!, 
          pageIndex: pageIndexNotifier.value,
        );
        
        Navigator.of(context).push(
          WoltModalSheetRoute(
            pageIndexNotifier: ValueNotifier(pageIndexNotifier.value),
            pageListBuilderNotifier: ValueNotifier(pageListBuilderNotifier.value),
            modalBarrierColor: Colors.black54,
            barrierDismissible: true,
            onModalDismissedWithBarrierTap: () {
              ref.read(bottomSheetFlowProvider.notifier).closeFlow();
              sheetIsVisible.value = false;
              currentFlow.value = null;
              Navigator.of(context).pop();
            },
            onModalDismissedWithDrag: () {
              ref.read(bottomSheetFlowProvider.notifier).closeFlow();
              sheetIsVisible.value = false;
              currentFlow.value = null;
              Navigator.of(context).pop();
            },
            useSafeArea: true,
            enableDrag: true,
            modalDecorator: (child) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20.0 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: child,
              );
            },
          ),
        ).then((_) {
          // Handle cleanup when sheet is closed
          ref.read(bottomSheetFlowProvider.notifier).closeFlow();
          sheetIsVisible.value = false;
          currentFlow.value = null;
        });
        
        sheetIsVisible.value = true;
        currentFlow.value = state.flow;
      } else if (currentFlow.value != null && currentFlow.value == state.flow) {
        // Only update if we're in the same flow
        pageListBuilderNotifier.value = (context) => buildFlowPages(
          context, 
          state.flow!, 
          pageIndex: state.pageIndex,
        );
        pageIndexNotifier.value = state.pageIndex;
      }
    }

    // Listen to bottomSheetFlowProvider changes
    ref.listen<BottomSheetFlowState>(
      bottomSheetFlowProvider, 
      (prev, next) {
        if (next.isOpen && next.flow != null) {
          showOrUpdateSheet(next);
        } else {
          // isOpen == false => close
          if (sheetIsVisible.value) {
            Navigator.of(context).pop(); // close the sheet
            currentFlow.value = null;
          }
        }
      },
    );

    // We just show the "child" in normal circumstances
    return child;
  }
} 