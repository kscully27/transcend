import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/providers/selected_modality_provider.dart';
import 'package:trancend/src/providers/trance_settings_provider.dart';
import 'package:trancend/src/ui/break_duration_selector.dart';
import 'package:trancend/src/ui/clay/clay_bottom_sheet.dart';
import 'package:trancend/src/modal/pages/trance_settings/trance_utils.dart';

/// Class containing methods for showing advanced settings modals
class AdvancedSettingsModal {
  /// Show advanced settings in a clay bottom sheet
  static void showAdvancedSettingsModal(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    // Get the selected modality for the title
    final selectedModality = ref.read(selectedModalityProvider) ?? TranceMethod.Hypnosis;
    final modalityTitle = TranceUtils.getModalityTitle(selectedModality);

    ClayBottomSheet.show(
      context: context,
      heightPercent: 0.6,
      barrierColor: Colors.black.withOpacity(0.1),
      content: Consumer(
        builder: (context, ref, _) {
          final tranceSettings = ref.watch(tranceSettingsProvider);
          final tranceSettingsNotifier = ref.read(tranceSettingsProvider.notifier);
          
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
                  // Don't close the current bottom sheet
                  // Instead, show the break between sentences modal on top
                  showBreakBetweenSentencesModal(context, ref);
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
                        tranceSettingsNotifier.setBackgroundVolume(value);
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
                        tranceSettingsNotifier.setVoiceVolume(value);
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

  /// Show break between sentences selector in a clay bottom sheet
  static void showBreakBetweenSentencesModal(BuildContext context, WidgetRef ref) {
    final tranceSettings = ref.read(tranceSettingsProvider);
    
    // Get the selected modality for the title
    final selectedModality = ref.read(selectedModalityProvider) ?? TranceMethod.Hypnosis;
    
    // Cache the theme and other values before showing modal to avoid context issues
    final theme = Theme.of(context);
    
    ClayBottomSheet.show(
      context: context,
      heightPercent: 0.55, // Increased height to ensure Apply button is fully visible
      barrierColor: Colors.black.withOpacity(0.1),
      content: BreakDurationSelector(
        title: 'Break Between Sentences',
        initialDuration: tranceSettings.breakBetweenSentences,
      ),
    );
    // The advanced settings modal will stay open in the background
    // And will automatically update when the break between sentences value changes
    // because we're using a Consumer widget to watch for changes in the tranceSettings state
  }
} 