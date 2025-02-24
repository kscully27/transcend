import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/modal/pages/root_sheet_page.dart';
import 'package:trancend/src/providers/modal_sheet_provider.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A helper class to show a modal sheet with consistent styling
class ModalSheetHelper {
  static Future<void> showModalSheet(
    BuildContext context, {
    ValueNotifier<int>? pageIndexNotifier,
    int initialPage = 0,
  }) {
    final container = ProviderScope.containerOf(context);
    final notifier = pageIndexNotifier ?? container.read(pageIndexNotifierProvider);
    
    // Set to the specified initial page
    if (notifier != null) {
      notifier.value = initialPage;
    }
    
    return Navigator.of(context).push(
      WoltModalSheetRoute(
        pageIndexNotifier: notifier!,
        pageListBuilderNotifier: ValueNotifier((context) => [
          RootSheetPage.build(context),
          CustomIntentionPage.build(context),
          PreviousIntentionsPage.build(context),
          ModalitySelectPage.build(context),
        ]),
        onModalDismissedWithBarrierTap: () {
          Navigator.of(context).pop();
        },
        onModalDismissedWithDrag: () {
          Navigator.of(context).pop();
        },
        modalBarrierColor: Colors.transparent,
        barrierDismissible: true,
        useSafeArea: true,
        enableDrag: true,
        modalDecorator: (child) {
          return Stack(
            children: [
              const _SheetBackground(),
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
        pageContentDecorator: (child) => Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GlassContainer(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(1), width: .65),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
                      bodyColor: Theme.of(context).colorScheme.shadow,
                      displayColor: Theme.of(context).colorScheme.shadow,
                      decorationColor: Theme.of(context).colorScheme.shadow,
                    ),
                    textSelectionTheme: Theme.of(context).textSelectionTheme.copyWith(
                      cursorColor: Theme.of(context).colorScheme.shadow,
                      selectionColor: Theme.of(context).colorScheme.shadow,
                      selectionHandleColor: Theme.of(context).colorScheme.shadow,
                    ),
                    textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: Theme.of(context).colorScheme.shadow,
                      displayColor: Theme.of(context).colorScheme.shadow,
                      decorationColor: Theme.of(context).colorScheme.shadow,
                    ),
                    listTileTheme: ListTileThemeData(
                      titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.shadow),
                      subtitleTextStyle: TextStyle(color: Theme.of(context).colorScheme.shadow.withOpacity(0.7)),
                      iconColor: Theme.of(context).colorScheme.shadow,
                    ),
                    iconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.shadow,
                    ),
                    buttonTheme: ButtonThemeData(
                      textTheme: ButtonTextTheme.primary,
                      buttonColor: Theme.of(context).colorScheme.shadow,
                    ),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.shadow,
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.shadow,
                      ),
                    ),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetBackground extends StatefulWidget {
  const _SheetBackground();

  @override
  State<_SheetBackground> createState() => _SheetBackgroundState();
}

class _SheetBackgroundState extends State<_SheetBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final route = ModalRoute.of(context)!;
        if (route.animation!.status == AnimationStatus.reverse && _controller.status != AnimationStatus.reverse) {
          _controller.reverse();
        }
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return IgnorePointer(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2.0,
                  sigmaY: 2.0,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.1 * _animation.value),
                ),
              ),
            );
          },
        );
      },
    );
  }
} 