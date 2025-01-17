import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:simple_eye_dropper/simple_eye_dropper.dart';

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
  late Color pickerColor;

  @override
  void initState() {
    super.initState();
    pickerColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pick color for ${widget.colorKey}'),
            const SizedBox(height: 16),
            // Color picker
            ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                setState(() => pickerColor = color);
              },
              pickerAreaBorderRadius: BorderRadius.circular(8),
              enableAlpha: true,
              displayThumbColor: true,
              hexInputBar: true,
              colorPickerWidth: 300,
              pickerAreaHeightPercent: 0.7,
            ),
            const SizedBox(height: 16),
            // Common colors below the picker
            Text('Common Colors', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.commonColors.entries.map((entry) {
                return InkWell(
                  onTap: () {
                    setState(() => pickerColor = entry.value);
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: entry.value,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.key,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
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
                  onPressed: () {
                    widget.onColorChanged(pickerColor);
                    widget.onCancel();
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
