import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import '../constants/app_colors.dart';
import '../widgets/color_picker_dialog.dart';
import '../services/saved_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final themeProvider = StateNotifierProvider<ThemeNotifier, String>((ref) {
  return ThemeNotifier();
});

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  return DarkModeNotifier();
});

final colorUpdateProvider =
    StateNotifierProvider<ColorUpdateNotifier, int>((ref) {
  return ColorUpdateNotifier();
});

final themeColorsProvider =
    StateNotifierProvider<ThemeColorsNotifier, Map<String, dynamic>>((ref) {
  return ThemeColorsNotifier();
});

class ThemeNotifier extends StateNotifier<String> {
  ThemeNotifier() : super('candy') {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('theme') ?? 'candy';
    await AppColors.loadColorScheme(state);
  }

  Future<void> setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    await AppColors.loadColorScheme(theme);
    state = theme;
  }
}

class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier() : super(false) {
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('darkMode') ?? false;
  }

  Future<void> toggle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', !state);
    state = !state;
  }
}

class ColorUpdateNotifier extends StateNotifier<int> {
  ColorUpdateNotifier() : super(0);

  void triggerUpdate() {
    state++;
  }
}

class ThemeColorsNotifier extends StateNotifier<Map<String, dynamic>> {
  bool _hasChanges = false;
  bool get hasChanges => _hasChanges;

  ThemeColorsNotifier() : super({'theme': {'light': {}, 'dark': {}}});

  Future<void> loadColors(String themeName) async {
    try {
      // Load from bundled assets
      final jsonString = await rootBundle.loadString('assets/color_schemes/${themeName}_colors.json');
      final dynamic jsonData = json.decode(jsonString);
      
      // Properly cast the maps
      final Map<String, dynamic> themeData = {
        'theme': {
          'light': Map<String, dynamic>.from(jsonData['theme']['light'] as Map),
          'dark': Map<String, dynamic>.from(jsonData['theme']['dark'] as Map),
        }
      };
      
      state = themeData;
      _hasChanges = false;
    } catch (e) {
      print('Error loading colors: $e');
    }
  }

  void updateColor(String mode, String name, Color color) {
    final newState = Map<String, dynamic>.from(state);
    final theme = (newState['theme'] as Map<String, dynamic>)[mode] as Map<String, dynamic>;
    theme[name.replaceAll(' ', '')] = '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    state = newState;
    _hasChanges = true;
  }
}

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Load JSON colors when page loads
    Future.microtask(() {
      ref
          .read(themeColorsProvider.notifier)
          .loadColors(ref.read(themeProvider));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(darkModeProvider);
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: theme.textTheme.headlineSmall),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final themeColors = ref.watch(themeColorsProvider);
          final mode = isDarkMode ? 'dark' : 'light';
          final colors = (themeColors['theme'] as Map<String, dynamic>)[mode] as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Theme Selection
                  Text('Theme', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: currentTheme,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                          value: 'candy', child: Text('Candy Theme')),
                      DropdownMenuItem(
                          value: 'earth', child: Text('Earth Tones Theme')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(themeProvider.notifier).setTheme(value);
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  ClayContainer(
                    color: theme.colorScheme.surface,
                    parentColor: theme.colorScheme.surface,
                    borderRadius: 12,
                    width: double.infinity,
                    height: 100,
                    depth: 20,
                    spread: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dark Mode',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Switch(
                            value: isDarkMode,
                            onChanged: (value) {
                              ref.read(darkModeProvider.notifier).toggle();
                            },
                            activeColor: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Theme Colors Section
                  Text('Theme Colors', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildThemeColorSection(theme, colors, mode, ref),
                  const SizedBox(height: 24),

                  // App Colors Section
                  Text('App Colors', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildAppColorSection(theme),

                  const SizedBox(height: 32),

                  // Publish Changes Button
                  if (themeColors.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 200),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () =>
                              _publishChanges(context, currentTheme, themeColors),
                          child: const Text('Publish Changes'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, _) {
          final hasChanges = ref.read(themeColorsProvider.notifier).hasChanges;
          if (!hasChanges) return const SizedBox.shrink();
          
          return FloatingActionButton.extended(
            onPressed: () => _publishChanges(
              context,
              ref.read(themeProvider),
              ref.read(themeColorsProvider),
            ),
            label: const Text('Publish Changes'),
            icon: const Icon(Icons.save),
          );
        },
      ),
    );
  }

  Future<void> _publishChanges(BuildContext context, String themeName,
      Map<String, dynamic> colors) async {
    try {
      // For now, just update the theme
      await AppColors.loadColorScheme(themeName);
      
      // Reset changes flag
      ref.read(themeColorsProvider.notifier)._hasChanges = false;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes applied successfully')),
        );
      }
    } catch (e) {
      print('Error applying changes: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error applying changes: $e')),
        );
      }
    }
  }

  Widget _buildThemeColorSection(ThemeData theme,
      Map<String, dynamic> themeColors, String mode, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildColorRow(
            'primary', _getColorFromMap(themeColors, 'primary'), mode, ref),
        _buildColorRow('primaryContainer',
            _getColorFromMap(themeColors, 'primaryContainer'), mode, ref),
        _buildColorRow(
            'secondary', _getColorFromMap(themeColors, 'secondary'), mode, ref),
        _buildColorRow('secondaryContainer',
            _getColorFromMap(themeColors, 'secondaryContainer'), mode, ref),
        _buildColorRow(
            'surface', _getColorFromMap(themeColors, 'surface'), mode, ref),
        _buildColorRow('surfaceVariant',
            _getColorFromMap(themeColors, 'surfaceVariant'), mode, ref),
        _buildColorRow('background',
            _getColorFromMap(themeColors, 'background'), mode, ref),
        _buildColorRow('error', _getColorFromMap(themeColors, 'error'), mode, ref),
        _buildColorRow('errorContainer',
            _getColorFromMap(themeColors, 'errorContainer'), mode, ref),
          _buildColorRow('onPrimary', _getColorFromMap(themeColors, 'onPrimary'),
            mode, ref),
        _buildColorRow('onSecondary',
            _getColorFromMap(themeColors, 'onSecondary'), mode, ref),
          _buildColorRow('onSurface', _getColorFromMap(themeColors, 'onSurface'),
            mode, ref),
        _buildColorRow('onBackground',
            _getColorFromMap(themeColors, 'onBackground'), mode, ref),
        _buildColorRow('onError', _getColorFromMap(themeColors, 'onError'), mode, ref),
        _buildColorRow('outline', _getColorFromMap(themeColors, 'outline'), mode, ref),
        _buildColorRow('shadow', _getColorFromMap(themeColors, 'shadow'), mode, ref),
        _buildColorRow('inverseSurface',
            _getColorFromMap(themeColors, 'inverseSurface'), mode, ref),
        _buildColorRow('onInverseSurface',
            _getColorFromMap(themeColors, 'onInverseSurface'), mode, ref),
        _buildColorRow('inversePrimary',
            _getColorFromMap(themeColors, 'inversePrimary'), mode, ref),
      ],
    );
  }

  Color _getColorFromMap(Map<String, dynamic> colors, String key) {
    final value = colors[key];
    if (value == null) return Colors.grey;
    return Color(int.parse(value.toString()));
  }

  Widget _buildAppColorSection(ThemeData theme) {
    final colors = [
      'khaki',
      'blue',
      'green',
      'purple',
      'red',
      'orange',
      'pink',
      'dark',
      'light',
      'white',
      'black'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: colors.map((color) => _buildAppColorRow(color)).toList(),
    );
  }

  Widget _buildColorRow(String name, Color color, String mode, WidgetRef ref) {
    return Builder(
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(name),
                  ),
                  InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ColorPickerDialog(
                        initialColor: color,
                        colorKey: name,
                        commonColors: _getCommonColors(context),
                        onColorChanged: (newColor) async {
                          // Update local state
                          ref
                              .read(themeColorsProvider.notifier)
                              .updateColor(mode, name, newColor);

                          // Update theme immediately
                          await AppColors.loadColorScheme(
                              ref.read(themeProvider));

                          // Navigator.of(context).pop();
                        },
                      ),
                    ),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  Map<String, Color> _getCommonColors(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return {
      'Primary': theme.primary,
      'Secondary': theme.secondary,
      'Surface': theme.surface,
      'Background': theme.background,
      'Error': theme.error,
      'On Primary': theme.onPrimary,
      'On Secondary': theme.onSecondary,
      'On Surface': theme.onSurface,
      'On Background': theme.onBackground,
      'On Error': theme.onError,
    };
  }

  Widget _buildAppColorRow(String colorName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(colorName.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (_hasColorMode(colorName, 'shadow'))
                  _buildAppColorBox('Shadow', AppColors.shadow(colorName)),
                if (_hasColorMode(colorName, 'dark'))
                  _buildAppColorBox('Dark', AppColors.dark(colorName)),
                _buildAppColorBox('Flat', AppColors.flat(colorName)),
                if (_hasColorMode(colorName, 'light'))
                  _buildAppColorBox('Light', AppColors.light(colorName)),
                if (_hasColorMode(colorName, 'highlight') &&
                    colorName != 'white' &&
                    colorName != 'black' &&
                    colorName != 'transparent')
                  _buildAppColorBox(
                      'Highlight', AppColors.highlight(colorName)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _hasColorMode(String colorName, String mode) {
    try {
      switch (mode) {
        case 'shadow':
          AppColors.shadow(colorName);
          break;
        case 'dark':
          AppColors.dark(colorName);
          break;
        case 'light':
          AppColors.light(colorName);
          break;
        case 'highlight':
          AppColors.highlight(colorName);
          break;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Widget _buildAppColorBox(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
