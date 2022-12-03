import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/project.dart';
import 'package:project/models/task.dart';
import '../models/tag.dart';

abstract class TagService {
  /// Adds a tag to the database.
  Future<Tag?> saveTag({
    required Tag tag,
    required String projectId,
    String? taskId,
  });

  /// Returns a future tag by tag id.
  Future<Tag?> getTag(String projectId, String taskId, String tagId);

  /// Returns a future list of all default tags.
  Future<List<Tag>> getDefaultTags();

  /// returns a future list of all tags in given project.
  Future<List<Tag>> getProjectTags(String projectId);

  Future<List<Tag>> getTaskTags(String projectId, String taskId);

  /// Deletes a tag by tag id.
  Future<void> deleteTag(Tag tag, String projectId);
}

class FirebaseTagService extends TagService {
  final projectCollection = FirebaseFirestore.instance.collection("projects");
  CollectionReference<Map<String, dynamic>> taskCollection(String projectId) =>
      FirebaseFirestore.instance
          .collection("projects")
          .doc(projectId)
          .collection("tasks");
  CollectionReference<Map<String, dynamic>> taskTagCollection(
          String projectId, taskId) =>
      FirebaseFirestore.instance
          .collection("projects")
          .doc(projectId)
          .collection("tasks")
          .doc(taskId)
          .collection("tags");

  @override
  Future<Tag?> saveTag({
    required Tag tag,
    required String projectId,
    String? taskId,
  }) async {
    if (tag.tagId == "") {
      tag.tagId = (await (projectCollection
              .doc(projectId)
              .collection("tags")
              .add(tag.toMap())))
          .id;
      Project project = Project.fromMap(
          (await projectCollection.doc(projectId).get()).data())!;
      project.tags.add(tag);
      projectCollection.doc(projectId).set(project.toMap());
    }
    await projectCollection
        .doc(projectId)
        .collection("tags")
        .doc(tag.tagId)
        .set(tag.toMap());
    if (taskId != null) {
      await projectCollection
          .doc(projectId)
          .collection("tasks")
          .doc(taskId)
          .collection("tags")
          .doc(tag.tagId)
          .set(tag.toMap());
    }
    return tag;
  }

  @override
  Future<Tag?> getTag(String projectId, String taskId, String tagId) async {
    return Tag.fromMap((await projectCollection
            .doc(projectId)
            .collection("tags")
            .doc(tagId)
            .get())
        .data());
  }

  @override
  Future<List<Tag>> getProjectTags(String projectId) async {
    return Tag.fromMaps(
        (await projectCollection.doc(projectId).collection("tags").get()).docs);
  }

  @override
  Future<List<Tag>> getTaskTags(String projectId, String taskId) async {
    return Tag.fromMaps(
        (await taskTagCollection(projectId, taskId).get()).docs);
  }

  @override
  Future<List<Tag>> getDefaultTags() async {
    List<Tag> tags = [];
    for (var doc
        in (await FirebaseFirestore.instance.collection("tags").get()).docs) {
      Tag? tag = Tag.fromMap(doc.data());
      if (null != tag) {
        tags.add(tag);
      }
    }
    return tags;
  }

  @override
  Future<void> deleteTag(Tag tag, String projectId) {
    Project project;
    Task? task;
    return projectCollection
        .doc(projectId)
        .collection("tags")
        .doc(tag.tagId)
        .delete()
        .then((value) async => {
              for (var taskMap in (await taskCollection(projectId).get()).docs)
                {
                  task = Task.fromMap(taskMap.data()),
                  if (task != null)
                    {
                      if (task!.tags.remove(tag))
                        {
                          taskCollection(projectId)
                              .doc(task!.taskId)
                              .set(task!.toMap()),
                        },
                    }
                },
              project = Project.fromMap(
                  (await projectCollection.doc(projectId).get()).data())!,
              if (project.tags.remove(tag))
                {
                  projectCollection.doc(projectId).set(project.toMap()),
                },
            });
  }
}
