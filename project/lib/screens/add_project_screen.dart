import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/widgets/appbar_button.dart';

class AddProjectScreen extends StatelessWidget {
  const AddProjectScreen({super.key});
  //final Key _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("add project"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: <Widget>[
          AppBarButton(
              handler: () {},
              tooltip: "Create new project",
              icon: PhosphorIcons.floppyDiskBackLight)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          //key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelStyle: TextStyle(fontSize: 16),
                  label: Text(
                    "title",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  hintText: "a concise description for the project...",
                  hintStyle: TextStyle(fontSize: 12),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelStyle: TextStyle(fontSize: 16),
                  label: Text(
                    "description",
                    style: TextStyle(color: Colors.black),
                  ),
                  hintText: "describe your project here",
                  hintStyle: TextStyle(fontSize: 12),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
