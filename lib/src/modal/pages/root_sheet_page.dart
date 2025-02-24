import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/pages/sessions/intention_content.dart';
import 'package:trancend/src/pages/sessions/modality_select.dart';
import 'package:trancend/src/pages/sessions/previous_intentions.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// Provider to hold the page index notifier
final pageIndexNotifierProvider = Provider<ValueNotifier<int>>((ref) {
  return ValueNotifier<int>(0);
});

// Provider to track the previous page index
final previousPageIndexProvider = StateProvider<int>((ref) => 0);

class RootSheetPage {
  const RootSheetPage._();

  static WoltModalSheetPage build(BuildContext context) {
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: false,
      child: Consumer(
        builder: (context, ref, _) {
          return IntentionContent(
            tranceMethod: TranceMethod.values.first,
            onContinue: (intention) {
              // When default intention is selected, go to modality page
              final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
              ref.read(previousPageIndexProvider.notifier).state = 0; // Track that we came from root page
              pageIndexNotifier.value = 3; // Index of ModalitySelectPage
            },
            onGoalsSelected: (goals) {
              // When goals are selected, go to modality page
              final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
              ref.read(previousPageIndexProvider.notifier).state = 0; // Track that we came from root page
              pageIndexNotifier.value = 3; // Index of ModalitySelectPage
            },
            initialCustomIntention: null,
            onBack: null,
            selectedGoalIds: {},
            isCustomMode: false,
          );
        },
      ),
    );
  }
}

class CustomIntentionPage {
  const CustomIntentionPage._();

  static WoltModalSheetPage build(BuildContext context) {
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: true,
      pageTitle: const Center(
        child: Text(
          'Create Your Intention',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      leadingNavBarWidget: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () {
              final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
              pageIndexNotifier.value = 0;
            },
          );
        },
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final intentionState = ref.watch(intentionSelectionProvider);
          final pageIndexNotifier = ref.watch(pageIndexNotifierProvider);
          
          return IntentionContent(
            tranceMethod: TranceMethod.values.first,
            onContinue: (intention) {
              // When custom intention is submitted, go to modality page
              ref.read(previousPageIndexProvider.notifier).state = 1; // Track that we came from custom page
              pageIndexNotifier.value = 3; // Index of ModalitySelectPage
            },
            onGoalsSelected: (goals) {
              // Handle goals selection
              debugPrint('Selected goals: $goals');
            },
            initialCustomIntention: '',
            onBack: () {
              pageIndexNotifier.value = 0;
            },
            selectedGoalIds: intentionState.selectedGoalIds,
            isCustomMode: true,
          );
        },
      ),
    );
  }
}

class PreviousIntentionsPage {
  const PreviousIntentionsPage._();

  static WoltModalSheetPage build(BuildContext context) {
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: true,
      pageTitle: const Center(
        child: Text(
          'Previous Intentions',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      leadingNavBarWidget: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () {
              final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
              pageIndexNotifier.value = 0;
            },
          );
        },
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final pageIndexNotifier = ref.watch(pageIndexNotifierProvider);
          
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: PreviousIntentions(
              onBack: () {
                pageIndexNotifier.value = 0;
              },
              onIntentionSelected: (intention) {
                // When previous intention is selected, go to modality page
                ref.read(previousPageIndexProvider.notifier).state = 2; // Track that we came from previous page
                pageIndexNotifier.value = 3; // Index of ModalitySelectPage
              },
            ),
          );
        },
      ),
    );
  }
}

class ModalitySelectPage {
  const ModalitySelectPage._();

  static WoltModalSheetPage build(BuildContext context) {
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: true,
      pageTitle: const Center(
        child: Text(
          'Select Modality',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      leadingNavBarWidget: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () {
              final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
              // Go back to the page we came from
              final previousPage = ref.read(previousPageIndexProvider);
              pageIndexNotifier.value = previousPage;
            },
          );
        },
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final pageIndexNotifier = ref.watch(pageIndexNotifierProvider);
          
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ModalitySelect(
              onBack: () {
                // Go back to the page we came from
                final previousPage = ref.read(previousPageIndexProvider);
                pageIndexNotifier.value = previousPage;
              },
              onSelectMethod: (method, index) {
                // Handle method selection
                debugPrint('Selected method: $method at index $index');
                Navigator.of(context).pop();
              },
              selectedMethod: null,
              selectedIndex: null,
            ),
          );
        },
      ),
    );
  }
}
