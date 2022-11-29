import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/task.dart';
import 'package:project/services/project_service.dart';
import 'package:project/services/task_service.dart';
import '../models/tag.dart';

abstract class TagService {
  /// Adds a tag to the database.
  Future<Tag?> saveTag({
    Tag? oldTag,
    required Tag tag,
    required String projectId,
  });

  /// Returns a future tag by tag id.
  Future<Tag?> getTag(String tagId);

  /// Returns a future list of all tags.
  Future<List<Tag>> getTags();

  /// Deletes a tag by tag id.
  Future<void> deleteTag(Tag tag, String projectId);
}

class FirebaseTagService extends TagService {
  final tagCollection = FirebaseFirestore.instance.collection("tags");

  @override
  Future<Tag?> saveTag({
    Tag? oldTag,
    required Tag tag,
    required String projectId,
  }) async {
    return FirebaseProjectService().getProject(projectId).first.then((project) {
      if (oldTag == null || project!.tags.contains(oldTag)) {
        project!.tags.add(tag);
      } else {
        project.tags.remove(oldTag);
        project.tags.add(tag);
      }
      FirebaseProjectService().saveProject(project);
      return tag;
    });
  }

  @override
  Future<Tag?> getTag(String tagId) async {
    return Tag.fromMap((await tagCollection.doc(tagId).get()).data());
  }

  @override
  Future<List<Tag>> getTags() async {
    List<Tag> tags = [];
    for (var doc in (await tagCollection.get()).docs) {
      Tag? tag = Tag.fromMap(doc.data());
      if (null != tag) {
        tags.add(tag);
      }
    }
    return tags;
  }

  @override
  Future<void> deleteTag(Tag tag, String projectId) {
    return FirebaseProjectService().getProject(projectId).first.then((project) {
      project!.tags.remove(tag);
      FirebaseTaskService().getTasks(projectId).first.then((tasks) {
        for (Task? task in tasks) {
          task!.tags.remove(tag);
          FirebaseTaskService().saveTask(task);
        }
      }).then((_) => FirebaseProjectService().saveProject(project));
    });
  }
}
