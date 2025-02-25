import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/models/user.model.dart';

/// Utility methods for working with trance settings
class TranceUtils {
  const TranceUtils._();
  
  /// Get the title for a trance method
  static String getMethodTitle(TranceMethod method) {
    switch (method) {
      case TranceMethod.Hypnosis:
        return 'Hypnosis';
      case TranceMethod.Meditation:
        return 'Meditation';
      case TranceMethod.Breathe:
        return 'Breathwork';
      case TranceMethod.Active:
        return 'Active Hypnotherapy';
      case TranceMethod.Sleep:
        return 'Sleep Programming';
      default:
        return 'Unknown Method';
    }
  }
  
  /// Get the title for a modality (used in settings page)
  static String getModalityTitle(TranceMethod method) {
    switch (method) {
      case TranceMethod.Hypnosis:
        return 'Hypnosis';
      case TranceMethod.Meditation:
        return 'Meditation';
      case TranceMethod.Breathe:
        return 'Breathwork';
      case TranceMethod.Active:
        return 'Active Hypnotherapy';
      case TranceMethod.Sleep:
        return 'Sleep Programming';
      default:
        return 'Unknown Modality';
    }
  }
  
  /// Get the description for a trance method
  static String getMethodDescription(TranceMethod method) {
    switch (method) {
      case TranceMethod.Hypnosis:
        return 'Guided hypnotherapy for deep subconscious reprogramming';
      case TranceMethod.Meditation:
        return 'Mindful meditation for present-moment awareness';
      case TranceMethod.Breathe:
        return 'Breathwork techniques for relaxation and energy';
      case TranceMethod.Active:
        return 'Movement-based hypnotherapy for physical engagement';
      case TranceMethod.Sleep:
        return 'Subconscious reprogramming while you sleep';
      default:
        return '';
    }
  }
  
  /// Get the default session duration for a trance method
  static int getDefaultSessionDuration(TranceMethod method) {
    switch (method) {
      case TranceMethod.Hypnosis:
        return 20;
      case TranceMethod.Meditation:
        return 15;
      case TranceMethod.Breathe:
        return 10;
      case TranceMethod.Active:
        return 25;
      case TranceMethod.Sleep:
        return 30;
      default:
        return 15;
    }
  }
  
  /// Get the default background sound for a trance method
  static BackgroundSound getDefaultBackgroundSound(TranceMethod method) {
    switch (method) {
      case TranceMethod.Hypnosis:
        return BackgroundSound.Waves;
      case TranceMethod.Meditation:
        return BackgroundSound.Forest;
      case TranceMethod.Breathe:
        return BackgroundSound.None;
      case TranceMethod.Active:
        return BackgroundSound.Nature;
      case TranceMethod.Sleep:
        return BackgroundSound.Rain;
      default:
        return BackgroundSound.None;
    }
  }
  
  /// Get the default voice volume for a trance method
  static double getDefaultVoiceVolume(TranceMethod method) {
    switch (method) {
      case TranceMethod.Hypnosis:
        return 0.8;
      case TranceMethod.Meditation:
        return 0.7;
      case TranceMethod.Breathe:
        return 0.6;
      case TranceMethod.Active:
        return 0.9;
      case TranceMethod.Sleep:
        return 0.5;
      default:
        return 0.7;
    }
  }
  
  /// Get the default background volume for a trance method
  static double getDefaultBackgroundVolume(TranceMethod method) {
    switch (method) {
      case TranceMethod.Hypnosis:
        return 0.3;
      case TranceMethod.Meditation:
        return 0.4;
      case TranceMethod.Breathe:
        return 0.2;
      case TranceMethod.Active:
        return 0.5;
      case TranceMethod.Sleep:
        return 0.3;
      default:
        return 0.3;
    }
  }
  
  /// Get the default break between sentences for a trance method
  static double getDefaultBreakBetweenSentences(TranceMethod method) {
    switch (method) {
      case TranceMethod.Hypnosis:
        return 1.5;
      case TranceMethod.Meditation:
        return 2.0;
      case TranceMethod.Breathe:
        return 3.0;
      case TranceMethod.Active:
        return 1.0;
      case TranceMethod.Sleep:
        return 2.5;
      default:
        return 1.5;
    }
  }
  
  /// Get the icon for a trance method
  static String getMethodIcon(TranceMethod method) {
    switch (method) {
      case TranceMethod.Hypnosis:
        return 'assets/icons/hypnosis.png';
      case TranceMethod.Meditation:
        return 'assets/icons/meditation.png';
      case TranceMethod.Breathe:
        return 'assets/icons/breathe.png';
      case TranceMethod.Active:
        return 'assets/icons/active.png';
      case TranceMethod.Sleep:
        return 'assets/icons/sleep.png';
      default:
        return 'assets/icons/default.png';
    }
  }
} 