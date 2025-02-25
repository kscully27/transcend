import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/providers/base/safe_state_notifier.dart';
import 'package:trancend/src/providers/trance_settings_provider.dart';

/// A StateNotifier for safely managing the selected modality
class SelectedModalityNotifier extends SafeStateNotifier<TranceMethod?> {
  SelectedModalityNotifier(this.ref) : super(null) {
    _initializeState();
  }
  
  final Ref ref;
  
  void _initializeState() {
    // When this provider is first accessed, defer the trance settings reset
    // to prevent build-time modifications of another provider
    Future.microtask(() {
      try {
        final tranceSettingsNotifier = ref.read(tranceSettingsProvider.notifier);
        if (tranceSettingsNotifier.mounted) {
          tranceSettingsNotifier.clearTranceMethod();
        }
      } catch (e) {
        debugPrint('Error resetting trance method in deferred initialization: $e');
      }
    });
  }
  
  /// Method to set the modality safely
  void setModality(TranceMethod? method) {
    safeUpdateState(method);
  }
  
  /// Method to reset the modality to null safely
  void reset() {
    safeUpdateState(null);
  }
}

/// Provider to track the selected modality
final selectedModalityProvider = StateNotifierProvider<SelectedModalityNotifier, TranceMethod?>((ref) {
  return SelectedModalityNotifier(ref);
}); 