import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/input_field.dart';

/// Screen/Scaffold for creating a new projext.
class CreateProjectScreen extends StatelessWidget {
  const CreateProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("add project"),
        centerTitle: false,
        titleSpacing: -4,
        leading: AppBarButton(
          handler: () => Navigator.of(context).pop(),
          tooltip: "Add new task",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: <Widget>[
          AppBarButton(
            handler: () {},
            tooltip: "Create new project",
            icon: PhosphorIcons.floppyDiskLight,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              const InputField(
                label: "title",
                placeholderText: "a concise description for the project...",
                keyboardType: TextInputAction.next,
              ),
              const SizedBox(
                height: 16.0,
              ),
              InputField(
                label: "description",
                placeholderText: "describe your project here",
                keyboardType: TextInputAction.done,
                onSubmit: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
