import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/app_colors.dart';
import '../constants/color_scheme.dart';
import '../widgets/color_picker_dialog.dart';
import '../services/saved_preferences.dart';

class ColorSettingsScreen extends StatefulWidget {
  const ColorSettingsScreen({super.key});

  @override
  State<ColorSettingsScreen> createState() => _ColorSettingsScreenState();
}

class _ColorSettingsScreenState extends State<ColorSettingsScreen> {
  late Map<String, dynamic> originalColors;
  late Map<String, dynamic> modifiedColors;
  int changesCount = 0;

  @override
  void initState() {
    super.initState();
    _loadColors();
  }

  Future<void> _loadColors() async {
    final scheme = AppColors.currentScheme;
    if (scheme == null) return;

    // Load original colors from JSON file
    final jsonString = await rootBundle.loadString(
      'assets/color_schemes/${scheme.name}_colors.json',
    );
    originalColors = json.decode(jsonString) as Map<String, dynamic>;

    // Load modified colors from preferences
    final savedColors = await SavedPreferences.getThemeColors(scheme.name);
    modifiedColors = savedColors ?? Map<String, dynamic>.from(originalColors);

    _updateChangesCount();
    setState(() {});
  }

  void _updateChangesCount() {
    int count = 0;
    final originalTheme = originalColors['theme'] as Map<String, dynamic>;
    final modifiedTheme = modifiedColors['theme'] as Map<String, dynamic>;

    for (final mode in ['light', 'dark']) {
      final originalMode = originalTheme[mode] as Map<String, dynamic>;
      final modifiedMode = modifiedTheme[mode] as Map<String, dynamic>;

      for (final key in originalMode.keys) {
        if (originalMode[key] != modifiedMode[key]) {
          count++;
        }
      }
    }

    setState(() => changesCount = count);
  }

  Future<void> _publishChanges() async {
    final scheme = AppColors.currentScheme;
    if (scheme == null) return;

    try {
      // Get the app's documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/assets/color_schemes/${scheme.name}_colors.json';
      
      // Ensure the directory exists
      final file = File(filePath);
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }

      // Write the JSON to file
      final jsonString = json.encode(modifiedColors);
      await file.writeAsString(jsonString);

      // Clear saved preferences
      await SavedPreferences.clearThemeColors(scheme.name);

      // Reload colors
      await _loadColors();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes published successfully')),
        );
      }
    } catch (e) {
      print('Error publishing changes: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error publishing changes: $e')),
        );
      }
    }
  }

  Map<String, Color> _getCommonColors(String mode) {
    final theme = (modifiedColors['theme'] as Map<String, dynamic>)[mode] as Map<String, dynamic>;
    return theme.map((key, value) => MapEntry(key, Color(int.parse(value.toString()))));
  }

  void _showColorPicker(String mode, String colorKey, Color initialColor) {
    showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(
        initialColor: initialColor,
        colorKey: colorKey,
        commonColors: _getCommonColors(mode),
        onColorChanged: (color) async {
          print("🚀 ~ _ColorSettingsScreenState ~ void_showColorPicker ~ color: $color");
          final theme = (modifiedColors['theme'] as Map<String, dynamic>)[mode] as Map<String, dynamic>;
          var newColor = '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
          print("🚀 ~ _ColorSettingsScreenState ~ void_showColorPicker ~ newColor: $newColor");
          theme[colorKey] = newColor;
          print("🚀 ~ _ColorSettingsScreenState ~ void_showColorPicker ~ theme: $theme ${AppColors.currentScheme!.name}, $modifiedColors");
          
          // Save to preferences
          await SavedPreferences.setThemeColors(AppColors.currentScheme!.name, modifiedColors);
          
          _updateChangesCount();
          setState(() {});
        }, onCancel: () {  },
      ),
    );
  }

  Widget _buildColorGrid(String mode) {
    final theme = (modifiedColors['theme'] as Map<String, dynamic>)[mode] as Map<String, dynamic>;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${mode.toUpperCase()} Theme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: theme.entries.map((entry) {
                final color = Color(int.parse(entry.value.toString()));
                return InkWell(
                  onTap: () => _showColorPicker(mode, entry.key, color),
                  child: Tooltip(
                    message: entry.key,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildColorGrid('light'),
          const SizedBox(height: 16),
          _buildColorGrid('dark'),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                changesCount > 0 ? '$changesCount changes' : 'No changes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ElevatedButton(
                onPressed: changesCount > 0 ? _publishChanges : null,
                child: const Text('Publish Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 