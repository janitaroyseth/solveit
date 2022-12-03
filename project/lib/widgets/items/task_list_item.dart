import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/task.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/styles/theme.dart';
import 'package:project/utilities/date_formatting.dart';
import 'package:project/widgets/general/loading_spinner.dart';
import 'package:project/widgets/list/tags_list.dart';

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
                            _taskTitle(context),
                            _taskSolvedText(context, ref),
                            _taskNotSolvedText(context),
                            const SizedBox(width: 8.0)
                          ],
                        ),
                      ),
                      _taskDeadline(ref, context)
                    ],
                  ),
                ),
                _taskDescription(context),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TagsList(tags: task.tags),
                    ),
                    _assignedList(ref),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the title of the task.
  Container _taskTitle(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.6),
      child: Text(
        task.title.toLowerCase(),
        textAlign: TextAlign.start,
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  /// If task is solved, it will return a visible text saying solved, if not
  /// it is invisible.
  Visibility _taskSolvedText(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: task.done,
      child: Text(
        " - solved",
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Themes.textColor(ref).withOpacity(0.6),
            ),
      ),
    );
  }

  /// If task is not solved it will return a text saying open, if it is solved
  /// it will be invisible.
  Visibility _taskNotSolvedText(BuildContext context) {
    return Visibility(
      visible: !task.done,
      child: Text(
        " - open",
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Themes.primaryColor.shade50,
            ),
      ),
    );
  }

  /// Returns the deadline of the task.
  Text _taskDeadline(WidgetRef ref, BuildContext context) {
    return Text(
      task.deadline != null
          ? DateFormatting.shortDate(ref, task.deadline!)
          : "-",
      style: Theme.of(context).textTheme.labelSmall,
    );
  }

  /// Returns the description of the task if it exists, if not it is not
  /// visible.
  Visibility _taskDescription(BuildContext context) {
    return Visibility(
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
    );
  }

  /// Returns a stack of the images of the assignees for the task represented in
  /// this task list item.
  Expanded _assignedList(WidgetRef ref) {
    return Expanded(
      child: SizedBox(
        height: 20,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(),
            ...task.assigned.map(
              (e) {
                int index = task.assigned.indexOf(e);
                if (index < 2 || task.assigned.length == 3) {
                  return _assignedListItem(index, e, ref);
                }

                if (index == 2 && task.assigned.length > 2) {
                  return _additionalAssignedListItem(index);
                }
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }

  /// Returns a positioned circle avatar displaying how many more assignees this
  /// task has.
  Positioned _additionalAssignedListItem(int index) {
    return Positioned(
      right: index.toDouble() * 15,
      child: CircleAvatar(
        radius: 10,
        backgroundColor: Themes.primaryColor.shade200,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: FittedBox(
            child: Text(
              "+ ${task.assigned.length - 2}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns a positioned circle avatar with an image of the user with the given
  /// user id.
  Positioned _assignedListItem(int index, String userId, WidgetRef ref) {
    return Positioned(
      right: index.toDouble() * 15,
      key: ValueKey(userId),
      child: StreamBuilder<User?>(
        stream: ref.watch(userProvider).getUser(userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CircleAvatar(
              radius: 10,
              backgroundImage: NetworkImage(snapshot.data!.imageUrl!),
            );
          }
          return const LoadingSpinner();
        },
      ),
    );
  }
}
