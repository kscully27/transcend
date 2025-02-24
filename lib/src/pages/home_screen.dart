import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/modal/pages/root_sheet_page.dart';
import 'package:trancend/src/pages/day.dart';
import 'package:trancend/src/pages/settings.dart';
import 'package:trancend/src/providers/app_state_provider.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';
import 'package:trancend/src/ui/clay_bottom_nav/clay_bottom_nav.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class BlurBackground extends StatefulWidget {
  final bool isSheetExpanded;

  const BlurBackground({
    super.key,
    required this.isSheetExpanded,
  });

  @override
  State<BlurBackground> createState() => _BlurBackgroundState();
}

class _BlurBackgroundState extends State<BlurBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BlurBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSheetExpanded != oldWidget.isSheetExpanded) {
      if (widget.isSheetExpanded) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _controller.forward();
        });
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2.0,
          sigmaY: 2.0,
        ),
        child: Container(
          color: Theme.of(context).colorScheme.shadow.withOpacity(0.25),
          //  Colors.black.withOpacity(0.2),
        ),
      ),
    );
  }
}

class SheetBackground extends StatefulWidget {
  const SheetBackground();

  @override
  State<SheetBackground> createState() => _SheetBackgroundState();
}

class _SheetBackgroundState extends State<SheetBackground> with SingleTickerProviderStateMixin {
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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeScreen> {
  int _index = 0;
  final ValueNotifier<int> _pageIndexNotifier = ValueNotifier<int>(0);
  final ValueNotifier<WoltModalSheetPageListBuilder> _pageListBuilderNotifier =
      ValueNotifier((context) => [RootSheetPage.build(context)]);

  @override
  void initState() {
    super.initState();
    bool isDisposed = false;
    
    // Clear selection when sheet is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isDisposed && mounted) {
        ref.read(intentionSelectionProvider.notifier).clearSelection();
      }
    });
  }

  @override
  void dispose() {
    _pageIndexNotifier.dispose();
    _pageListBuilderNotifier.dispose();
    super.dispose();
  }

  void _showSheet(BuildContext context) {
    Navigator.of(context).push(
      WoltModalSheetRoute(
        pageIndexNotifier: _pageIndexNotifier,
        pageListBuilderNotifier: _pageListBuilderNotifier,
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
              const SheetBackground(),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final theme = Theme.of(context);

    return appState.when(
      data: (data) {
        if (!data.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          extendBody: true,
          backgroundColor: theme.colorScheme.surface,
          body: Container(
            decoration: AppColors.enableGradients
                ? BoxDecoration(
                    gradient: AppColors.marsBackgroundGradient(context),
                  )
                : null,
            child: _index == 0
                ? data.topics.when(
                    data: (topics) => const Day(),
                    loading: () => Material(
                      color: theme.colorScheme.onSurface,
                      child:
                          const Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stack) =>
                        Center(child: Text('Error loading topics: $error')),
                  )
                : const SettingsPage(),
          ),
          bottomNavigationBar: ClayBottomNavNSheet(
            backgroundColor: theme.colorScheme.surface,
            emboss: false,
            parentColor: theme.colorScheme.surface,
            selectedItemColor: theme.colorScheme.onSurface,
            unselectedItemColor:
                theme.colorScheme.onSurface.withOpacity(0.6),
            sheetOpenIconBoxColor: theme.colorScheme.primary,
            sheetOpenIconColor: theme.colorScheme.onPrimary,
            sheetCloseIconBoxColor: theme.colorScheme.surface,
            sheetCloseIconColor: theme.colorScheme.onSurfaceVariant,
            initialSelectedIndex: _index,
            onTap: (index) {
              setState(() {
                _index = index;
              });
            },
            onSheetToggle: (isOpen) {
              if (isOpen) {
                _showSheet(context);
              }
            },
            sheet: const SizedBox(),
            sheetOpenIcon: Remix.play_large_line,
            sheetCloseIcon: Remix.add_line,
            items: [
              ClayBottomNavItem(
                activeIcon: Remix.home_6_fill,
                icon: Remix.home_6_line,
              ),
              ClayBottomNavItem(
                icon: Remix.user_3_line,
                activeIcon: Remix.user_3_fill,
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
