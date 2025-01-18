import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final String colorKey;
  final Map<String, Color> commonColors;
  final Function(Color) onColorChanged;
  final VoidCallback onCancel;

  const ColorPickerDialog({
    super.key,
    required this.initialColor,
    required this.colorKey,
    required this.commonColors,
    required this.onColorChanged,
    required this.onCancel,
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color currentColor;
  late HSVColor hsvColor;
  double hue = 0;
  double saturation = 0;
  double value = 0;
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    currentColor = widget.initialColor;
    hsvColor = HSVColor.fromColor(currentColor);
    hue = hsvColor.hue;
    saturation = hsvColor.saturation;
    value = hsvColor.value;
    opacity = hsvColor.alpha;
  }

  void _updateColor(HSVColor color) {
    setState(() {
      hsvColor = color;
      currentColor = color.toColor();
      hue = color.hue;
      saturation = color.saturation;
      value = color.value;
      opacity = color.alpha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color picker square only
            SizedBox(
              width: 300,
              height: 300,
              child: ColorPicker(
                pickerColor: currentColor,
                onColorChanged: (color) {
                  setState(() {
                    currentColor = color;
                    hsvColor = HSVColor.fromColor(color);
                    hue = hsvColor.hue;
                    saturation = hsvColor.saturation;
                    value = hsvColor.value;
                  });
                },
                enableAlpha: true,
                labelTypes: const [],
                pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(10)),
                displayThumbColor: true,
                portraitOnly: true,
              ),
            ),
            const SizedBox(height: 16),
            // Color Adjustments
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSlider(
                  'Hue',
                  hue,
                  0,
                  360,
                  (val) {
                    _updateColor(HSVColor.fromAHSV(opacity, val, saturation, value));
                  },
                ),
                _buildSlider(
                  'Saturation',
                  saturation,
                  0,
                  1,
                  (val) {
                    _updateColor(HSVColor.fromAHSV(opacity, hue, val, value));
                  },
                ),
                _buildSlider(
                  'Value',
                  value,
                  0,
                  1,
                  (val) {
                    _updateColor(HSVColor.fromAHSV(opacity, hue, saturation, val));
                  },
                ),
                _buildSlider(
                  'Opacity',
                  opacity,
                  0,
                  1,
                  (val) {
                    _updateColor(HSVColor.fromAHSV(val, hue, saturation, value));
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Common Colors
            if (widget.commonColors.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              const Text('Common Colors'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.commonColors.entries.map((entry) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        currentColor = entry.value;
                        hsvColor = HSVColor.fromColor(currentColor);
                        hue = hsvColor.hue;
                        saturation = hsvColor.saturation;
                        value = hsvColor.value;
                        opacity = hsvColor.alpha;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: entry.value,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => widget.onColorChanged(currentColor),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value.toStringAsFixed(2)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
