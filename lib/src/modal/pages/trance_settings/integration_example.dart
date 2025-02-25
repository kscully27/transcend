import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/modal/pages/trance_settings/trance_settings_modal_provider.dart';
import 'package:trancend/src/models/session.model.dart';
import 'package:trancend/src/models/user.model.dart';
import 'package:trancend/src/providers/trance_settings_provider.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

/// A comprehensive example of how to integrate the trance settings modal
/// into a real-world application
class TranceSettingsIntegrationExample extends ConsumerStatefulWidget {
  const TranceSettingsIntegrationExample({Key? key}) : super(key: key);

  @override
  ConsumerState<TranceSettingsIntegrationExample> createState() => _TranceSettingsIntegrationExampleState();
}

class _TranceSettingsIntegrationExampleState extends ConsumerState<TranceSettingsIntegrationExample> {
  bool _isSessionStarted = false;
  
  @override
  Widget build(BuildContext context) {
    // Watch the trance settings to update the UI when they change
    final tranceSettings = ref.watch(tranceSettingsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trance Session'),
        actions: [
          // Settings button in the app bar
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _isSessionStarted ? null : _openTranceSettings,
            tooltip: 'Trance Settings',
          ),
        ],
      ),
      body: Column(
        children: [
          // Session information card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GlassContainer(
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session Settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildSettingRow(
                      'Trance Method',
                      tranceSettings.tranceMethod.name,
                      Icons.psychology,
                    ),
                    const Divider(),
                    _buildSettingRow(
                      'Session Duration',
                      '${tranceSettings.sessionDuration} minutes',
                      Icons.timer,
                    ),
                    const Divider(),
                    _buildSettingRow(
                      'Background Sound',
                      tranceSettings.backgroundSound.name,
                      Icons.music_note,
                    ),
                    const Divider(),
                    _buildSettingRow(
                      'Voice Volume',
                      '${(tranceSettings.voiceVolume * 100).round()}%',
                      Icons.record_voice_over,
                    ),
                    const Divider(),
                    _buildSettingRow(
                      'Background Volume',
                      '${(tranceSettings.backgroundVolume * 100).round()}%',
                      Icons.volume_up,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Customize button
          if (!_isSessionStarted)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                onPressed: _openTranceSettings,
                icon: const Icon(Icons.settings),
                label: const Text('Customize Session'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ),
          
          const Spacer(),
          
          // Start/Stop session button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _toggleSession,
              icon: Icon(_isSessionStarted ? Icons.stop : Icons.play_arrow),
              label: Text(_isSessionStarted ? 'Stop Session' : 'Start Session'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: _isSessionStarted 
                  ? Theme.of(context).colorScheme.error 
                  : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build a row for a setting
  Widget _buildSettingRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }
  
  /// Open the trance settings modal
  void _openTranceSettings() {
    if (_isSessionStarted) return;
    
    TranceSettingsModalProvider.show(context).then((_) {
      // This code runs after the modal is closed
      
      // You can perform actions based on the updated settings
      final settings = ref.read(tranceSettingsProvider);
      
      // For example, you might want to prepare audio files based on the selected background sound
      _prepareBackgroundSound(settings.backgroundSound);
      
      // Or adjust session parameters based on the selected trance method
      _adjustSessionParameters(settings.tranceMethod);
    });
  }
  
  /// Toggle the session state
  void _toggleSession() {
    setState(() {
      _isSessionStarted = !_isSessionStarted;
    });
    
    if (_isSessionStarted) {
      _startSession();
    } else {
      _stopSession();
    }
  }
  
  /// Start the trance session
  void _startSession() {
    final settings = ref.read(tranceSettingsProvider);
    
    // In a real app, you would start the session with the current settings
    debugPrint('Starting session with method: ${settings.tranceMethod.name}');
    debugPrint('Session duration: ${settings.sessionDuration} minutes');
    debugPrint('Background sound: ${settings.backgroundSound.name}');
    
    // Show a snackbar to indicate that the session has started
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session started with ${settings.tranceMethod.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  /// Stop the trance session
  void _stopSession() {
    // In a real app, you would stop the session
    debugPrint('Stopping session');
    
    // Show a snackbar to indicate that the session has stopped
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session stopped'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  /// Prepare the background sound
  void _prepareBackgroundSound(BackgroundSound sound) {
    // In a real app, you would prepare the audio file for the selected background sound
    debugPrint('Preparing background sound: ${sound.name}');
  }
  
  /// Adjust session parameters based on the selected trance method
  void _adjustSessionParameters(TranceMethod method) {
    // In a real app, you would adjust session parameters based on the selected trance method
    debugPrint('Adjusting session parameters for method: ${method.name}');
  }
} 