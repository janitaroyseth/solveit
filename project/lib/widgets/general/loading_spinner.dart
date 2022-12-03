import 'package:flutter/material.dart';

/// Loading spinner to use while fetching data.
class LoadingSpinner extends StatelessWidget {
  /// Create instance of [LoadingSpinner].
  const LoadingSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
