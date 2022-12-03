import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/styles/theme.dart';

/// Dialog for picking a color.
class ColorPickerDialog extends StatefulWidget {
  /// void callback used when a color is picked.
  final void Function(Color pickedColor) colorPickerFunction;

  /// The inital color to be displayed.
  final Color initialColor;

  /// Creates an instance of [ColorPickerDialog].
  const ColorPickerDialog({
    super.key,
    required this.colorPickerFunction,
    required this.initialColor,
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  /// Whether to display swatches or color wheel.
  bool showSwatches = true;

  /// The color picked.
  late Color pickedColor;

  @override
  void initState() {
    pickedColor = widget.initialColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("pick a color"),
            _toggleColorPickerButton(ref),
          ],
        ),
        actions: [
          _closeButton(context, ref),
        ],
        content: SizedBox(
          height: 300,
          child: _colorPicker(),
        ),
      ),
    );
  }

  /// Buttong for closing the dialog.
  TextButton _closeButton(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text(
        "close",
        style: TextStyle(
          color: Themes.textColor(ref),
        ),
      ),
    );
  }

  /// Toggles between types of color pickers.
  TextButton _toggleColorPickerButton(WidgetRef ref) {
    return TextButton(
      onPressed: () {
        setState(() {
          showSwatches = !showSwatches;
        });
      },
      child: Icon(
        showSwatches
            ? PhosphorIcons.paintBrushLight
            : PhosphorIcons.squaresFourLight,
        size: 38,
        color: Themes.textColor(ref),
      ),
    );
  }

  /// Returns a color picker, type of picker depends on the bool [showSwatches].
  Widget _colorPicker() {
    return showSwatches
        ? BlockPicker(
            onColorChanged: (value) {
              widget.colorPickerFunction(value);
            },
            pickerColor: pickedColor,
          )
        : ColorPicker(
            pickerColor: pickedColor,
            onColorChanged: (value) {
              widget.colorPickerFunction(value);
            },
            enableAlpha: false,
            pickerAreaHeightPercent: 0.7,
            paletteType: PaletteType.hueWheel,
            labelTypes: const [],
          );
  }
}
