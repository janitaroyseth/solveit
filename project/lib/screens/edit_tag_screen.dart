import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/models/tag.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/tag_provider.dart';
import 'package:project/styles/theme.dart';
import 'package:project/utilities/color_utility.dart';
import 'package:project/widgets/buttons/app_bar_button.dart';
import 'package:project/widgets/modals/color_picker_dialog.dart';
import 'package:project/widgets/items/tag_list_item.dart';

enum _EditTagMode {
  edit,
  create,
}

/// Screen/Scaffold for editing and creating tags.
class EditTagScreen extends ConsumerStatefulWidget {
  /// Named route for this screen.
  static const String routeName = "/edit-task";

  /// Creates an instance of [EditTagScreen].
  const EditTagScreen({super.key});

  @override
  ConsumerState<EditTagScreen> createState() => _EditTagScreenState();
}

class _EditTagScreenState extends ConsumerState<EditTagScreen> {
  /// The text controller for adding text to a tag.
  final TextEditingController _textController = TextEditingController();

  /// The color of the tag.
  late Color? _pickedColor;

  /// Whether to display there's an error with color picking.
  bool _showColorError = false;

  /// Unique key for the form.
  final _formKey = GlobalKey<FormState>();

  /// The existing tag to edit, if null a new tag is created.
  late Tag? _existingTag;

  /// The tag to edit, either new or set to the existing tag.
  late Tag _tag;

  /// The project to add the tag too.
  late Project _project;

  /// The mode of the screen, whether to edit or create a new tag.
  _EditTagMode _mode = _EditTagMode.create;

  @override
  void didChangeDependencies() {
    _existingTag =
        (ModalRoute.of(context)?.settings.arguments as List)[0] as Tag?;
    _project = ref.read(editProjectProvider)!;
    _mode = _existingTag == null ? _EditTagMode.create : _EditTagMode.edit;
    _tag = _existingTag ?? Tag();
    _textController.text = _tag.text;
    _pickedColor = ColorUtility.colorFromString(_tag.color);
    setState(() {});
    super.didChangeDependencies();
  }

  /// Check that field's are valid and saves the current tag.
  void saveTag() async {
    bool isValid = _formKey.currentState!.validate();

    if (isValid && _pickedColor != null && _pickedColor != Colors.transparent) {
      _tag.text = _textController.text;
      _tag.color = ColorUtility.stringFromColor(_pickedColor!);
      ref
          .read(tagProvider)
          .saveTag(
              tag: _tag, projectId: ref.read(editProjectProvider)!.projectId)
          .then((value) {
        _project.tags.add(value!);
        Navigator.of(context).pop();
      });
    } else {
      if (_pickedColor == null) _showColorError = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: _appBarTitle(_mode),
          leading: _backButton(context),
          actions: [
            _saveButton(),
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _tagTextInputField(_tag),
                _verticalPadding(),
                _tagColorField(_tag),
                _verticalPadding(),
                _previewTag(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _verticalPadding() => const SizedBox(height: 24);

  /// Goes back to previous screen.
  AppBarButton _backButton(BuildContext context) {
    return AppBarButton(
      handler: () => Navigator.of(context).pop(),
      tooltip: "Go back",
      icon: PhosphorIcons.caretLeftLight,
    );
  }

  /// Button for saving the tag.
  AppBarButton _saveButton() {
    return AppBarButton(
      handler: () => saveTag(),
      tooltip: "Save tag",
      icon: PhosphorIcons.floppyDiskLight,
    );
  }

  /// Shows a preview of the tag in creation.
  Widget _previewTag() {
    return Visibility(
      visible: _pickedColor != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "preview",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          if (_pickedColor != null)
            TagListItem(
              size: TagSize.large,
              color: _pickedColor!,
              tagText: _textController.text,
            ),
        ],
      ),
    );
  }

  /// Returns the section for choosing a color for the
  /// tag in creation.
  Column _tagColorField(Tag tag) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "color",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        TextButton(
          style: Themes.formButtonStyle(ref),
          onPressed: () {
            _showColorError = false;
            showDialog(
              context: context,
              builder: (context) => ColorPickerDialog(
                colorPickerFunction: (Color color) {
                  _pickedColor = color;
                  setState(() {});
                },
                initialColor: _pickedColor!,
              ),
            );
          },
          child: Row(
            children: [
              Visibility(
                visible: _pickedColor != null,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: _pickedColor,
                ),
              ),
              const SizedBox(width: 8.0),
              const Text("pick a color"),
            ],
          ),
        ),
        Visibility(
          visible: _showColorError,
          child: Text(
            "color must be chosen",
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
        ),
      ],
    );
  }

  /// Input field for the text of the tag in creation.
  TextFormField _tagTextInputField(Tag tag) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Tag text cannot be empty";
        }
        return null;
      },
      controller: _textController,
      decoration: Themes.inputDecoration(
        ref,
        "text",
        "text the tag should display",
      ),
      onChanged: (value) => setState(() {}),
    );
  }

  /// Title for the appbr, depending on the [_EditTagMode] mode.
  Text _appBarTitle(_EditTagMode mode) {
    return Text(
      mode == _EditTagMode.create ? "create tag" : "edit tag",
    );
  }
}
