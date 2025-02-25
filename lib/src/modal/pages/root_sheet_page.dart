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

// Provider to track the selected modality
final selectedModalityProvider = StateProvider<TranceMethod?>((ref) => null);

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
              final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
              pageIndexNotifier.value = 3; // Go back to modality selection
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
      pageTitle: Center(
        child: Text(
          'Select Method',
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
              pageIndexNotifier.value = 4; // Go back to trance settings
            },
          );
        },
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final tranceSettings = ref.watch(tranceSettingsProvider);
          final tranceSettingsNotifier = ref.watch(tranceSettingsProvider.notifier);
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ...HypnotherapyMethod.values.map((method) {
                  final isSelected = tranceSettings.hypnotherapyMethod == method;
                  final methodName = hypnotherapyMethods[method] ?? method.name;
                  final methodDescription = hypnotherapyMethodDescriptions[method] ?? '';
                  final methodIcon = hypnotherapyMethodIcons[method] ?? Icons.psychology;
                  
                  return GlassContainer(
                    margin: const EdgeInsets.only(bottom: 12),
                    borderRadius: BorderRadius.circular(12),
                    backgroundColor: Colors.white12,
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.shadow.withOpacity(0.7),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Icon(methodIcon, color: theme.colorScheme.shadow),
                        ],
                      ),
                      title: Text(
                        methodName,
                        style: TextStyle(
                          color: theme.colorScheme.shadow,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        methodDescription,
                        style: TextStyle(
                          color: theme.colorScheme.shadow.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        tranceSettingsNotifier.setHypnotherapyMethod(method);
                        // Go back to trance settings
                        ref.read(pageIndexNotifierProvider).value = 4;
                      },
                    ),
                  );
                }).toList(),
              ],
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
      pageTitle: Center(
        child: Text(
          'Select Sound',
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
              pageIndexNotifier.value = 4; // Go back to trance settings
            },
          );
        },
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final tranceSettings = ref.watch(tranceSettingsProvider);
          final tranceSettingsNotifier = ref.watch(tranceSettingsProvider.notifier);
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ...BackgroundSound.values
                    .where((sound) => sound != BackgroundSound.None)
                    .map((sound) {
                  final isSelected = tranceSettings.backgroundSound == sound;
                  return GlassContainer(
                    margin: const EdgeInsets.only(bottom: 12),
                    borderRadius: BorderRadius.circular(12),
                    backgroundColor: Colors.white12,
                    child: ListTile(
                      leading: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.shadow.withOpacity(0.7),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      title: Text(
                        sound.name,
                        style: TextStyle(
                          color: theme.colorScheme.shadow,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        tranceSettingsNotifier.setBackgroundSound(sound);
                        // Go back to trance settings
                        ref.read(pageIndexNotifierProvider).value = 4;
                      },
                    ),
                  );
                }).toList(),
              ],
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
      pageTitle: Center(
        child: Text(
          'Select Breathing Method',
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
              pageIndexNotifier.value = 4; // Go back to trance settings
            },
          );
        },
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final tranceSettings = ref.watch(tranceSettingsProvider);
          final tranceSettingsNotifier = ref.watch(tranceSettingsProvider.notifier);
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ...BreathingMethod.values.map((method) {
                  final isSelected = tranceSettings.breathingMethod == method;
                  final methodName = breathingMethods[method] ?? method.name;
                  final methodDescription = breathingMethodDescriptions[method] ?? '';
                  final methodIcon = breathingMethodIcons[method] ?? Icons.air;
                  
                  return GlassContainer(
                    margin: const EdgeInsets.only(bottom: 12),
                    borderRadius: BorderRadius.circular(12),
                    backgroundColor: Colors.white12,
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.shadow.withOpacity(0.7),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Icon(methodIcon, color: theme.colorScheme.shadow),
                        ],
                      ),
                      title: Text(
                        methodName,
                        style: TextStyle(
                          color: theme.colorScheme.shadow,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        methodDescription,
                        style: TextStyle(
                          color: theme.colorScheme.shadow.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        tranceSettingsNotifier.setBreathingMethod(method);
                        // Go back to trance settings
                        ref.read(pageIndexNotifierProvider).value = 4;
                      },
                    ),
                  );
                }).toList(),
              ],
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
      pageTitle: Center(
        child: Text(
          'Select Meditation Method',
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
              pageIndexNotifier.value = 4; // Go back to trance settings
            },
          );
        },
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final tranceSettings = ref.watch(tranceSettingsProvider);
          final tranceSettingsNotifier = ref.watch(tranceSettingsProvider.notifier);
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ...MeditationMethod.values.map((method) {
                  final isSelected = tranceSettings.meditationMethod == method;
                  final methodName = meditationMethods[method] ?? method.name;
                  final methodDescription = meditationMethodDescriptions[method] ?? '';
                  final methodIcon = meditationMethodIcons[method] ?? Icons.self_improvement;
                  
                  return GlassContainer(
                    margin: const EdgeInsets.only(bottom: 12),
                    borderRadius: BorderRadius.circular(12),
                    backgroundColor: Colors.white12,
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.shadow.withOpacity(0.7),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Icon(methodIcon, color: theme.colorScheme.shadow),
                        ],
                      ),
                      title: Text(
                        methodName,
                        style: TextStyle(
                          color: theme.colorScheme.shadow,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        methodDescription,
                        style: TextStyle(
                          color: theme.colorScheme.shadow.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        tranceSettingsNotifier.setMeditationMethod(method);
                        // Go back to trance settings
                        ref.read(pageIndexNotifierProvider).value = 4;
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
