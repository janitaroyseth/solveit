import 'package:flutter/material.dart';

import 'tag.dart';
import 'tags_list.dart';

/// Represents a task as a list item used in a task list.
class TaskListItem extends StatelessWidget {
  /// The [title] or name of the task as string.
  final String title;

  /// The [description] of the task as string.
  final String description;

  /// The [deadline] of the task as string.
  final String deadline;

  /// List of [tags] (type Tag) connected to the task.
  final List<Tag> tags;

  /// Creates an instance of task list item where [titile] is the name of the
  /// task, [description] is the description of the task, [deadline] is the
  /// deadline of the task and [tags] is a list containing type Tag connected
  /// to the task.
  const TaskListItem({
    Key? key,
    required this.title,
    required this.description,
    required this.deadline,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 10.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
                blurRadius: 2.0,
                color: Colors.black38,
                blurStyle: BlurStyle.outer,
                offset: Offset(0.0, 0.0),
                spreadRadius: 0.5),
          ],
        ),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        title.toLowerCase(),
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text(
                        deadline,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    description,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TagsList(
                  tags: tags,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
