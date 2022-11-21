import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/styles/theme.dart';

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

  final TextEditingController? textEditingController;

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
    this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => TextFormField(
        keyboardType: keyboardType,
        textInputAction: keyboardAction,
        controller: textEditingController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        obscureText: isPassword,
        decoration: InputDecoration(
          labelStyle: Theme.of(context).textTheme.labelLarge,
          label: Text(label, style: TextStyle(color: Themes.textColor(ref))),
          hintText: placeholderText,
          hintStyle: Theme.of(context).textTheme.labelSmall,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Themes.textColor(ref).withOpacity(0.4),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Themes.textColor(ref).withOpacity(0.4),
            ),
          ),
        ),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
