import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/pages/sessions/intention_content.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';
import 'package:trancend/src/providers/selected_modality_provider.dart';
import 'package:trancend/src/providers/trance_settings_provider.dart';
import 'package:trancend/src/ui/helpers/modal_navigation_helper.dart';
import 'package:trancend/src/modal/pages/trance_settings/modal_page_definitions.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// Root page for the trance settings flow
class RootPage {
  const RootPage._();

  /// Build the root page
  static WoltModalSheetPage build(BuildContext context) {
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: false,
      child: Consumer(
        builder: (context, ref, _) {
          final intentionState = ref.watch(intentionSelectionProvider);
          
          // Reset the selected modality to null when the root page is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Use a microtask to avoid potential build phase issues
            Future.microtask(() {
              ModalNavigationHelper.safeExecution(() {
                final notifier = ref.read(selectedModalityProvider.notifier);
                if (notifier.mounted) {
                  notifier.reset();
                }
                
                final tranceNotifier = ref.read(tranceSettingsProvider.notifier);
                if (tranceNotifier.mounted) {
                  tranceNotifier.clearTranceMethod();
                }
              }, 'Error resetting providers in RootPage');
            });
          });
          
          return IntentionContent(
            tranceMethod: TranceMethod.values.first,
            onContinue: (intention) {
              // When default intention is selected, go to modality page
              ModalNavigationHelper.safeExecution(() {
                final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                ref.read(previousPageIndexProvider.notifier).state = PageIndices.rootPage; // Track that we came from root page
                pageIndexNotifier.value = PageIndices.modalitySelectPage; // Index of ModalitySelectPage
              }, 'Error navigating to modality page');
            },
            onGoalsSelected: (goals) {
              // When goals are selected, go to modality page
              // (Note: A 300ms delay is already added in intention_content.dart before this is called)
              ModalNavigationHelper.safeExecution(() {
                final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                ref.read(previousPageIndexProvider.notifier).state = PageIndices.rootPage; // Track that we came from root page
                pageIndexNotifier.value = PageIndices.modalitySelectPage; // Index of ModalitySelectPage
              }, 'Error navigating after goal selection');
            },
            initialCustomIntention: intentionState.customIntention,
            onBack: null,
            selectedGoalIds: intentionState.selectedGoalIds,
            isCustomMode: false,
          );
        },
      ),
    );
  }
} 