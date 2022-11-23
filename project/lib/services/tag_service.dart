import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tag.dart';

abstract class TagService {
  /// Adds a tag to the database.
  Future<Tag?> saveTag(Tag tag);

  /// Returns a future tag by tag id.
  Future<Tag?> getTag(String tagId);

  /// Returns a future list of all tags.
  Future<List<Tag>> getTags();

  /// Deletes a tag by tag id.
  void deleteTag(String tagId);
}

class FirebaseTagService extends TagService {
  final tagCollection = FirebaseFirestore.instance.collection("tags");

  @override
  Future<Tag?> saveTag(Tag tag) async {
    if (tag.tagId == "") {
      tag.tagId = (await tagCollection.add(tag.toMap())).id;
      return tag;
    } else {
      await tagCollection.doc(tag.tagId).set(tag.toMap());
      return tag;
    }
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
  void deleteTag(String tagId) {
    tagCollection.doc(tagId).delete();
  }
}
