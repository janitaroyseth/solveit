import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Represents a search bar used to filter through a list.
class SearchBar extends StatefulWidget {
  /// [placeholderText] - the text showing before user types.
  final String placeholderText;

  /// [textEditingController] - the text editing controller for this input field.
  final TextEditingController textEditingController;

  /// [searchFunction] - the function used for filtering the list.
  final Function searchFunction;

  final bool filter;

  /// [filterModal] - the modal window showing filtering options.
  final Widget? filterModal;

  /// Creates an instance of search bar.
  const SearchBar(
      {super.key,
      required this.placeholderText,
      required this.searchFunction,
      required this.textEditingController,
      this.filterModal,
      this.filter = false});

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
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
            child: TextField(
              controller: widget.textEditingController,
              onChanged: (value) => widget.searchFunction(value),
              style: const TextStyle(
                fontSize: 12,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(PhosphorIcons.magnifyingGlass),
                border: InputBorder.none,
                hintText: widget.placeholderText.toLowerCase(),
              ),
            ),
          ),
        ),
        widget.filter
            ? IconButton(
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
                      return widget.filterModal!;
                    },
                  );
                },
                icon: const Icon(
                  PhosphorIcons.fadersHorizontal,
                ),
              )
            : Container(),
      ],
    );
  }
}
