import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/modal/pages/trance_settings/trance_settings_modal_provider.dart';
import 'package:trancend/src/providers/trance_settings_provider.dart';

/// Example of how to use the trance settings modal
class TranceSettingsExample extends ConsumerWidget {
  const TranceSettingsExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the trance settings to update the UI when they change
    final tranceSettings = ref.watch(tranceSettingsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trance Settings Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the current trance method
            Text(
              'Current Trance Method: ${tranceSettings.tranceMethod.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            
            const SizedBox(height: 16),
            
            // Display the session duration
            Text(
              'Session Duration: ${tranceSettings.sessionDuration} minutes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            
            const SizedBox(height: 16),
            
            // Display the background sound
            Text(
              'Background Sound: ${tranceSettings.backgroundSound.name}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            
            const SizedBox(height: 32),
            
            // Button to open the trance settings modal
            ElevatedButton(
              onPressed: () {
                TranceSettingsModalProvider.show(context);
              },
              child: const Text('Open Trance Settings'),
            ),
          ],
        ),
      ),
    );
  }
} 