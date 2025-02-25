import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/pages/sessions/active_soundscapes.dart' as active_sounds;
import 'package:trancend/src/pages/sessions/intention_content.dart';
import 'package:trancend/src/pages/sessions/modality_select.dart';
import 'package:trancend/src/pages/sessions/previous_intentions.dart';
import 'package:trancend/src/providers/intention_selection_provider.dart';
import 'package:trancend/src/providers/selected_modality_provider.dart';
import 'package:trancend/src/providers/trance_settings_provider.dart';
import 'package:trancend/src/ui/break_duration_selector.dart';
import 'package:trancend/src/ui/clay/clay_bottom_sheet.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
import 'package:trancend/src/ui/helpers/modal_navigation_helper.dart';
import 'package:trancend/src/ui/time_slider.dart';
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
              }, 'Error resetting providers in RootSheetPage');
            });
          });
          
          return IntentionContent(
            tranceMethod: TranceMethod.values.first,
            onContinue: (intention) {
              // When default intention is selected, go to modality page
              ModalNavigationHelper.safeExecution(() {
                final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                ref.read(previousPageIndexProvider.notifier).state = 0; // Track that we came from root page
                pageIndexNotifier.value = 3; // Index of ModalitySelectPage
              }, 'Error navigating to modality page');
            },
            onGoalsSelected: (goals) {
              // When goals are selected, go to modality page
              // (Note: A 300ms delay is already added in intention_content.dart before this is called)
              ModalNavigationHelper.safeExecution(() {
                final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                ref.read(previousPageIndexProvider.notifier).state = 0; // Track that we came from root page
                pageIndexNotifier.value = 3; // Index of ModalitySelectPage
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

  // Class to create the ActiveSoundscapesPage
  static WoltModalSheetPage buildActiveSoundscapesPage(BuildContext context) {
    final theme = Theme.of(context);
    
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: true,
      leadingNavBarWidget: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: Icon(Remix.arrow_left_s_line, size: 20, color: theme.colorScheme.shadow),
            onPressed: () {
              // Navigate back to previous page
              ModalNavigationHelper.safeExecution(() {
                final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                final previousPage = ref.read(previousPageIndexProvider);
                pageIndexNotifier.value = previousPage;
              }, 'Error navigating back');
            },
          );
        },
      ),
      pageTitle: Center(
        child: Text(
          'Background Music',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: theme.colorScheme.shadow,
          ),
        ),
      ),
      child: Consumer(
        builder: (context, ref, child) {
          // Pass the ref to ActiveSoundscapes to ensure it has access to state
          return active_sounds.ActiveSoundscapes(
            onPlayStateChanged: (isPlaying) {
              // Handle play state changes if needed
            },
            onBack: () {
              // Go back to the previous page using the modal navigation pattern
              ModalNavigationHelper.safeExecution(() {
                try {
                  final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                  final previousPage = ref.read(previousPageIndexProvider);
                  pageIndexNotifier.value = previousPage;
                } catch (e) {
                  debugPrint('Error navigating back from ActiveSoundscapes: $e');
                  // Fallback to simple pop if provider access fails
                  Navigator.of(context).pop();
                }
              }, 'Error navigating back from ActiveSoundscapes');
            },
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
              ModalNavigationHelper.safeExecution(() {
                final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                pageIndexNotifier.value = 0;
              }, 'Error navigating back from CustomIntentionPage');
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
              ModalNavigationHelper.safeExecution(() {
                ref.read(previousPageIndexProvider.notifier).state = 1; // Track that we came from custom page
                pageIndexNotifier.value = 3; // Index of ModalitySelectPage
              }, 'Error navigating after custom intention submission');
            },
            onGoalsSelected: (goals) {
              // Handle goals selection
              debugPrint('Selected goals: $goals');
            },
            initialCustomIntention: intentionState.type == IntentionSelectionType.custom 
                ? intentionState.customIntention 
                : '',
            onBack: () {
              ModalNavigationHelper.safeExecution(() {
                pageIndexNotifier.value = 0;
              }, 'Error navigating back to root page');
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
              ModalNavigationHelper.safeExecution(() {
                final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                pageIndexNotifier.value = 0;
              }, 'Error navigating back from PreviousIntentionsPage');
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
                ModalNavigationHelper.safeExecution(() {
                  pageIndexNotifier.value = 0;
                }, 'Error navigating back to root page');
              },
              onIntentionSelected: (intention) {
                // When previous intention is selected, go to modality page
                ModalNavigationHelper.safeExecution(() {
                  ref.read(previousPageIndexProvider.notifier).state = 2; // Track that we came from previous page
                  pageIndexNotifier.value = 3; // Index of ModalitySelectPage
                }, 'Error navigating after previous intention selection');
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
              ModalNavigationHelper.safeExecution(() {
                final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                // Go back to the page we came from
                final previousPage = ref.read(previousPageIndexProvider);
                pageIndexNotifier.value = previousPage;
              }, 'Error navigating back from ModalitySelectPage');
            },
          );
        },
      ),
      child: Consumer(
        builder: (context, ref, _) {
          // Initialize the intention selection if it hasn't been set
          // This ensures we have a valid state when this page is opened directly
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.microtask(() {
              ModalNavigationHelper.safeExecution(() {
                final intentionState = ref.read(intentionSelectionProvider);
                if (intentionState.type == IntentionSelectionType.none) {
                  final intentionNotifier = ref.read(intentionSelectionProvider.notifier);
                  if (intentionNotifier.mounted) {
                    intentionNotifier.setSelection(IntentionSelectionType.default_intention);
                  }
                }
              }, 'Error initializing intention in ModalitySelectPage');
            });
          });
          
          // Now safely access providers with error handling
          TranceMethod? selectedModality;
          try {
            selectedModality = ref.watch(selectedModalityProvider);
          } catch (e) {
            debugPrint('Error accessing selectedModalityProvider: $e');
            // Leave as null if there's an error
          }
          
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ModalitySelect(
              onBack: () {
                // Go back to the page we came from
                ModalNavigationHelper.safeExecution(() {
                  final previousPage = ref.read(previousPageIndexProvider);
                  final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                  pageIndexNotifier.value = previousPage;
                }, 'Error navigating back from ModalitySelect onBack');
              },
              onSelectMethod: (method, index) {
                // Store the selected modality using the safer method
                final modalityNotifier = ref.read(selectedModalityProvider.notifier);
                if (modalityNotifier.mounted) {
                  modalityNotifier.setModality(method);
                }
                
                // IMPORTANT: Defer the update of tranceSettings to avoid build-time modification
                // Schedule this update to occur after the current build phase is complete
                Future.microtask(() {
                  ModalNavigationHelper.safeExecution(() {
                    final tranceNotifier = ref.read(tranceSettingsProvider.notifier);
                    if (tranceNotifier.mounted) {
                      tranceNotifier.setTranceMethod(method);
                    }
                    
                    // Navigate to the trance settings page within the modal
                    ref.read(previousPageIndexProvider.notifier).state = 3; // Track that we came from modality page
                    
                    // Safely access pageIndexNotifier
                    final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                    pageIndexNotifier.value = 4; // Index of TranceSettingsPage
                  }, 'Error updating settings and navigating after modality selection');
                });
              },
              selectedMethod: selectedModality,
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
              ModalNavigationHelper.safeExecution(() {
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
              }, 'Error navigating back from TranceSettingsModalPage');
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
          TranceMethod? selectedModality;
          try {
            selectedModality = ref.watch(selectedModalityProvider);
          } catch (e) {
            debugPrint('Error accessing selectedModalityProvider in TranceSettingsModalPage: $e');
            // Default to Hypnosis if there's an error
            selectedModality = TranceMethod.Hypnosis;
          }
          
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
          TranceMethod? selectedModality;
          try {
            selectedModality = ref.watch(selectedModalityProvider);
          } catch (e) {
            debugPrint('Error accessing selectedModalityProvider in TranceSettingsModalPage child: $e');
          }
          
          final tranceSettings = ref.watch(tranceSettingsProvider);
          
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
                        // Close the modal
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
    } else if (tranceMethod == TranceMethod.Active) {
      methodSelection = _buildActiveMethodSelection(context, ref, tranceSettings);
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

  static Widget _buildActiveMethodSelection(BuildContext context, WidgetRef ref, TranceSettingsState tranceSettings) {
    final theme = Theme.of(context);
    final userActiveSound = ref.watch(active_sounds.activeSoundscapeProvider) ?? active_sounds.ActiveBackgroundSound.None;
    
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
            // Active soundscape selection
            GestureDetector(
              onTap: () {
                print("Active soundscape GestureDetector tapped");
                // Navigate to active soundscapes using the proper modal navigation pattern
                ref.read(previousPageIndexProvider.notifier).state = 4; // Track current page (trance settings)
                
                // Navigate to the ActiveSoundscapesPage (index 9)
                final activeSoundscapesPageIndex = 9;
                print("Navigating to ActiveSoundscapesPage at index $activeSoundscapesPageIndex");
                ref.read(pageIndexNotifierProvider).value = activeSoundscapesPageIndex; // Go to active soundscapes page
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      userActiveSound.string,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.shadow,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Active Sound',
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

  // Show advanced settings in a clay bottom sheet
  static void _showAdvancedSettingsModal(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tranceSettingsNotifier = ref.read(tranceSettingsProvider.notifier);
    final tranceSettings = ref.read(tranceSettingsProvider);
    
    // Get the selected modality for the title
    final selectedModality = ref.read(selectedModalityProvider) ?? TranceMethod.Hypnosis;
    final modalityTitle = _getModalityTitle(selectedModality);

    ClayBottomSheet.show(
      context: context,
      heightPercent: 0.6,
      content: StatefulBuilder(
        builder: (context, setState) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  modalityTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.shadow,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(height: 1),
              
              // Break between sentences option
              GestureDetector(
                onTap: () {
                  // Close the current bottom sheet immediately
                  Navigator.pop(context);
                  
                  // Show the break between sentences modal directly
                  _showBreakBetweenSentencesModal(context, ref);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Break Between Sentences',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.shadow,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${tranceSettings.breakBetweenSentences} seconds',
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.shadow.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: theme.colorScheme.shadow.withOpacity(0.6),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const Divider(height: 1),

              // Background volume slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Background Volume',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.shadow,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: tranceSettings.backgroundVolume,
                      onChanged: (value) {
                        setState(() {
                          tranceSettingsNotifier.setBackgroundVolume(value);
                        });
                      },
                      min: 0.0,
                      max: 1.0,
                      activeColor: theme.colorScheme.primary,
                      inactiveColor: theme.colorScheme.shadow.withOpacity(0.2),
                    ),
                  ],
                ),
              ),

              // Voice volume slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                    Text(
                      'Voice Volume',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.shadow,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: tranceSettings.voiceVolume,
                      onChanged: (value) {
                        setState(() {
                          tranceSettingsNotifier.setVoiceVolume(value);
                        });
                      },
                      min: 0.0,
                      max: 1.0,
                      activeColor: theme.colorScheme.primary,
                      inactiveColor: theme.colorScheme.shadow.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Show break between sentences selector in a clay bottom sheet
  static void _showBreakBetweenSentencesModal(BuildContext context, WidgetRef ref) {
    final tranceSettings = ref.read(tranceSettingsProvider);
    
    // Get the selected modality for the title
    final selectedModality = ref.read(selectedModalityProvider) ?? TranceMethod.Hypnosis;
    final modalityTitle = _getModalityTitle(selectedModality);
    
    // Cache the theme and other values before showing modal to avoid context issues
    final theme = Theme.of(context);
    
    ClayBottomSheet.show(
      context: context,
      heightPercent: 0.32, // Reduced to fit content exactly without extra space
      content: BreakDurationSelector(
        title: 'Break Between Sentences',
        initialDuration: tranceSettings.breakBetweenSentences,
        // Remove the onClose callback that tries to show the advanced settings modal
        // This was causing the issue when the context is deactivated
      ),
    ).then((_) {
      // After the modal is closed, safely reopen the advanced settings
      // This ensures we're using a valid context
      if (context.mounted) {
        _showAdvancedSettingsModal(context, ref);
      }
    });
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

  // Helper method to get the title based on modality
  static String _getModalityTitle(TranceMethod method) {
    switch (method) {
      case TranceMethod.Hypnosis:
        return 'Hypnotherapy Settings';
      case TranceMethod.Meditation:
        return 'Meditation Settings';
      case TranceMethod.Breathe:
        return 'Breathing Settings';
      case TranceMethod.Active:
        return 'Active Settings';
      case TranceMethod.Sleep:
        return 'Sleep Settings';
      default:
        return 'Trance Settings';
    }
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
              ModalNavigationHelper.safeExecution(() {
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
              }, 'Error navigating back from HypnotherapyMethodsPage');
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
                      
                      ModalNavigationHelper.safeExecution(() {
                        // Navigate back to trance settings page and ensure correct previous page tracking
                        final previousPage = ref.read(previousPageIndexProvider);
                        ref.read(pageIndexNotifierProvider).value = previousPage;
                        
                        // If going back to trance settings (page 4), update previous page index to modality page (3)
                        if (previousPage == 4) {
                          ref.read(previousPageIndexProvider.notifier).state = 3;
                        }
                      }, 'Error navigating after hypnotherapy method selection');
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
              ModalNavigationHelper.safeExecution(() {
                final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                final previousPage = ref.read(previousPageIndexProvider);
                pageIndexNotifier.value = previousPage;
              }, 'Error navigating back from SoundscapesPage');
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
          
          // Safe access to tranceSettingsNotifier
          TranceSettingsNotifier? tranceSettingsNotifier;
          try {
            tranceSettingsNotifier = ref.read(tranceSettingsProvider.notifier);
          } catch (e) {
            debugPrint('Error accessing tranceSettingsNotifier in SoundscapesPage: $e');
            // Continue without the notifier - we'll handle this case later
          }
          
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
          onTap: () {
                      // Defer the update to avoid build-time provider modifications
                      Future.microtask(() async {
                        // Update the background sound if the notifier is available
                        if (tranceSettingsNotifier != null && tranceSettingsNotifier.mounted) {
                          await tranceSettingsNotifier.setBackgroundSound(sound);
                        }
                        
                        ModalNavigationHelper.safeExecution(() {
                          // Navigate back to trance settings page
                          final previousPage = ref.read(previousPageIndexProvider);
                          final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                          pageIndexNotifier.value = previousPage;
                        }, 'Error navigating after sound selection');
                      });
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
              ModalNavigationHelper.safeExecution(() {
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
              }, 'Error navigating back from BreathingMethodsPage');
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
                      
                      ModalNavigationHelper.safeExecution(() {
                        // Navigate back to trance settings page and ensure correct previous page tracking
                        final previousPage = ref.read(previousPageIndexProvider);
                        ref.read(pageIndexNotifierProvider).value = previousPage;
                        
                        // If going back to trance settings (page 4), update previous page index to modality page (3)
                        if (previousPage == 4) {
                          ref.read(previousPageIndexProvider.notifier).state = 3;
                        }
                      }, 'Error navigating after breathing method selection');
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
              ModalNavigationHelper.safeExecution(() {
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
              }, 'Error navigating back from MeditationMethodsPage');
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
                      
                      ModalNavigationHelper.safeExecution(() {
                        // Navigate back to trance settings page and ensure correct previous page tracking
                        final previousPage = ref.read(previousPageIndexProvider);
                        ref.read(pageIndexNotifierProvider).value = previousPage;
                        
                        // If going back to trance settings (page 4), update previous page index to modality page (3)
                        if (previousPage == 4) {
                          ref.read(previousPageIndexProvider.notifier).state = 3;
                        }
                      }, 'Error navigating after meditation method selection');
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

