import 'dart:math';

import 'package:project/models/tag.dart';
import 'package:project/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/services/comment_service.dart';
import 'package:project/services/tag_service.dart';

abstract class TaskService {
  /// Adds a new task or updates an existing task.
  Future<Task> saveTask(Task task);

  /// Returns a single task by taskId.
  Stream<Task?> getTask(String taskId);

  /// Returns all tasks.
  Stream<List<Task?>> getTasks(String projectId);

  /// Filters the task for a project with the given [projectId] from the given [query].
  Stream<List<Task?>> searchTask(String projectId, String query);

  Stream<List<Task>> filterTasksByTag(String projectId, List<Tag> tags);

  /// Deletes a task by task id.
  void deleteTask(String taskId);
}

class FirebaseTaskService extends TaskService {
  final taskCollection = FirebaseFirestore.instance.collection("tasks");
  final commentService = FirebaseCommentService();
  final tagService = FirebaseTagService();

  @override
  Future<Task> saveTask(Task task) async {
    if (task.taskId == "") {
      task.taskId = (await (taskCollection.add(task.toMap()))).id;
      await taskCollection.doc(task.taskId).set(task.toMap());
    } else {
      await taskCollection.doc(task.taskId).set(task.toMap());
    }
    return task;
  }

  @override
  Stream<Task?> getTask(String taskId) {
    return taskCollection
        .doc(taskId)
        .snapshots()
        .map((event) => event.data())
        .map((event) => Task.fromMap(event));
    // Map<String, dynamic>? taskMap =
    //     (await taskCollection.doc(taskId).get()).data();
    // if (null != taskMap) {
    //   task = Task.fromMap(taskMap);
    //   if (null != task) {
    //     List<Comment> comments = [];
    //     // Fetch and add task comments
    //     for (String commentId in taskMap["comments"]) {
    //       Comment? comment = await commentService.getComment(commentId);
    //       if (null != comment) {
    //         comments.add(comment);
    //       }
    //     }
    //     task.comments = comments;

    //     // Fetch and add task tags
    //     List<Tag> tags = [];
    //     for (String tagId in taskMap["tags"]) {
    //       Tag? tag = await tagService.getTag(tagId);
    //       if (null != tag) {
    //         tags.add(tag);
    //       }
    //     }
    //     task.tags = tags;
    //   }
    // }
    // return task;
  }

  @override
  Stream<List<Task?>> getTasks(String projectId) {
    return taskCollection
        .where("projectId", isEqualTo: projectId)
        .snapshots()
        .map((event) => event.docs)
        .map((event) => Task.fromMaps(event));
  }

  @override
  Stream<List<Task?>> searchTask(String projectId, String query) {
    return taskCollection
        .where("projectId", isEqualTo: projectId)
        .snapshots()
        .map((event) => event.docs)
        .map((event) {
      if (query.isEmpty) {
        return Task.fromMaps(event);
      }
      return Task.fromMaps(event)
          .where((element) => element
              .values()
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Stream<List<Task>> filterTasksByTag(String projectId, List<Tag> tags) {
    return taskCollection
        .where("projectId", isEqualTo: projectId)
        .snapshots()
        .map((event) => event.docs)
        .map((event) {
      return Task.fromMaps(event).where((element) {
        bool isTagInTask = false;

        for (Tag tag in tags) {
          isTagInTask = element.tags.contains(tag);
          if (isTagInTask) break;
        }

        return isTagInTask;
      }).toList();
    });
  }

  @override
  void deleteTask(String taskId) async {
    Map<String, dynamic>? map = (await taskCollection.doc(taskId).get()).data();
    if (null != map) {
      for (String commentId in map["comments"]) {
        commentService.deleteComment(commentId);
      }
    }
    taskCollection.doc(taskId).delete();
  }
}
