import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/router/playground_router_delegate.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'dart:ui';

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
    return WoltModalSheetRoute(
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
      modalBarrierColor: Colors.transparent,
      barrierDismissible: true,
      settings: this,
      enableDrag: true,
      useSafeArea: true,
      pageContentDecorator: (child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GlassContainer(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(1), width: .65),
          ),
          child: child,
        ),
      ),
      modalDecorator: (child) {
        return Stack(
          children: [
            Builder(
              builder: (context) {
                final animation = ModalRoute.of(context)!.animation!;
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: animation.value),
                      duration: const Duration(milliseconds: 3000),
                      curve: Curves.easeInOut,
                      builder: (context, opacity, _) {
                        return IgnorePointer(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 2.0,
                              sigmaY: 2.0,
                            ),
                            child: Container(
                              color: Colors.black.withOpacity(0.1 * opacity),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
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
          ],
        );
      },
    );
  }
}
