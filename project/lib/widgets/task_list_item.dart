import 'package:flutter/material.dart';
import '../models/task.dart';

import 'tags_list.dart';

/// Converts a Task object to a list item used in a task list.
class TaskListItem extends StatelessWidget {
  /// The [task] to be converted.
  final Task task;

  /// Creates an instance of task list item where [task.title] is the name of the
  /// task, [task.description] is the description of the task, [task.deadline] is the
  /// deadline of the task and [task.tags] is a list containing type Tag connected
  /// to the task.
  const TaskListItem({super.key, required this.task});

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
          onTap: () {
            Navigator.pushNamed(context, '/task', arguments: task);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          task.title.toLowerCase(),
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      Text(
                        task.deadline!,
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    task.description,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TagsList(
                  tags: task.tags,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
