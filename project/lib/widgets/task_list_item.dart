import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/task.dart';
import 'package:project/styles/theme.dart';
import 'package:project/utilities/date_formatting.dart';

import 'tags_list.dart';

/// Converts a Task object to a list item used in a task list.
class TaskListItem extends ConsumerWidget {
  /// The [task] to be converted.
  final Task task;

  final void Function() handler;

  /// Creates an instance of [TaskListItem].
  const TaskListItem({super.key, required this.task, required this.handler});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        const Divider(),
        InkWell(
          onTap: handler,
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
                        child: Row(
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                "${task.title.toLowerCase()} mklgmkldfmgkdlfmgkldfgmdfklmgkfldmgklfdmgkldmfgklmdfkglmfklgmdkfl",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Expanded(
                              child: Visibility(
                                visible: task.done,
                                child: Text(
                                  "- solved",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Themes.textColor(ref)
                                            .withOpacity(0.6),
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Visibility(
                                visible: !task.done,
                                child: Text(
                                  "- open",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Themes.primaryColor.shade50,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0)
                          ],
                        ),
                      ),
                      Text(
                        task.deadline != null
                            ? DateFormatting.shortDate(ref, task.deadline!)
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
