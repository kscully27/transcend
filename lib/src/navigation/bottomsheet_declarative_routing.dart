import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/pages/sessions/intention_content.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';

/// All bottom-sheet flows you want to support.
enum BottomSheetFlowName {
  defaultIntentionFlow,
  customIntentionFlow,
  previousIntentionsFlow,
  goalsFlow,
}

/// Produces a list of pages for the given flow. We use WoltModalSheetPage, not SliverWoltModalSheetPage.
List<WoltModalSheetPage> buildFlowPages(
  BuildContext context, 
  BottomSheetFlowName flow, {
  int pageIndex = 0,
}) {
  // A sample bottom-sheet page for "Default Intention Flow"
  WoltModalSheetPage intentionSelectPage(BuildContext context) => WoltModalSheetPage(
    hasSabGradient: false,
    isTopBarLayerAlwaysVisible: true,
    backgroundColor: Colors.white70,
    surfaceTintColor: Colors.white,
    hasTopBarLayer: false,
    child: IntentionContent(
      tranceMethod: TranceMethod.values.first,
      onContinue: (intention) => debugPrint('intention: $intention'),
      onGoalsSelected: (goals) => debugPrint('goals: $goals'),
      initialCustomIntention: 'custom intention',
      onBack: null,
      selectedGoalIds: {},
      isCustomMode: false,
    ),
  );

  // A sample bottom-sheet page for "Custom Intention Flow"
  WoltModalSheetPage customIntentionPage(BuildContext context) => WoltModalSheetPage(
    hasSabGradient: false,
    isTopBarLayerAlwaysVisible: true,
    pageTitle: const Text('Custom Intention Page'),
    backgroundColor: Colors.white70,
    surfaceTintColor: Colors.white,
    hasTopBarLayer: false,
    child: Consumer(
      builder: (context, ref, _) {
        final intentionState = ref.watch(intentionSelectionProvider);
        return IntentionContent(
          tranceMethod: TranceMethod.values.first,
          onContinue: (intention) => debugPrint('intention: $intention'),
          onGoalsSelected: (goals) => debugPrint('goals: $goals'),
          initialCustomIntention: 'custom intention',
          onBack: null,
          selectedGoalIds: intentionState.selectedGoalIds,
          isCustomMode: true,
        );
      },
    ),
  );

  // Example "Previous Intentions" page
  WoltModalSheetPage previousIntentionsPage(BuildContext context) => WoltModalSheetPage(
    hasSabGradient: false,
    isTopBarLayerAlwaysVisible: true,
    pageTitle: const Text('Previous Intentions'),
    backgroundColor: Colors.white70,
    surfaceTintColor: Colors.white,
    hasTopBarLayer: false,
    child: const Center(
      child: Text('Here are your previous intentions.'),
    ),
  );

  switch (flow) {
    case BottomSheetFlowName.defaultIntentionFlow:
      return [
        intentionSelectPage(context),
      ];

    case BottomSheetFlowName.customIntentionFlow:
      return [
        customIntentionPage(context),
      ];

    case BottomSheetFlowName.previousIntentionsFlow:
      return [
        previousIntentionsPage(context),
      ];

    case BottomSheetFlowName.goalsFlow:
      return [
        WoltModalSheetPage(
          hasSabGradient: false,
          isTopBarLayerAlwaysVisible: true,
          pageTitle: const Text('Goals Flow'),
          backgroundColor: Colors.white70,
          surfaceTintColor: Colors.white,
          hasTopBarLayer: false,
          child: const Center(child: Text('Goals Flow page...')),
        ),
      ];
  }
} 