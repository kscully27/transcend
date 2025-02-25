import 'package:trancend/src/models/session.model.dart';

/// Utility class for trance-related helper methods
class TranceUtils {
  /// Get the title based on trance method
  static String getMethodTitle(TranceMethod method) {
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

  /// Get the settings title based on modality
  static String getModalityTitle(TranceMethod method) {
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