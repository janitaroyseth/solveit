import 'package:path/path.dart';
import 'package:project/models/project.dart';
import 'package:project/models/tag.dart';
import 'package:project/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/services/comment_service.dart';
import 'package:project/services/project_service.dart';
import 'package:project/services/tag_service.dart';

abstract class TaskService {
  /// Adds a new task or updates an existing task.
  Future<Task> saveTask(String projectId, Task task);

  /// Returns a single task by taskId.
  Stream<Task?> getTask(String projectId, String taskId);

  /// Returns all tasks.
  Stream<List<Task?>> getTasks(
    String projectId, {
    String field = "deadline",
    bool descending = true,
  });

  /// Filters the task for a project with the given [projectId] from the given [query].
  Stream<List<Task?>> searchTask(String projectId, String query);

  Stream<List<Task>> filterTasksByTag(String projectId, List<Tag> tags);

  /// Deletes a task by task id.
  void deleteTask(String projectId, String taskId);
}

class FirebaseTaskService extends TaskService {
  CollectionReference<Map<String, dynamic>> taskCollection(String projectId) =>
      FirebaseFirestore.instance
          .collection("projects")
          .doc(projectId)
          .collection("tasks");
  final commentService = FirebaseCommentService();
  final tagService = FirebaseTagService();

  @override
  Future<Task> saveTask(String projectId, Task task) async {
    if (task.taskId == "") {
      task.taskId = (await (taskCollection(projectId).add(task.toMap()))).id;
      await taskCollection(projectId).doc(task.taskId).set(task.toMap());
    } else {
      await taskCollection(projectId).doc(task.taskId).set(task.toMap());
    }
    Project? project =
        await FirebaseProjectService().getProject(task.projectId).first;
    project!.lastUpdated = DateTime.now().toIso8601String();
    await FirebaseProjectService().saveProject(project);

    return task;
  }

  @override
  Stream<Task?> getTask(String projectId, String taskId) {
    return taskCollection(projectId)
        .doc(taskId)
        .snapshots()
        .map((event) => event.data())
        .map((event) => Task.fromMap(event));
  }

  @override
  Stream<List<Task?>> getTasks(
    String projectId, {
    String field = "deadline",
    bool descending = false,
  }) {
    return taskCollection(projectId)
        .where(field)
        .snapshots()
        .map((event) => event.docs)
        .map((event) {
      List<Task?> tasks = Task.fromMaps(event);
      if (descending) {
        tasks.sort((b, a) {
          if (a!.toMap()[field] == null) {
            return -1;
          }
          if (b!.toMap()[field] == null) {
            return 1;
          }
          return (a.toMap()[field]).compareTo(b.toMap()[field]);
        });
      } else {
        tasks.sort((a, b) {
          if (a!.toMap()[field] == null) {
            return -1;
          }
          if (b!.toMap()[field] == null) {
            return 1;
          }
          return (a.toMap()[field]).compareTo(b.toMap()[field]);
        });
      }
      return tasks;
    });
  }

  @override
  Stream<List<Task?>> searchTask(String projectId, String query) {
    return taskCollection(projectId)
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
    return taskCollection(projectId)
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
  void deleteTask(String projectId, String taskId) async {
    Map<String, dynamic>? map =
        (await taskCollection(projectId).doc(taskId).get()).data();
    if (null != map) {
      for (String commentId in map["comments"]) {
        commentService.deleteComment(commentId);
      }
    }
    taskCollection(projectId).doc(taskId).delete();
  }
}
