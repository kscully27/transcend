import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Constants for page indices in the trance settings flow
class PageIndices {
  const PageIndices._();
  
  /// Root page index
  static const int rootPage = 0;
  
  /// Custom intention page index
  static const int customIntentionPage = 1;
  
  /// Modality select page index
  static const int modalitySelectPage = 2;
  
  /// Settings page index
  static const int settingsPage = 3;
  
  /// Advanced settings page index
  static const int advancedSettingsPage = 4;
  
  /// Break between sentences page index
  static const int breakBetweenSentencesPage = 5;
}

/// Provider for the current page index
final pageIndexNotifierProvider = Provider<ValueNotifier<int>>((ref) {
  return ValueNotifier<int>(PageIndices.rootPage);
});

/// Provider for the previous page index
final previousPageIndexProvider = StateProvider<int>((ref) {
  return PageIndices.rootPage;
}); 