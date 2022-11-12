import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/styles/theme.dart';

/// Input field tailored for messages such as comments or inbox.
class MessageInputField extends StatefulWidget {
  /// [FocusNode] to set on the input field.
  final FocusNode focusNode;

  /// Wherher to include camera option.
  final bool camera;

  /// Wherher to include camera option.
  final bool gallery;

  /// Wherher to include camera option.
  final bool recording;

  /// Whether to include a gif picker.
  final bool gif;

  /// Creates an instance of [MessageInputField].
  const MessageInputField({
    super.key,
    required this.focusNode,
    this.camera = false,
    this.gallery = false,
    this.recording = false,
    this.gif = false,
  });

  @override
  State<MessageInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<MessageInputField> {
  late FocusNode focusNode;
  late bool isFocused;
  late TextEditingController textEditingController;

  @override
  void initState() {
    focusNode = widget.focusNode;
    isFocused = focusNode.hasFocus;
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    focusNode.addListener(() => setState(() => isFocused = focusNode.hasFocus));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: widget.camera || widget.gallery || widget.recording,
          child: isFocused &&
                  ((widget.camera && widget.gallery) ||
                      (widget.gallery && widget.recording))
              ? IconButton(
                  //constraints: const BoxConstraints(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 10.0,
                  ),
                  onPressed: () {},
                  icon: Icon(
                    PhosphorIcons.plusCircleFill,
                    size: 40,
                    color: Themes.primaryColor.withOpacity(0.8),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.camera)
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(6.0),
                        onPressed: () async {
                          // TODO: finish implementing this function
                          final XFile? pickedImage = await ImagePicker()
                              .pickImage(source: ImageSource.camera);

                          if (pickedImage == null) return;
                        },
                        icon: Icon(
                          PhosphorIcons.cameraFill,
                          color: Themes.primaryColor.withOpacity(0.8),
                          size: 32,
                        ),
                      ),
                    if (widget.gallery)
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 10.0,
                        ),
                        onPressed: () async {
                          // TODO: finish implementing this function
                          final XFile? pickedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);

                          if (pickedImage == null) return;
                        },
                        icon: Icon(
                          PhosphorIcons.imageFill,
                          color: Themes.primaryColor.withOpacity(0.8),
                          size: 32,
                        ),
                      ),
                    if (widget.recording)
                      IconButton(
                        padding: const EdgeInsets.all(6.0),
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                        icon: Icon(
                          PhosphorIcons.microphoneFill,
                          color: Themes.primaryColor.withOpacity(0.8),
                          size: 32,
                        ),
                      ),
                    if (widget.gif)
                      IconButton(
                        padding: const EdgeInsets.all(6.0),
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                        icon: Icon(
                          PhosphorIcons.gifFill,
                          color: Themes.primaryColor.withOpacity(0.8),
                          size: 32,
                        ),
                      ),
                  ],
                ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              focusNode: focusNode,
              minLines: 1,
              maxLines: 5,
              onChanged: (value) => setState(() {}),
              controller: textEditingController,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              style: Themes.textTheme.bodyMedium,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(9.0),
                isDense: true,
                filled: true,
                fillColor: Themes.primaryColor.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.0,
                    color: Themes.primaryColor.withOpacity(0.1),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.0,
                    color: Themes.primaryColor.withOpacity(0.8),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.0,
                    color: Themes.primaryColor.withOpacity(0.4),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          constraints: const BoxConstraints(),
          onPressed: textEditingController.text.isEmpty
              ? null
              : () {
                  print("posting comment...");

                  textEditingController.text = "";
                  setState(() {});
                },
          icon: Icon(
            PhosphorIcons.paperPlaneTiltFill,
            color: textEditingController.text.isEmpty
                ? Themes.primaryColor.withOpacity(0.4)
                : Themes.primaryColor.withOpacity(0.8),
            size: 32,
          ),
        )
      ],
    );
  }
}
