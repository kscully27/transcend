import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/pages/sessions/intention_content.dart';
import 'package:trancend/src/pages/sessions/modality_select.dart';
import 'package:trancend/src/pages/sessions/previous_intentions.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';
import 'package:trancend/src/providers/trance_settings_provider.dart';
import 'package:trancend/src/ui/clay/clay_container.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
import 'package:trancend/src/ui/time_slider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// Provider to hold the page index notifier
final pageIndexNotifierProvider = Provider<ValueNotifier<int>>((ref) {
  return ValueNotifier<int>(0);
});

// Provider to track the previous page index
final previousPageIndexProvider = StateProvider<int>((ref) => 0);

// Provider to track the selected modality - initialized as null to ensure no selection initially
final selectedModalityProvider = StateProvider<TranceMethod?>((ref) {
  // When this provider is first accessed, ensure the trance settings are also reset
  ref.read(tranceSettingsProvider.notifier).clearTranceMethod();
  return null; // Always start with null selection
});

class RootSheetPage {
  const RootSheetPage._();

  static WoltModalSheetPage build(BuildContext context) {
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: false,
      child: Consumer(
        builder: (context, ref, _) {
          final intentionState = ref.watch(intentionSelectionProvider);
          
          // Reset the selected modality to null when the root page is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(selectedModalityProvider.notifier).state = null;
            ref.read(tranceSettingsProvider.notifier).clearTranceMethod();
          });
          
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

class CustomIntentionPage {
  const CustomIntentionPage._();

  static WoltModalSheetPage build(BuildContext context) {
    final theme = Theme.of(context);
    
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: true,
      pageTitle: Center(
        child: Text(
          'Create Your Intention',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: theme.colorScheme.shadow,
          ),
        ),
      ),
      leadingNavBarWidget: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: theme.colorScheme.shadow),
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
            initialCustomIntention: intentionState.type == IntentionSelectionType.custom 
                ? intentionState.customIntention 
                : '',
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
    final theme = Theme.of(context);
    
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: true,
      pageTitle: Center(
        child: Text(
          'Previous Intentions',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: theme.colorScheme.shadow,
          ),
        ),
      ),
      leadingNavBarWidget: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: theme.colorScheme.shadow),
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
    final theme = Theme.of(context);
    
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: true,
      pageTitle: Center(
        child: Text(
          'Select Modality',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: theme.colorScheme.shadow,
          ),
        ),
      ),
      leadingNavBarWidget: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: theme.colorScheme.shadow),
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
          final selectedModality = ref.watch(selectedModalityProvider);
          final tranceSettings = ref.watch(tranceSettingsProvider);
          
          // We now check if selectedModality is null and don't fallback to tranceSettings
          // This ensures no selection is shown initially
          
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ModalitySelect(
              onBack: () {
                // Go back to the page we came from
                final previousPage = ref.read(previousPageIndexProvider);
                pageIndexNotifier.value = previousPage;
              },
              onSelectMethod: (method, index) {
                // Store the selected modality
                ref.read(selectedModalityProvider.notifier).state = method;
                
                // Update the trance settings with the selected modality
                ref.read(tranceSettingsProvider.notifier).setTranceMethod(method);
                
                // Navigate to the trance settings page within the modal
                ref.read(previousPageIndexProvider.notifier).state = 3; // Track that we came from modality page
                pageIndexNotifier.value = 4; // Index of TranceSettingsPage
              },
              selectedMethod: selectedModality, // Remove the fallback to tranceSettings.tranceMethod
              selectedIndex: null,
            ),
          );
        },
      ),
    );
  }
}

// New TranceSettingsPage for the modal flow
class TranceSettingsModalPage {
  const TranceSettingsModalPage._();

  static WoltModalSheetPage build(BuildContext context) {
    final theme = Theme.of(context);
    
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: true,
      leadingNavBarWidget: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: theme.colorScheme.shadow),
            onPressed: () {
              final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
              final previousPage = ref.read(previousPageIndexProvider);
              
              // Always go back to modality selection page
              pageIndexNotifier.value = 3; // ModifySelectPage is at index 3
              
              // Make sure to preserve the original page we came from before the modality page
              if (previousPage < 3) {
                // If we have a valid page index before modality page, preserve it
                ref.read(previousPageIndexProvider.notifier).state = previousPage;
              } else {
                // If something went wrong, default to root page
                ref.read(previousPageIndexProvider.notifier).state = 0;
              }
            },
          );
        },
      ),
      trailingNavBarWidget: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: Icon(Remix.equalizer_3_fill, size: 24, color: theme.colorScheme.shadow),
            onPressed: () {
              _showAdvancedSettingsModal(context, ref);
            },
          );
        },
      ),
      pageTitle: Consumer(
        builder: (context, ref, _) {
          final selectedModality = ref.watch(selectedModalityProvider);
          
          return Center(
            child: Text(
              _getMethodTitle(selectedModality ?? TranceMethod.Hypnosis),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: theme.colorScheme.shadow,
              ),
            ),
          );
        },
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final selectedModality = ref.watch(selectedModalityProvider);
          final tranceSettings = ref.watch(tranceSettingsProvider);
          final tranceSettingsNotifier = ref.watch(tranceSettingsProvider.notifier);
          
          // Default to Hypnosis if not set
          final tranceMethod = selectedModality ?? TranceMethod.Hypnosis;
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Session Duration (without title)
                  SizedBox(
                    height: 100,
                    child: _buildDurationSelector(context, ref, tranceMethod),
                  ),
                  const SizedBox(height: 24),

                  // Settings Selection Row
                  _buildMethodSelectionRow(context, ref, tranceMethod, tranceSettings),
                  
                  const SizedBox(height: 32),

                  // Start Session Button
                  Center(
                    child: GlassButton(
                      text: "Start Session",
                      width: double.infinity,
                      height: 60,
                      textColor: theme.colorScheme.shadow,
                      glassColor: Colors.white24,
                      onPressed: () {
                        // TODO: Start the session
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _buildMethodSelectionRow(BuildContext context, WidgetRef ref, TranceMethod tranceMethod, TranceSettingsState tranceSettings) {
    final theme = Theme.of(context);

    // Determine which method selection to display based on trance method
    Widget methodSelection;
    
    if (tranceMethod == TranceMethod.Hypnosis) {
      methodSelection = _buildHypnotherapyMethodSelection(context, ref, tranceSettings);
    } else if (tranceMethod == TranceMethod.Breathe) {
      methodSelection = _buildBreathingMethodSelection(context, ref, tranceSettings);
    } else if (tranceMethod == TranceMethod.Meditation) {
      methodSelection = _buildMeditationMethodSelection(context, ref, tranceSettings);
    } else {
      // For other methods, only show sound selection
      methodSelection = _buildSoundSelection(context, ref, tranceSettings);
    }

    return methodSelection;
  }

  static Widget _buildHypnotherapyMethodSelection(BuildContext context, WidgetRef ref, TranceSettingsState tranceSettings) {
    final theme = Theme.of(context);
    
    return GlassContainer(
      borderRadius: BorderRadius.circular(10),
      backgroundColor: Colors.white.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      border: Border.all(color: theme.colorScheme.shadow, width: .1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Method selection
            GestureDetector(
              onTap: () {
                // Navigate to hypnotherapy methods page
                ref.read(previousPageIndexProvider.notifier).state = 4; // Track current page
                ref.read(pageIndexNotifierProvider).value = 5; // Go to methods page
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      tranceSettings.hypnotherapyMethod?.name ?? 'Guided',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Method',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: .5,
              height: 20,
              color: theme.colorScheme.shadow,
            ),
            
            // Sound selection
            GestureDetector(
              onTap: () {
                // Navigate to soundscapes page
                ref.read(previousPageIndexProvider.notifier).state = 4; // Track current page
                ref.read(pageIndexNotifierProvider).value = 6; // Go to soundscapes page
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      tranceSettings.backgroundSound.name.toUpperCase(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'SoundScape',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  static Widget _buildBreathingMethodSelection(BuildContext context, WidgetRef ref, TranceSettingsState tranceSettings) {
    final theme = Theme.of(context);
    
    return GlassContainer(
      borderRadius: BorderRadius.circular(10),
      backgroundColor: Colors.white.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      border: Border.all(color: theme.colorScheme.shadow, width: .1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Method selection
            GestureDetector(
              onTap: () {
                // Navigate to breathing methods page
                ref.read(previousPageIndexProvider.notifier).state = 4; // Track current page
                ref.read(pageIndexNotifierProvider).value = 7; // Go to breathing methods page
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      breathingMethods[tranceSettings.breathingMethod] ?? 'Balanced breathing',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Method',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: .5,
              height: 20,
              color: theme.colorScheme.shadow,
            ),
            
            // Sound selection
            GestureDetector(
              onTap: () {
                // Navigate to soundscapes page
                ref.read(previousPageIndexProvider.notifier).state = 4; // Track current page
                ref.read(pageIndexNotifierProvider).value = 6; // Go to soundscapes page
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      tranceSettings.backgroundSound.name.toUpperCase(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'SoundScape',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  static Widget _buildMeditationMethodSelection(BuildContext context, WidgetRef ref, TranceSettingsState tranceSettings) {
    final theme = Theme.of(context);
    
    return GlassContainer(
      borderRadius: BorderRadius.circular(10),
      backgroundColor: Colors.white.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      border: Border.all(color: theme.colorScheme.shadow, width: .1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Method selection
            GestureDetector(
              onTap: () {
                // Navigate to meditation methods page
                ref.read(previousPageIndexProvider.notifier).state = 4; // Track current page
                ref.read(pageIndexNotifierProvider).value = 8; // Go to meditation methods page
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      meditationMethods[tranceSettings.meditationMethod] ?? 'Mindfulness',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Method',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: .5,
              height: 20,
              color: theme.colorScheme.shadow,
            ),
            
            // Sound selection
            GestureDetector(
              onTap: () {
                // Navigate to soundscapes page
                ref.read(previousPageIndexProvider.notifier).state = 4; // Track current page
                ref.read(pageIndexNotifierProvider).value = 6; // Go to soundscapes page
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      tranceSettings.backgroundSound.name.toUpperCase(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'SoundScape',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  static Widget _buildSoundSelection(BuildContext context, WidgetRef ref, TranceSettingsState tranceSettings) {
    final theme = Theme.of(context);
    
    return GlassContainer(
      borderRadius: BorderRadius.circular(10),
      backgroundColor: Colors.white.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      border: Border.all(color: theme.colorScheme.shadow, width: .1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            // Navigate to soundscapes page
            ref.read(previousPageIndexProvider.notifier).state = 4; // Track current page
            ref.read(pageIndexNotifierProvider).value = 6; // Go to soundscapes page
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  tranceSettings.backgroundSound.name.toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.shadow,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'SoundScape',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.shadow,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _showAdvancedSettingsModal(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tranceSettings = ref.watch(tranceSettingsProvider);
    final tranceSettingsNotifier = ref.watch(tranceSettingsProvider.notifier);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: ClayContainer(
            height: 300,
            color: Colors.white.withOpacity(0.9),
            borderRadius: 16,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Advanced Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.shadow,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: theme.colorScheme.shadow),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Background Volume
                  Row(
                    children: [
                      Icon(
                        Icons.volume_up,
                        color: theme.colorScheme.shadow,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Background Volume',
                        style: TextStyle(
                          color: theme.colorScheme.shadow,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: tranceSettings.backgroundVolume,
                    onChanged: (value) {
                      tranceSettingsNotifier.setBackgroundVolume(value);
                    },
                    activeColor: theme.colorScheme.primary,
                    inactiveColor: theme.colorScheme.shadow.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),

                  // Voice Volume
                  Row(
                    children: [
                      Icon(
                        Icons.mic,
                        color: theme.colorScheme.shadow,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Voice Volume',
                        style: TextStyle(
                          color: theme.colorScheme.shadow,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: tranceSettings.voiceVolume,
                    onChanged: (value) {
                      tranceSettingsNotifier.setVoiceVolume(value);
                    },
                    activeColor: theme.colorScheme.primary,
                    inactiveColor: theme.colorScheme.shadow.withOpacity(0.2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static String _getMethodTitle(TranceMethod method) {
    switch (method) {
      case TranceMethod.Hypnosis:
        return 'Hypnotherapy';
      case TranceMethod.Meditation:
        return 'Meditation';
      case TranceMethod.Breathe:
        return 'Breathwork';
      case TranceMethod.Active:
        return 'Active Hypnotherapy';
      case TranceMethod.Sleep:
        return 'Sleep Programming';
    }
  }

  static Widget _buildDurationSelector(BuildContext context, WidgetRef ref, TranceMethod tranceMethod) {
    final tranceSettingsNotifier = ref.watch(tranceSettingsProvider.notifier);
    final theme = Theme.of(context);

    // Different time options based on modality
    final List<int> timeOptions;
    if (tranceMethod == TranceMethod.Breathe) {
      timeOptions = const [1, 2, 3, 5, 8, 10, 20];
    } else {
      timeOptions = const [5, 10, 15, 20, 25, 30, 40, 50, 60];
    }

    return TimeSlider(
      values: timeOptions,
      onValueChanged: (value) {
        tranceSettingsNotifier.setSessionDuration(value);
      },
      color: theme.colorScheme.shadow,
    );
  }
}

// Add pages for HypnotherapyMethods and Soundscapes
class HypnotherapyMethodsPage {
  const HypnotherapyMethodsPage._();

  static WoltModalSheetPage build(BuildContext context) {
    final theme = Theme.of(context);
    
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: true,
      leadingNavBarWidget: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: theme.colorScheme.shadow),
            onPressed: () {
              // Fix back button navigation
              final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
              final previousPage = ref.read(previousPageIndexProvider);
              
              // Go back to the trance settings page
              pageIndexNotifier.value = previousPage;
              
              // Make sure the previous page index is set to the page before the trance settings page
              if (previousPage == 4) { // If going back to trance settings page (index 4)
                // Reset the previous page index to ensure we can navigate back from trance settings
                ref.read(previousPageIndexProvider.notifier).state = 3; // Modality select page
              }
            },
          );
        },
      ),
      pageTitle: Center(
        child: Text(
          'Hypnotherapy Method',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: theme.colorScheme.shadow,
          ),
        ),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final tranceSettings = ref.watch(tranceSettingsProvider);
          final tranceSettingsNotifier = ref.watch(tranceSettingsProvider.notifier);
          
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: HypnotherapyMethod.values.length,
              itemBuilder: (context, index) {
                final method = HypnotherapyMethod.values[index];
                final isSelected = tranceSettings.hypnotherapyMethod == method;
                
                return GlassContainer(
                  margin: const EdgeInsets.only(bottom: 8),
                  borderRadius: BorderRadius.circular(12),
                  backgroundColor: Colors.white12,
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    // Add leading icon for the method
                    leading: Icon(
                      hypnotherapyMethodIcons[method] ?? Icons.psychology,
                      color: theme.colorScheme.shadow,
                      size: 22,
                    ),
                    title: Text(
                      hypnotherapyMethods[method] ?? method.name,
                      style: TextStyle(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    // Make the subtitle smaller or remove if necessary
                    subtitle: Text(
                      hypnotherapyMethodDescriptions[method] ?? '',
                      style: TextStyle(
                        color: theme.colorScheme.shadow.withOpacity(0.7),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: theme.colorScheme.primary,
                          size: 22.0,
                        )
                      : null,
                    onTap: () async {
                      await tranceSettingsNotifier.setHypnotherapyMethod(method);
                      
                      // Navigate back to trance settings page and ensure correct previous page tracking
                      final previousPage = ref.read(previousPageIndexProvider);
                      ref.read(pageIndexNotifierProvider).value = previousPage;
                      
                      // If going back to trance settings (page 4), update previous page index to modality page (3)
                      if (previousPage == 4) {
                        ref.read(previousPageIndexProvider.notifier).state = 3;
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SoundscapesPage {
  const SoundscapesPage._();

  static WoltModalSheetPage build(BuildContext context) {
    final theme = Theme.of(context);
    
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: true,
      leadingNavBarWidget: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: theme.colorScheme.shadow),
            onPressed: () {
              final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
              final previousPage = ref.read(previousPageIndexProvider);
              pageIndexNotifier.value = previousPage;
            },
          );
        },
      ),
      pageTitle: Center(
        child: Text(
          'Select Soundscape',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: theme.colorScheme.shadow,
          ),
        ),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final tranceSettings = ref.watch(tranceSettingsProvider);
          final tranceSettingsNotifier = ref.watch(tranceSettingsProvider.notifier);
          
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: BackgroundSound.values.length,
              itemBuilder: (context, index) {
                final sound = BackgroundSound.values[index];
                final isSelected = tranceSettings.backgroundSound == sound;
                
                if (sound == BackgroundSound.None) {
                  return const SizedBox.shrink(); // Skip None option
                }
                
                return GlassContainer(
                  margin: const EdgeInsets.only(bottom: 8),
                  borderRadius: BorderRadius.circular(12),
                  backgroundColor: Colors.white12,
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: Icon(
                      sound.icon,
                      color: theme.colorScheme.shadow,
                      size: 22,
                    ),
                    title: Text(
                      sound.name,
                      style: TextStyle(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: theme.colorScheme.primary,
                          size: 22.0,
                        )
                      : null,
                    onTap: () async {
                      await tranceSettingsNotifier.setBackgroundSound(sound);
                      
                      // Navigate back to trance settings page
                      ref.read(pageIndexNotifierProvider).value = ref.read(previousPageIndexProvider);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Add pages for BreathingMethods and MeditationMethods

class BreathingMethodsPage {
  const BreathingMethodsPage._();

  static WoltModalSheetPage build(BuildContext context) {
    final theme = Theme.of(context);
    
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: true,
      leadingNavBarWidget: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: theme.colorScheme.shadow),
            onPressed: () {
              // Fix back button navigation
              final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
              final previousPage = ref.read(previousPageIndexProvider);
              
              // Go back to the trance settings page
              pageIndexNotifier.value = previousPage;
              
              // Make sure the previous page index is set to the page before the trance settings page
              if (previousPage == 4) { // If going back to trance settings page (index 4)
                // Reset the previous page index to ensure we can navigate back from trance settings
                ref.read(previousPageIndexProvider.notifier).state = 3; // Modality select page
              }
            },
          );
        },
      ),
      pageTitle: Center(
        child: Text(
          'Breathing Method',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: theme.colorScheme.shadow,
          ),
        ),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final tranceSettings = ref.watch(tranceSettingsProvider);
          final tranceSettingsNotifier = ref.watch(tranceSettingsProvider.notifier);
          
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: BreathingMethod.values.length,
              itemBuilder: (context, index) {
                final method = BreathingMethod.values[index];
                final isSelected = tranceSettings.breathingMethod == method;
                
                return GlassContainer(
                  margin: const EdgeInsets.only(bottom: 8),
                  borderRadius: BorderRadius.circular(12),
                  backgroundColor: Colors.white12,
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    // Add leading icon for the method
                    leading: Icon(
                      breathingMethodIcons[method] ?? Icons.air,
                      color: theme.colorScheme.shadow,
                      size: 22,
                    ),
                    title: Text(
                      breathingMethods[method] ?? method.name,
                      style: TextStyle(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      breathingMethodDescriptions[method] ?? '',
                      style: TextStyle(
                        color: theme.colorScheme.shadow.withOpacity(0.7),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: theme.colorScheme.primary,
                          size: 22.0,
                        )
                      : null,
                    onTap: () async {
                      await tranceSettingsNotifier.setBreathingMethod(method);
                      
                      // Navigate back to trance settings page and ensure correct previous page tracking
                      final previousPage = ref.read(previousPageIndexProvider);
                      ref.read(pageIndexNotifierProvider).value = previousPage;
                      
                      // If going back to trance settings (page 4), update previous page index to modality page (3)
                      if (previousPage == 4) {
                        ref.read(previousPageIndexProvider.notifier).state = 3;
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class MeditationMethodsPage {
  const MeditationMethodsPage._();

  static WoltModalSheetPage build(BuildContext context) {
    final theme = Theme.of(context);
    
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: true,
      leadingNavBarWidget: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: theme.colorScheme.shadow),
            onPressed: () {
              // Fix back button navigation
              final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
              final previousPage = ref.read(previousPageIndexProvider);
              
              // Go back to the trance settings page
              pageIndexNotifier.value = previousPage;
              
              // Make sure the previous page index is set to the page before the trance settings page
              if (previousPage == 4) { // If going back to trance settings page (index 4)
                // Reset the previous page index to ensure we can navigate back from trance settings
                ref.read(previousPageIndexProvider.notifier).state = 3; // Modality select page
              }
            },
          );
        },
      ),
      pageTitle: Center(
        child: Text(
          'Meditation Method',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: theme.colorScheme.shadow,
          ),
        ),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final tranceSettings = ref.watch(tranceSettingsProvider);
          final tranceSettingsNotifier = ref.watch(tranceSettingsProvider.notifier);
          
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: MeditationMethod.values.length,
              itemBuilder: (context, index) {
                final method = MeditationMethod.values[index];
                final isSelected = tranceSettings.meditationMethod == method;
                
                return GlassContainer(
                  margin: const EdgeInsets.only(bottom: 8),
                  borderRadius: BorderRadius.circular(12),
                  backgroundColor: Colors.white12,
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    // Add leading icon for the method
                    leading: Icon(
                      meditationMethodIcons[method] ?? Icons.self_improvement,
                      color: theme.colorScheme.shadow,
                      size: 22,
                    ),
                    title: Text(
                      meditationMethods[method] ?? method.name,
                      style: TextStyle(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      meditationMethodDescriptions[method] ?? '',
                      style: TextStyle(
                        color: theme.colorScheme.shadow.withOpacity(0.7),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: theme.colorScheme.primary,
                          size: 22.0,
                        )
                      : null,
                    onTap: () async {
                      await tranceSettingsNotifier.setMeditationMethod(method);
                      
                      // Navigate back to trance settings page and ensure correct previous page tracking
                      final previousPage = ref.read(previousPageIndexProvider);
                      ref.read(pageIndexNotifierProvider).value = previousPage;
                      
                      // If going back to trance settings (page 4), update previous page index to modality page (3)
                      if (previousPage == 4) {
                        ref.read(previousPageIndexProvider.notifier).state = 3;
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
