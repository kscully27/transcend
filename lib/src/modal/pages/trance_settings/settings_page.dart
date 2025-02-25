import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/providers/selected_modality_provider.dart';
import 'package:trancend/src/providers/trance_settings_provider.dart';
import 'package:trancend/src/ui/helpers/modal_navigation_helper.dart';
import 'package:trancend/src/modal/pages/trance_settings/advanced_settings_modal.dart';
import 'package:trancend/src/modal/pages/trance_settings/modal_page_definitions.dart';
import 'package:trancend/src/modal/pages/trance_settings/trance_utils.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// Settings page for the trance settings flow
class SettingsPage {
  const SettingsPage._();

  /// Build the settings page
  static WoltModalSheetPage build(BuildContext context) {
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: false,
      child: Consumer(
        builder: (context, ref, _) {
          final selectedModality = ref.watch(selectedModalityProvider);
          final tranceSettings = ref.watch(tranceSettingsProvider);
          final tranceSettingsNotifier = ref.read(tranceSettingsProvider.notifier);
          
          if (selectedModality == null) {
            // If no modality is selected, go back to modality select page
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ModalNavigationHelper.safeExecution(() {
                final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                pageIndexNotifier.value = PageIndices.modalitySelectPage;
              }, 'Error navigating back to modality select page');
            });
            return const Center(child: CircularProgressIndicator());
          }
          
          final modalityTitle = TranceUtils.getModalityTitle(selectedModality);
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                child: Text(
                  '$modalityTitle Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    // Settings specific to the selected modality
                    _buildModalitySpecificSettings(context, ref, selectedModality),
                    
                    const SizedBox(height: 16.0),
                    
                    // Advanced settings button
                    ListTile(
                      title: const Text('Advanced Settings'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        AdvancedSettingsModal.showAdvancedSettingsModal(context, ref);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        ModalNavigationHelper.safeExecution(() {
                          final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                          pageIndexNotifier.value = PageIndices.modalitySelectPage;
                        }, 'Error navigating back to modality select page');
                      },
                      child: const Text('Back'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Apply settings and close the modal
                        Navigator.of(context).pop();
                      },
                      child: const Text('Apply'),
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
  
  /// Build settings specific to the selected modality
  static Widget _buildModalitySpecificSettings(
    BuildContext context, 
    WidgetRef ref, 
    TranceMethod selectedModality
  ) {
    final tranceSettings = ref.watch(tranceSettingsProvider);
    final tranceSettingsNotifier = ref.read(tranceSettingsProvider.notifier);
    
    switch (selectedModality) {
      case TranceMethod.Hypnosis:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hypnotherapy Method'),
            const SizedBox(height: 8.0),
            // Hypnotherapy method selection
            DropdownButtonFormField<HypnotherapyMethod>(
              value: tranceSettings.hypnotherapyMethod ?? HypnotherapyMethod.Guided,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: HypnotherapyMethod.values.map((method) {
                final displayName = hypnotherapyMethods[method] ?? 'Unknown';
                return DropdownMenuItem(value: method, child: Text(displayName));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  tranceSettingsNotifier.setHypnotherapyMethod(value);
                }
              },
            ),
          ],
        );
        
      case TranceMethod.Meditation:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Meditation Method'),
            const SizedBox(height: 8.0),
            // Meditation method selection
            DropdownButtonFormField<MeditationMethod>(
              value: tranceSettings.meditationMethod ?? MeditationMethod.Mindfulness,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: MeditationMethod.values.map((method) {
                final displayName = meditationMethods[method] ?? 'Unknown';
                return DropdownMenuItem(value: method, child: Text(displayName));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  tranceSettingsNotifier.setMeditationMethod(value);
                }
              },
            ),
          ],
        );
        
      case TranceMethod.Breathe:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Breathing Method'),
            const SizedBox(height: 8.0),
            // Breathing method selection
            DropdownButtonFormField<BreathingMethod>(
              value: tranceSettings.breathingMethod ?? BreathingMethod.BalancedBreathing,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: BreathingMethod.values.map((method) {
                final displayName = breathingMethods[method] ?? 'Unknown';
                return DropdownMenuItem(value: method, child: Text(displayName));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  tranceSettingsNotifier.setBreathingMethod(value);
                }
              },
            ),
          ],
        );
        
      case TranceMethod.Active:
        // For Active, we'll use a simple placeholder since we don't have a specific method type
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Active Hypnotherapy Settings'),
            const SizedBox(height: 8.0),
            const Text('Active hypnotherapy uses movement and physical engagement.'),
            const SizedBox(height: 16.0),
            // Session duration slider
            Text('Session Duration: ${tranceSettings.sessionDuration} minutes'),
            Slider(
              value: tranceSettings.sessionDuration.toDouble(),
              min: 5,
              max: 60,
              divisions: 11,
              label: '${tranceSettings.sessionDuration} min',
              onChanged: (value) {
                tranceSettingsNotifier.setSessionDuration(value.round());
              },
            ),
          ],
        );
        
      case TranceMethod.Sleep:
        // For Sleep, we'll use a simple placeholder since we don't have a specific method type
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sleep Programming Settings'),
            const SizedBox(height: 8.0),
            const Text('Sleep programming works while you sleep for subconscious reprogramming.'),
            const SizedBox(height: 16.0),
            // Session duration slider
            Text('Session Duration: ${tranceSettings.sessionDuration} minutes'),
            Slider(
              value: tranceSettings.sessionDuration.toDouble(),
              min: 5,
              max: 60,
              divisions: 11,
              label: '${tranceSettings.sessionDuration} min',
              onChanged: (value) {
                tranceSettingsNotifier.setSessionDuration(value.round());
              },
            ),
          ],
        );
    }
  }
} 