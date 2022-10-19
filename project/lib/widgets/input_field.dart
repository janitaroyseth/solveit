import 'package:flutter/material.dart';

/// Represents a input field.
class InputField extends StatelessWidget {
  /// [String] label displaying what the content of the field should be.
  final String label;

  /// [String] (an enum) text giving hint to what the content of the field should be.
  final String placeholderText;

  /// [TextInputAction] what kind of keyboard should be used on the device
  /// for the input field.
  final TextInputAction keyboardType;

  /// [Function] to invoke when the field is submitted.
  final Function? onSubmit;

  /// Creates an instance of [InputField] with the given [String] label,
  /// [String] placeholder text, [TextInputAction] keyboard type and [Function]
  /// submit function.
  const InputField({
    super.key,
    required this.label,
    required this.placeholderText,
    required this.keyboardType,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.labelLarge,
        label: Text(label, style: const TextStyle(color: Colors.black)),
        hintText: placeholderText,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
