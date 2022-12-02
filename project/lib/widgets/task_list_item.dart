import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/screens/task_details_screen.dart';
import '../models/task.dart';

import 'tags_list.dart';

/// Converts a Task object to a list item used in a task list.
class TaskListItem extends ConsumerWidget {
  /// The [task] to be converted.
  final Task task;

  /// Creates an instance of [TaskListItem].
  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        const Divider(),
        InkWell(
          onTap: () {
            ref.read(editTaskProvider.notifier).setTask(task);
            ref.read(currentTaskProvider.notifier).setTask(
                ref.watch(taskProvider).getTask(task.projectId, task.taskId));
            Navigator.of(context).pushNamed(TaskDetailsScreen.routeName);
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
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        task.deadline != null
                            ? Jiffy(task.deadline).format("dd/MM/yyyy")
                            : "-",
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: task.description.isNotEmpty,
                  child: Container(
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
