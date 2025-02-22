import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/pages/day.dart';
import 'package:trancend/src/pages/settings.dart';
import 'package:trancend/src/providers/app_state_provider.dart';
import 'package:trancend/src/ui/clay_bottom_nav/clay_bottom_nav.dart';
import 'package:trancend/src/pages/sessions/start_session.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';
import 'package:trancend/src/pages/sessions/intention_content.dart';
import 'package:trancend/src/models/session.model.dart' as session;
import 'package:trancend/src/pages/sessions/previous_intentions.dart';

class BlurBackground extends StatefulWidget {
  final bool isSheetExpanded;

  const BlurBackground({
    super.key,
    required this.isSheetExpanded,
  });

  @override
  State<BlurBackground> createState() => _BlurBackgroundState();
}

class _BlurBackgroundState extends State<BlurBackground> with SingleTickerProviderStateMixin {
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

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _index = 0;
  bool _isSheetExpanded = false;

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
      if (_isSheetExpanded) {
        Navigator.of(context).pop();
        setState(() {
          _isSheetExpanded = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Clear selection when sheet is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(intentionSelectionProvider.notifier).clearSelection();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    var theme = Theme.of(context);

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: _handleKeyPress,
      child: appState.when(
        data: (data) {
          if (!data.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              Scaffold(
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
                            child: const Center(child: CircularProgressIndicator()),
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
                  unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
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
                      ref.read(intentionSelectionProvider.notifier).clearSelection();
                      final controller = ref.read(sheetControllerProvider);
                      controller.onDismiss = () {
                        if (mounted) {
                          setState(() {
                            _isSheetExpanded = false;
                          });
                        }
                      };
                      controller.showSheet(context);
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (mounted) {
                          setState(() {
                            _isSheetExpanded = true;
                          });
                        }
                      });
                    }
                    // Sheet was closed by the toggle button
                    if (!isOpen && _isSheetExpanded) {
                      setState(() {
                        _isSheetExpanded = false;
                      });
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
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: BlurBackground(isSheetExpanded: _isSheetExpanded),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
