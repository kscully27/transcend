import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/modal/pages/trance_settings/modal_page_definitions.dart';
import 'package:trancend/src/modal/pages/trance_settings/trance_settings_modal_provider.dart';

/// A wrapper class to help transition from the old implementation to the new one.
/// This class provides the same API as the old implementation but uses the new one internally.
class LegacyTranceSettingsWrapper {
  /// Show the trance settings modal using the new implementation.
  /// This method maintains the same API as the old implementation to minimize disruption.
  static Future<void> showTranceSettingsModal(BuildContext context, {int initialPage = 0}) async {
    // Log that we're using the new implementation
    debugPrint('Using new trance settings modal implementation');
    
    // Map the old page indices to the new ones
    int mappedInitialPage = PageIndices.rootPage;
    
    // If initialPage is 3 (modality select page in the old implementation),
    // set the page index to the modality select page in the new implementation
    if (initialPage == 3) {
      mappedInitialPage = PageIndices.modalitySelectPage;
      debugPrint('Setting initial page to modality select page');
    } else if (initialPage == 0) {
      // When called from day.dart with no initialPage, we should show the modality page
      // This ensures users go directly to modality selection when tapping from the day view
      mappedInitialPage = PageIndices.modalitySelectPage;
      debugPrint('Setting initial page to modality select page from day view');
    }
    
    // Show the modal using the new implementation
    return TranceSettingsModalProvider.show(context, initialPage: mappedInitialPage);
  }
  
  /// Show the trance settings modal with a provider scope.
  /// This method is a direct replacement for the old implementation.
  static Future<void> showWithProviderScope(BuildContext context) async {
    // Log that we're using the new implementation
    debugPrint('Using new trance settings modal implementation with provider scope');
    
    // Show the modal using the new implementation with modality page as default
    return TranceSettingsModalProvider.show(context, initialPage: PageIndices.modalitySelectPage);
  }
}

/// Extension method to make it easier to show the trance settings modal
extension TranceSettingsModalExtension on BuildContext {
  /// Show the trance settings modal
  Future<void> showTranceSettingsModal({int initialPage = 0}) {
    return LegacyTranceSettingsWrapper.showTranceSettingsModal(this, initialPage: initialPage);
  }
} 