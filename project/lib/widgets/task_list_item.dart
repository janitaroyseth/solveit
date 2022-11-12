import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:project/screens/task_details_screen.dart';
import '../models/task.dart';

import 'tags_list.dart';

/// Converts a Task object to a list item used in a task list.
class TaskListItem extends StatelessWidget {
  /// The [task] to be converted.
  final Task task;

  /// Creates an instance of [TaskListItem].
  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Divider(),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              TaskDetailsScreen.routeName,
              arguments: task,
            );
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
                        Jiffy(task.deadline!).format("dd/MM/yyyy"),
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
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
      ],
    );
  }
}
