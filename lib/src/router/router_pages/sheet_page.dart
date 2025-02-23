import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/router/playground_router_delegate.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
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
      barrierDismissible: true,
      pageContentDecorator: (child) => GlassContainer(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
      modalDecorator: (child) => TweenAnimationBuilder<double>(
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
      ),
      enableDrag: true,
      showDragHandle: true,
      useSafeArea: true,
      settings: this,
    );
  }
}
