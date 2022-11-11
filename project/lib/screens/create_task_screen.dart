import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/widgets/input_field.dart';

import '../styles/theme.dart';
import '../widgets/appbar_button.dart';

class CreateTaskScreen extends StatelessWidget {
  static const routeName = "/new-task";
  const CreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("create task"),
        centerTitle: false,
        titleSpacing: -4,
        leading: AppBarButton(
          handler: () => Navigator.of(context).pop(),
          tooltip: "Go back",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.black,
        ),
        backgroundColor: Themes.themeData.appBarTheme.backgroundColor,
        foregroundColor: Themes.themeData.appBarTheme.foregroundColor,
        actions: [
          AppBarButton(
            handler: () {},
            tooltip: "Save task",
            icon: PhosphorIcons.floppyDiskLight,
            color: Colors.black,
          ),
        ],
      ),
      body: _createTaskScreenBody(),
    );
  }

  Widget _createTaskScreenBody() {
    return Column(
      children: <Widget>[
        _createTaskNameSection(),
        _createTagsSection(),
        _createDeadlineSection(),
        _createAssignedSection(),
        _createDescriptionSection(),
      ],
    );
  }

  Widget _createTaskNameSection() {
    return Column(
      children: const <Widget>[
        Text("task"),
        InputField(label: "", placeholderText: ""),
      ],
    );
  }

  Widget _createTagsSection() {
    return Column(
      children: <Widget>[
        const Text("tags"),
        _createTagsDropdown(),
      ],
    );
  }

  Widget _createTagsDropdown() {
    return Column();
  }

  Widget _createDeadlineSection() {
    return Column(
      children: <Widget>[
        const Text("deadline"),
        TextButton(
          child: const Text("click to pick a date.."),
          onPressed: () => _showDeadlinePicker(),
        ),
      ],
    );
  }

  void _showDeadlinePicker() {
    DatePickerDialog(
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.parse("2032-12-31"));
  }

  Widget _createAssignedSection() {
    return Column();
  }

  Widget _createDescriptionSection() {
    return Column(
      children: const <Widget>[
        Text("description"),
        InputField(label: "", placeholderText: ""),
      ],
    );
  }
}

// class _TaskNameSection extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _TaskNameSectionState();
// }

// class _TaskNameSectionState extends State<_TaskNameSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: const <Widget>[
//         Text("task"),
//         InputField(label: "", placeholderText: ""),
//       ],
//     );
//   }
// }

// class _TaskTagsSection extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _TaskTagsSectionState();
// }

// class _TaskTagsSectionState extends State<_TaskTagsSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: const <Widget>[
//         Text("tags"),
//         InputField(label: "", placeholderText: ""),
//       ],
//     );
//   }
// }

// class _TaskDeadlineSection extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _TaskDeadlineSectionState();
// }

// class _TaskDeadlineSectionState extends State<_TaskDeadlineSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: const <Widget>[
//         Text("tags"),
//         InputField(label: "", placeholderText: ""),
//       ],
//     );
//   }
// }

// class _TaskAssignedSection extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _TaskAssignedSectionState();
// }

// class _TaskAssignedSectionState extends State<_TaskAssignedSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: const <Widget>[
//         Text("tags"),
//         InputField(label: "", placeholderText: ""),
//       ],
//     );
//   }
// }

// class _TaskDescriptionSection extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _TaskDescriptionSectionState();
// }

// class _TaskDescriptionSectionState extends State<_TaskDescriptionSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: const <Widget>[
//         Text("tags"),
//         InputField(
//           label: "",
//           placeholderText: "",
//         ),
//       ],
//     );
//   }
// }
