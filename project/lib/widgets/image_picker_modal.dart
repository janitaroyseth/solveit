import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/modal_list_item.dart';

/// Modal sheet displaying options for adding images.
class ImagePickerModal extends StatefulWidget {
  /// [Function] for what to do with the chosen image.
  final Function handler;

  /// [BuildContext] build context for the screen the modal is displayed on.
  final BuildContext buildContext;

  /// Creates an instance of [ImagePickerModal], which displays options for
  /// adding an image. Takes a [handler] parameter of type [Function], which should
  /// handle the chosen image.
  const ImagePickerModal({
    super.key,
    required this.handler,
    required this.buildContext,
  });

  @override
  State<ImagePickerModal> createState() => _ImagePickerModalState();
}

class _ImagePickerModalState extends State<ImagePickerModal> {
  /// image chosen.
  File? image;

  /// Opens up the phones camera and handles the picture taken.
  void getImageFromCamera() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage == null) return;

    image = File(pickedImage.path);
    widget.handler(image);
  }

  /// Opens up the phones local storage and handles the chosen image.
  void getImageFromLocalStorage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    image = File(pickedImage.path);
    widget.handler(image);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        height: 280,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 3,
                width: 100,
                decoration: BoxDecoration(
                  color: Themes.textColor(ref),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              ModalListItem(
                icon: PhosphorIcons.cameraLight,
                label: "take picture",
                handler: () {
                  getImageFromCamera();
                  Navigator.of(widget.buildContext).pop();
                },
              ),
              ModalListItem(
                icon: PhosphorIcons.imageLight,
                label: "upload image",
                handler: () {
                  getImageFromLocalStorage();
                  Navigator.of(widget.buildContext).pop();
                },
              ),
              const SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }
}
