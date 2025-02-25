import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/providers/selected_modality_provider.dart';
import 'package:trancend/src/providers/trance_settings_provider.dart';
import 'package:trancend/src/ui/helpers/modal_navigation_helper.dart';
import 'package:trancend/src/ui/widgets/modality_card.dart';
import 'package:trancend/src/modal/pages/trance_settings/modal_page_definitions.dart';
import 'package:trancend/src/modal/pages/trance_settings/trance_utils.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// Modality selection page for the trance settings flow
class ModalitySelectPage {
  const ModalitySelectPage._();

  /// Build the modality selection page
  static WoltModalSheetPage build(BuildContext context) {
    return WoltModalSheetPage(
      backgroundColor: Colors.transparent,
      hasTopBarLayer: false,
      child: Consumer(
        builder: (context, ref, _) {
          final selectedModality = ref.watch(selectedModalityProvider);
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                child: Text(
                  'Select a modality',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: TranceMethod.values.length,
                  itemBuilder: (context, index) {
                    final method = TranceMethod.values[index];
                    final isSelected = selectedModality == method;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ModalityCard(
                        title: TranceUtils.getMethodTitle(method),
                        isSelected: isSelected,
                        onTap: () {
                          ModalNavigationHelper.safeExecution(() {
                            // Set the selected modality
                            ref.read(selectedModalityProvider.notifier).setModality(method);
                            
                            // Set the trance method in the settings
                            ref.read(tranceSettingsProvider.notifier).setTranceMethod(method);
                            
                            // Navigate to the next page
                            final pageIndexNotifier = ref.read(pageIndexNotifierProvider);
                            ref.read(previousPageIndexProvider.notifier).state = PageIndices.modalitySelectPage;
                            pageIndexNotifier.value = PageIndices.settingsPage;
                          }, 'Error selecting modality');
                        },
                      ),
                    );
                  },
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
                          pageIndexNotifier.value = PageIndices.rootPage;
                        }, 'Error navigating back to root page');
                      },
                      child: const Text('Back'),
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
} 