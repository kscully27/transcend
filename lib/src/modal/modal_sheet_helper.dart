import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/modal/pages/root_sheet_page.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';
import 'package:trancend/src/providers/selected_modality_provider.dart' as modality_provider;
import 'package:trancend/src/providers/trance_settings_provider.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
import 'package:trancend/src/ui/helpers/modal_navigation_helper.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A helper class to show a modal sheet with consistent styling
class ModalSheetHelper {
  const ModalSheetHelper._();

  /// Shows a modal sheet with the intention selection flow
  /// This is the main method to use for showing the modal sheet
  static Future<void> showModalSheet(
    BuildContext context, {
    int initialPage = 0,
  }) async {
    // Get the container for provider operations
    final container = ProviderScope.containerOf(context);
    
    // Schedule provider updates for after the current build phase
    // to avoid build-time modifications
    Future.microtask(() {
      // Use the safeExecution method for better error handling
      ModalNavigationHelper.safeExecution(() {
        // Reset modality selection
        final modalityNotifier = container.read(modality_provider.selectedModalityProvider.notifier);
        if (modalityNotifier.mounted) {
          modalityNotifier.reset(); // Use the safer reset method
        }
        
        // Only clear trance method if the provider is still mounted
        final tranceSettingsNotifier = container.read(tranceSettingsProvider.notifier);
        if (tranceSettingsNotifier.mounted) {
          tranceSettingsNotifier.clearTranceMethod();
        }
        
        // If we're navigating directly to the modality page (index 3), ensure intention selection is initialized
        if (initialPage == 3) {
          // Initialize intention selection provider with default values if needed
          final intentionNotifier = container.read(intentionSelectionProvider.notifier);
          if (intentionNotifier.mounted) {
            // Ensure there's at least a default selection type so the flow works correctly
            if (container.read(intentionSelectionProvider).type == IntentionSelectionType.none) {
              intentionNotifier.setSelection(IntentionSelectionType.default_intention);
            }
          }
          
          // Set the previous page to 0 (root page)
          container.read(previousPageIndexProvider.notifier).state = 0;
        }
      }, 'Error initializing providers in showModalSheet');
    });
    
    // Set the initial page
    ValueNotifier<int> pageIndexNotifier;
    try {
      pageIndexNotifier = container.read(pageIndexNotifierProvider);
      pageIndexNotifier.value = initialPage;
    } catch (e) {
      // If we can't access the existing notifier, create a new one
      debugPrint('Creating new page index notifier: $e');
      pageIndexNotifier = ValueNotifier(initialPage);
    }
    
    final pageListBuilderNotifier = ValueNotifier<WoltModalSheetPageListBuilder>(
      (context) => [
        RootSheetPage.build(context),
        CustomIntentionPage.build(context),
        PreviousIntentionsPage.build(context),
        ModalitySelectPage.build(context),
        TranceSettingsModalPage.build(context),
        HypnotherapyMethodsPage.build(context),
        SoundscapesPage.build(context),
        BreathingMethodsPage.build(context),
        MeditationMethodsPage.build(context),
      ]
    );

    // Keep track of whether the modal was closed to prevent accessing providers after dismissal
    bool wasModalDismissed = false;

    await Navigator.of(context).push(
      WoltModalSheetRoute(
        pageIndexNotifier: pageIndexNotifier,
        pageListBuilderNotifier: pageListBuilderNotifier,
        onModalDismissedWithBarrierTap: () {
          wasModalDismissed = true;
          Navigator.of(context).pop();
        },
        onModalDismissedWithDrag: () {
          wasModalDismissed = true;
          Navigator.of(context).pop();
        },
        modalBarrierColor: Colors.transparent,
        barrierDismissible: true,
        enableDrag: true,
        useSafeArea: true,
        pageContentDecorator: (child) => pageContentDecorator(child),
      ),
    );
  }

  /// Alias for showModalSheet for backward compatibility
  static Future<void> showIntentionSheet(
    BuildContext context, {
    int initialPage = 0,
  }) async {
    return showModalSheet(context, initialPage: initialPage);
  }

  static Widget pageContentDecorator(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(20),
        backgroundColor: Colors.white.withOpacity(0.1),
        blur: 10,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: child,
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