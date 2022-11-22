import 'package:project/models/comment.dart';
import 'package:project/models/tag.dart';
import 'package:project/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/services/comment_service.dart';
import 'package:project/services/tag_service.dart';

abstract class TaskService {
  /// Adds a new task or updates an existing task.
  Future<Task> saveTask(Task task);

  /// Returns a single task by taskId.
  Future<Task?> getTask(String taskId);

  /// Returns all tasks.
  Future<List<Task>> getTasks();

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
    } else {
      await taskCollection.doc(task.taskId).set(task.toMap());
    }
    return task;
  }

  @override
  Future<Task?> getTask(String taskId) async {
    Task? task;
    Map<String, dynamic>? taskMap =
        (await taskCollection.doc(taskId).get()).data();
    if (null != taskMap) {
      task = Task.fromMap(taskMap);
      if (null != task) {
        // Fetch and add task comments
        for (String commentId in taskMap["comments"]) {
          Comment? comment = await commentService.getComment(commentId);
          if (null != comment) {
            task.comments.add(comment);
          }
        }

        // Fetch and add task tags
        for (String tagId in taskMap["tags"]) {
          Tag? tag = await tagService.getTag(tagId);
          if (null != tag) {
            task.tags.add(tag);
          }
        }
      }
    }
    return task;
  }

  @override
  Future<List<Task>> getTasks() async {
    List<Task> tasks = [];
    await taskCollection.get().then((value) async {
      for (var doc in value.docs) {
        tasks.add((await getTask(doc.id))!);
      }
    });
    return tasks;
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
