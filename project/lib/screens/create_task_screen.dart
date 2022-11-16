import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/widgets/tag_widget.dart';

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
        elevation: 0,
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
      body:
          Padding(padding: const EdgeInsets.all(20), child: _TaskScreenBody()),
    );
  }
}

class _TaskScreenBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskScreenBodyState();
}

class _TaskScreenBodyState extends State<_TaskScreenBody> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _createTaskNameSection(),
          const SizedBox(
            height: 20,
          ),
          _createTagsSection(),
          const SizedBox(
            height: 20,
          ),
          _createDeadlineSection(),
          const SizedBox(
            height: 20,
          ),
          _createAssignedSection(),
          const SizedBox(
            height: 20,
          ),
          _createDescriptionSection(),
        ],
      ),
    );
  }

  Widget _createTaskNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "task",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          style: const TextStyle(fontSize: 12),
          decoration: const InputDecoration.collapsed(
            hintText: 'concise description of the task at hand...',
          ),
        ),
      ],
    );
  }

  Widget _createTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "tags",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(
          height: 5,
        ),
        _createTagsDropdown(),
      ],
    );
  }

  Widget _createTagsDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        TagWidget(
            size: TagSize.small, color: Color(0xffffffff), tagText: "add +"),
      ],
    );
  }

  Widget _createDeadlineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "deadline",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(
          height: 5,
        ),
        TextButton(
          style: Themes.datePickerButtonStyle,
          child: const Text("click to pick a date.."),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => _showDeadlinePicker(),
          ),
        ),
      ],
    );
  }

  Widget _showDeadlinePicker() {
    return DatePickerDialog(
      helpText: "deadline",
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.parse("2032-12-31"),
    );
  }

  Widget _createAssignedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "assigned",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        _createAssignedList(),
      ],
    );
  }

  Widget _createAssignedList() {
    return Column();
  }

  Widget _createDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "description",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          style: const TextStyle(fontSize: 12),
          decoration: const InputDecoration.collapsed(
            hintText: 'detailed description of the task at hand...',
          ),
        ),
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
