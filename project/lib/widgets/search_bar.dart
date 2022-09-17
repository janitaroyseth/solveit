import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Represents a search bar used to filter through a list.
class SearchBar extends StatefulWidget {
  /// [textEditingController] - the text editing controller for this input field.
  final TextEditingController textEditingController;

  /// [searchFunction] - the function used for filtering the list.
  final Function searchFunction;

  /// [filterModal] - the modal window showing filtering options.
  final Widget filterModal;

  /// Creates an instance of search bar.
  const SearchBar(
      {super.key,
      required this.searchFunction,
      required this.textEditingController,
      required this.filterModal});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              controller: widget.textEditingController,
              onChanged: (value) => widget.searchFunction(value),
              style: const TextStyle(
                fontSize: 12,
              ),
              decoration: const InputDecoration(
                prefixIcon: Icon(PhosphorIcons.magnifyingGlass),
                border: InputBorder.none,
                hintText: "search for tasks...",
                focusColor: Colors.amber,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              context: context,
              builder: (context) {
                return widget.filterModal;
              },
            );
          },
          icon: const Icon(
            PhosphorIcons.fadersHorizontal,
          ),
        ),
      ],
    );
  }
}
