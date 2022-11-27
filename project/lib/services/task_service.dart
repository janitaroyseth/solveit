import 'dart:math';

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
