import 'package:flutter/material.dart';

/// Represents a input field.
class InputField extends StatelessWidget {
  /// [String] label displaying what the content of the field should be.
  final String label;

  /// [String] (an enum) text giving hint to what the content of the field should be.
  final String placeholderText;

  /// [TextInputAction] what the action on the keyboard should display.
  final TextInputAction? keyboardAction;

  /// [TextInputType] what type of text input should the keyboard be tailored to.
  final TextInputType? keyboardType;

  final bool isPassword;

  /// [Function] to invoke when the field is submitted.
  final Function? onSubmit;

  /// Creates an instance of [InputField] with the given [String] label,
  /// [String] placeholder text, [TextInputAction] keyboard type and [Function]
  /// submit function.
  const InputField({
    super.key,
    required this.label,
    required this.placeholderText,
    this.keyboardAction,
    this.keyboardType,
    this.isPassword = false,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      textInputAction: keyboardAction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      obscureText: isPassword,
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
