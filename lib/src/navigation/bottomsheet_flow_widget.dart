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
    final pageController = usePageController();
    final sheetIsVisible = useState(false);

    void showOrUpdateSheet(BottomSheetFlowState state) {
      if (!sheetIsVisible.value) {
        // sheet not currently open -> show it
        WoltModalSheet.show<void>(
          context: context,
          pageListBuilder: (modalContext) => buildFlowPages(
            modalContext, 
            state.flow!, 
            pageIndex: state.pageIndex,
          ),
          modalBarrierColor: Colors.black54,
          barrierDismissible: true,
          onModalDismissedWithBarrierTap: () {
            ref.read(bottomSheetFlowProvider.notifier).closeFlow();
            sheetIsVisible.value = false;
            Navigator.of(context).pop();
          },
          useSafeArea: true,
          useRootNavigator: true,
        ).then((_) {
          // user closed the sheet => update provider
          ref.read(bottomSheetFlowProvider.notifier).closeFlow();
          sheetIsVisible.value = false;
        });
        sheetIsVisible.value = true;
      } else {
        // sheet is open => update pages
        final pages = buildFlowPages(context, state.flow!, pageIndex: state.pageIndex);
        pageController.jumpToPage(state.pageIndex);
      }
    }

    // Listen to bottomSheetFlowProvider changes
    ref.listen<BottomSheetFlowState>(
      bottomSheetFlowProvider, 
      (prev, next) {
        // We only do something if `isOpen` changed or flow changed
        if (next.isOpen && next.flow != null) {
          showOrUpdateSheet(next);
        } else {
          // isOpen == false => close
          if (sheetIsVisible.value) {
            Navigator.of(context).pop(); // close the sheet
          }
        }
      },
    );

    useEffect(() {
      return () {
        pageController.dispose();
      };
    }, []);

    // We just show the "child" in normal circumstances
    return child;
  }
} 