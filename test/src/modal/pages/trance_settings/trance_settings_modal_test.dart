import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trancend/src/modal/pages/trance_settings/modal_page_definitions.dart';
import 'package:trancend/src/modal/pages/trance_settings/trance_settings_modal.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/providers/selected_modality_provider.dart';
import 'package:trancend/src/providers/trance_settings_provider.dart';

void main() {
  testWidgets('TranceSettingsModal navigates through pages correctly', (WidgetTester tester) async {
    // Create a test app with a provider scope
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  TranceSettingsModal.show(context);
                },
                child: const Text('Open Modal'),
              );
            },
          ),
        ),
      ),
    );
    
    // Tap the button to open the modal
    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();
    
    // Verify that the root page is shown
    expect(find.text('Select a modality'), findsNothing); // We're on the root page, not the modality page yet
    
    // Navigate to the modality select page (this would normally happen after selecting an intention)
    final container = ProviderContainer();
    final pageIndexNotifier = container.read(pageIndexNotifierProvider);
    pageIndexNotifier.value = PageIndices.modalitySelectPage;
    await tester.pumpAndSettle();
    
    // Verify that the modality select page is shown
    expect(find.text('Select a modality'), findsOneWidget);
    
    // Select a modality
    container.read(selectedModalityProvider.notifier).setModality(TranceMethod.Meditation);
    pageIndexNotifier.value = PageIndices.settingsPage;
    await tester.pumpAndSettle();
    
    // Verify that the settings page is shown
    expect(find.text('Meditation Settings'), findsOneWidget);
    
    // Verify that the trance method was set correctly
    final tranceSettings = container.read(tranceSettingsProvider);
    expect(tranceSettings.tranceMethod, equals(TranceMethod.Meditation));
    
    // Clean up
    container.dispose();
  });
  
  testWidgets('TranceSettingsModal updates trance settings correctly', (WidgetTester tester) async {
    // Create a test app with a provider scope
    final container = ProviderContainer();
    
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              final tranceSettings = ref.watch(tranceSettingsProvider);
              
              return Column(
                children: [
                  Text('Method: ${tranceSettings.tranceMethod.name}'),
                  Text('Duration: ${tranceSettings.sessionDuration}'),
                  ElevatedButton(
                    onPressed: () {
                      TranceSettingsModal.show(context);
                    },
                    child: const Text('Open Modal'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
    
    // Verify initial settings
    expect(find.text('Method: Hypnosis'), findsOneWidget);
    
    // Tap the button to open the modal
    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();
    
    // Navigate to the modality select page
    container.read(pageIndexNotifierProvider).value = PageIndices.modalitySelectPage;
    await tester.pumpAndSettle();
    
    // Select a modality
    container.read(selectedModalityProvider.notifier).setModality(TranceMethod.Meditation);
    container.read(tranceSettingsProvider.notifier).setTranceMethod(TranceMethod.Meditation);
    container.read(pageIndexNotifierProvider).value = PageIndices.settingsPage;
    await tester.pumpAndSettle();
    
    // Update session duration
    container.read(tranceSettingsProvider.notifier).setSessionDuration(25);
    
    // Close the modal
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    
    // Verify that the settings were updated
    expect(find.text('Method: Meditation'), findsOneWidget);
    expect(find.text('Duration: 25'), findsOneWidget);
    
    // Clean up
    container.dispose();
  });
} 