import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/router/playground_router_delegate.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPage extends Page<void> {
  const SheetPage({
    required this.pageIndexNotifier,
    required this.pageListBuilderNotifier,
  }) : super(key: const ValueKey('SheetPage'), name: SheetPage.routeName);

  final ValueNotifier<int> pageIndexNotifier;
  final ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier;

  static const String routeName = 'Modal Sheet';

  @override
  Route<void> createRoute(BuildContext context) {
    return WoltModalSheetRoute<void>(
      pageIndexNotifier: pageIndexNotifier,
      pageListBuilderNotifier: pageListBuilderNotifier,
      onModalDismissedWithDrag: () {
        final container = ProviderScope.containerOf(context);
        container.read(routerProvider.notifier).closeSheet();
      },
      onModalDismissedWithBarrierTap: () {
        final container = ProviderScope.containerOf(context);
        container.read(routerProvider.notifier).closeSheet();
      },
      pageContentDecorator: (child) => child,
      modalDecorator: (child) => child,
      
      // modalTypeBuilder: () => WoltModalType.bottomSheet,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 3500),
      ),
      enableDrag: true,
      showDragHandle: true,
      useSafeArea: true,
      settings: this,
    );
  }
}
