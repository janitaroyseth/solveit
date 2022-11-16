import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/gif_picker.dart';

enum MessageType {
  text,
  image,
  gif,
}

/// Input field tailored for messages such as comments or inbox.
class MessageInputField extends StatefulWidget {
  /// [Function] to perform with the content in the
  /// message input field.
  final Function handler;

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
    required this.handler,
    required this.focusNode,
    this.camera = false,
    this.gallery = false,
    this.recording = false,
    this.gif = false,
  });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  late FocusNode focusNode;
  late bool isFocused;
  late TextEditingController textEditingController;
  bool displayOption = true;

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
          child: (isFocused && !displayOption) &&
                  ((widget.camera && widget.gallery) ||
                      (widget.gallery && widget.recording))
              ? IconButton(
                  //constraints: const BoxConstraints(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 10.0,
                  ),
                  onPressed: () {
                    setState(() {
                      displayOption = !displayOption;
                    });
                  },
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
                    if (widget.camera) _CameraButton(widget: widget),
                    if (widget.gallery) _GalleryButton(widget: widget),
                    if (widget.recording) const _RecordButton(),
                    if (widget.gif) _GifButton(widget: widget),
                  ],
                ),
        ),
        buildInputField(),
        _SendButton(
          textEditingController: textEditingController,
          widget: widget,
        ),
      ],
    );
  }

  Expanded buildInputField() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextField(
          onTap: () => setState(() {
            displayOption = false;
          }),
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
    );
  }
}

/// Button for sending the text message in the [MessageInputField].
class _SendButton extends StatefulWidget {
  /// Creates an instance of [_SendButton].
  const _SendButton({
    required this.textEditingController,
    required this.widget,
  });

  /// [TextEditingController] for the input field.
  final TextEditingController textEditingController;

  /// The [MessageInputField] widget.
  final MessageInputField widget;

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: const BoxConstraints(),
      onPressed: widget.textEditingController.text.isEmpty
          ? null
          : () {
              widget.widget
                  .handler(widget.textEditingController.text, MessageType.text);
              widget.textEditingController.clear();
              setState(() {});
            },
      icon: Icon(
        PhosphorIcons.paperPlaneTiltFill,
        color: widget.textEditingController.text.isEmpty
            ? Themes.primaryColor.withOpacity(0.4)
            : Themes.primaryColor.withOpacity(0.8),
        size: 32,
      ),
    );
  }
}

/// Button for opening gif modal window.
class _GifButton extends StatelessWidget {
  /// Creates an instance of [_GifButton].
  const _GifButton({required this.widget});

  /// The [MessageInputField] widget.
  final MessageInputField widget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(6.0),
      constraints: const BoxConstraints(),
      onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => GifPicker(handler: widget.handler)),
      icon: Icon(
        PhosphorIcons.gifFill,
        color: Themes.primaryColor.withOpacity(0.8),
        size: 32,
      ),
    );
  }
}

/// Button for recording a voice message.
class _RecordButton extends StatelessWidget {
  /// Creates an instance of [_RecordButton].
  const _RecordButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(6.0),
      constraints: const BoxConstraints(),
      onPressed: () {
        // TODO: stretch goal
      },
      icon: Icon(
        PhosphorIcons.microphoneFill,
        color: Themes.primaryColor.withOpacity(0.8),
        size: 32,
      ),
    );
  }
}

/// Button for opening camera and taking a picture to send.
class _CameraButton extends StatelessWidget {
  /// Creates an instance of [_CameraButton].
  const _CameraButton({required this.widget});

  /// The [MessageInputField] widget.
  final MessageInputField widget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(6.0),
      onPressed: () async {
        final XFile? pickedImage =
            await ImagePicker().pickImage(source: ImageSource.camera);

        if (pickedImage == null) return;

        widget.handler(File(pickedImage.path), MessageType.image);
      },
      icon: Icon(
        PhosphorIcons.cameraFill,
        color: Themes.primaryColor.withOpacity(0.8),
        size: 32,
      ),
    );
  }
}

/// Button for opening local storage and choosing an image to send.
class _GalleryButton extends StatelessWidget {
  /// Creates an instance of [_GalleryButton].
  const _GalleryButton({required this.widget});

  /// The [MessageInputField] widget.
  final MessageInputField widget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 10.0,
      ),
      onPressed: () async {
        final XFile? pickedImage =
            await ImagePicker().pickImage(source: ImageSource.gallery);

        if (pickedImage == null) return;

        widget.handler(File(pickedImage.path), MessageType.image);
      },
      icon: Icon(
        PhosphorIcons.imageFill,
        color: Themes.primaryColor.withOpacity(0.8),
        size: 32,
      ),
    );
  }
}
