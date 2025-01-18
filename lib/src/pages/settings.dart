import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:clay_containers/widgets/clay_container.dart';
import 'dart:io';
import 'dart:convert';

import '../constants/app_colors.dart';
import '../widgets/color_picker_dialog.dart';
import '../services/saved_preferences.dart';
import '../utils/eye_dropper.dart' if (dart.library.html) '../utils/eye_dropper_web.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

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

  ThemeColorsNotifier() : super({'theme': {'light': {}, 'dark': {}}, 'colors': {}});

  Future<void> loadColors(String themeName) async {
    try {
      // Load from bundled assets
      final jsonString = await rootBundle.loadString('assets/color_schemes/${themeName}_colors.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString) as Map<String, dynamic>;
      
      // Get the theme data
      final Map<String, dynamic> themeData = jsonData['theme'] as Map<String, dynamic>;
      final Map<String, dynamic> lightTheme = themeData['light'] as Map<String, dynamic>;
      final Map<String, dynamic> darkTheme = themeData['dark'] as Map<String, dynamic>;
      final Map<String, dynamic> colors = jsonData['colors'] as Map<String, dynamic>;
      
      state = {
        'theme': {
          'light': lightTheme,
          'dark': darkTheme,
        },
        'colors': colors,
      };
      
      _hasChanges = false;
    } catch (e) {
      print('Error loading colors: $e');
    }
  }

  void updateColor(String mode, String name, Color color) {
    final newState = Map<String, dynamic>.from(state);
    final theme = (newState['theme'] as Map<String, dynamic>)[mode] as Map<String, dynamic>;
    theme[name] = '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    state = newState;
    _hasChanges = true;
  }

  void updateAppColor(String colorName, String variant, Color color) {
    final newState = Map<String, dynamic>.from(state);
    final colors = (newState['colors'] as Map<String, dynamic>);
    final colorData = (colors[colorName] as Map<String, dynamic>);
    colorData[variant] = '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
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
            label: const Text('Copy JSON'),
            icon: const Icon(Icons.copy),
          );
        },
      ),
    );
  }

  Future<void> _publishChanges(BuildContext context, String themeName,
      Map<String, dynamic> colors) async {
    try {
      // Get the original JSON structure
      final scheme = AppColors.currentScheme;
      if (scheme == null) return;

      // Create the complete JSON structure
      final completeJson = {
        'name': scheme.name,
        'title': scheme.title,
        'theme': colors['theme'],
        'colors': colors['colors'],
      };
      
      // Format the JSON
      final prettyJson = const JsonEncoder.withIndent('  ').convert(completeJson);
      
      // Copy to clipboard
      await Clipboard.setData(ClipboardData(text: prettyJson));
      
      if (context.mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('JSON copied to clipboard')),
        );
        
        // Show the dialog with the copied JSON
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Theme Colors JSON'),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('JSON has been copied to your clipboard. Save it to:'),
                    Text('assets/color_schemes/${themeName}_colors.json', 
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    SelectableText(prettyJson,
                      style: const TextStyle(fontFamily: 'monospace')),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error copying JSON: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error copying JSON: $e')),
        );
      }
    }
  }

  void _showColorPicker(BuildContext context, Color color, String key, Function(Color) onColorChanged) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final position = button.localToGlobal(Offset.zero);
    
    late final OverlayEntry overlay;
    overlay = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        top: position.dy,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ColorPickerDialog(
              initialColor: color,
              colorKey: key,
              commonColors: _getCommonColors(context),
              onColorChanged: (newColor) {
                onColorChanged(newColor);
                overlay.remove();
              },
              onCancel: () => overlay.remove(),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlay);
  }

  Widget _buildColorBox(Color color, Function(Color) onColorChanged) {
    return Consumer(
      builder: (context, ref, _) => Row(
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
          if (kIsWeb) ...[
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.colorize, size: 20),
              onPressed: () async {
                final pickedColor = await ColorPicker.pickColor();
                if (pickedColor != null) {
                  onColorChanged(pickedColor);
                  ref.read(colorUpdateProvider.notifier).triggerUpdate();
                }
              },
              tooltip: 'Pick color from screen',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThemeColorSection(ThemeData theme,
      Map<String, dynamic> themeColors, String mode, WidgetRef ref) {
    final scheme = AppColors.currentScheme;
    if (scheme == null) return const SizedBox.shrink();

    final jsonColors = scheme.theme[mode];
    if (jsonColors == null) return const SizedBox.shrink();

    final colorKeys = jsonColors.keys.toList()..sort();
    
    // Watch color updates
    ref.watch(colorUpdateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: colorKeys.map((key) {
        final color = _getColorFromMap(themeColors, key);
        final hexCode = '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              // Color name (1/4 of space)
              SizedBox(
                width: 150,
                child: Text(
                  key,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              // Color box and hex code
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => _showColorPicker(
                      context,
                      color,
                      key,
                      (newColor) async {
                        ref.read(themeColorsProvider.notifier)
                            .updateColor(mode, key, newColor);
                        await AppColors.loadColorScheme(ref.read(themeProvider));
                        ref.read(colorUpdateProvider.notifier).triggerUpdate();
                      },
                    ),
                    child: _buildColorBox(
                      color,
                      (newColor) async {
                        ref.read(themeColorsProvider.notifier)
                            .updateColor(mode, key, newColor);
                        await AppColors.loadColorScheme(ref.read(themeProvider));
                        ref.read(colorUpdateProvider.notifier).triggerUpdate();
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(hexCode, style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
                ],
              ),
              // Space for future content
              Expanded(child: Container()),
            ],
          ),
        );
      }).toList(),
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

    return Consumer(
      builder: (context, ref, _) {
        final themeColors = ref.watch(themeColorsProvider);
        final appColors = (themeColors['colors'] as Map<String, dynamic>?) ?? {};
        
        // Watch color updates
        ref.watch(colorUpdateProvider);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: colors.map((color) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Color name and variants (1/4 of space)
                SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(color.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                // Color boxes
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (_hasColorMode(color, 'shadow'))
                          _buildAppColorBox(
                            'shadow', 
                            color,
                            _getAppColorFromJson(appColors, color, 'shadow'),
                            ref,
                          ),
                        if (_hasColorMode(color, 'dark'))
                          _buildAppColorBox(
                            'dark', 
                            color,
                            _getAppColorFromJson(appColors, color, 'dark'),
                            ref,
                          ),
                        _buildAppColorBox(
                          'flat', 
                          color,
                          _getAppColorFromJson(appColors, color, 'flat'),
                          ref,
                        ),
                        if (_hasColorMode(color, 'light'))
                          _buildAppColorBox(
                            'light', 
                            color,
                            _getAppColorFromJson(appColors, color, 'light'),
                            ref,
                          ),
                        if (_hasColorMode(color, 'highlight') &&
                            color != 'white' &&
                            color != 'black' &&
                            color != 'transparent')
                          _buildAppColorBox(
                            'highlight', 
                            color,
                            _getAppColorFromJson(appColors, color, 'highlight'),
                            ref,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        );
      },
    );
  }

  Color _getAppColorFromJson(Map<String, dynamic> colors, String colorName, String variant) {
    try {
      final colorData = colors[colorName] as Map<String, dynamic>;
      final value = colorData[variant];
      if (value == null) return Colors.grey;
      return Color(int.parse(value.toString()));
    } catch (e) {
      return Colors.grey;
    }
  }

  Widget _buildAppColorBox(String variant, String colorName, Color color, WidgetRef ref) {
    final hexCode = '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () => _showColorPicker(
              context,
              color,
              '$colorName-$variant',
              (newColor) async {
                ref.read(themeColorsProvider.notifier)
                    .updateAppColor(colorName, variant, newColor);
                await AppColors.loadColorScheme(ref.read(themeProvider));
              },
            ),
            child: _buildColorBox(
              color,
              (newColor) async {
                ref.read(themeColorsProvider.notifier)
                    .updateAppColor(colorName, variant, newColor);
                await AppColors.loadColorScheme(ref.read(themeProvider));
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(variant.capitalize(), style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 2),
          Text(hexCode, style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
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
}
