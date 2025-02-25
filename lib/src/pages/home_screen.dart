import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/modal/modal_sheet_helper.dart';
import 'package:trancend/src/modal/pages/root_sheet_page.dart';
import 'package:trancend/src/pages/day.dart';
import 'package:trancend/src/pages/settings.dart';
import 'package:trancend/src/providers/app_state_provider.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';
import 'package:trancend/src/providers/selected_modality_provider.dart';
import 'package:trancend/src/providers/trance_settings_provider.dart';
import 'package:trancend/src/ui/clay_bottom_nav/clay_bottom_nav.dart';

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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeScreen> {
  int _index = 0;
  bool _isDisposed = false;
  
  @override
  void initState() {
    super.initState();
    
    // Clear selection when sheet is opened - safely with error handling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && mounted) {
        try {
          // Clear intention selection
          ref.read(intentionSelectionProvider.notifier).clearSelection();
          
          // Clear modality selection to ensure it starts blank - only if provider is still mounted
          final tranceNotifier = ref.read(tranceSettingsProvider.notifier);
          if (tranceNotifier.mounted) {
            tranceNotifier.clearTranceMethod();
          }
        } catch (e) {
          // Gracefully handle any provider errors
          print('Error in HomeScreen.initState: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _showSheet(BuildContext context) {
    // Only proceed if not disposed and mounted
    if (_isDisposed || !mounted) return;
    
    try {
      // Reset the selected modality provider to null before showing the sheet
      final modalityNotifier = ref.read(selectedModalityProvider.notifier);
      if (modalityNotifier.mounted) {
        modalityNotifier.reset(); // Use the safer reset method
      }
      
      // Clear the trance method to ensure no modality is selected initially
      final tranceNotifier = ref.read(tranceSettingsProvider.notifier);
      if (tranceNotifier.mounted) {
        tranceNotifier.clearTranceMethod();
      }
      
      // Now show the modal sheet
      ModalSheetHelper.showModalSheet(context, initialPage: 0);
    } catch (e) {
      // Gracefully handle any provider errors
      print('Error in _showSheet: $e');
      
      // Still try to show the modal sheet even if there's an error with the providers
      ModalSheetHelper.showModalSheet(context, initialPage: 0);
    }
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
