import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:project/models/message.dart';
import 'package:project/models/group.dart';
import 'package:project/services/auth_service.dart';

/// Business logic for chats.
abstract class ChatService {
  /// Returns a future with the added group.
  Future<Group> saveGroup(Group group);

  /// Returns a future with the added chat.
  Future<Message> addChat(String groupId, Message chat);

  /// Returns a list of groups the current user is a member of.
  Stream<List<Group>> getGroups();

  /// Returns the group of the given [group id].
  Stream<Group?> getGroup(String groupId);

  /// Returns the chat messsages for the given [group id]
  Stream<List<Message>> getChats(String groupId);

  ///Delete's the chat with the given [chat id] in the group for the given
  ///[group id].
  Future<void> deleteChat(String groupId, String chatId);

  Future<void> deleteGroup(String groupId);
}

/// Firebase implementation of [ChatService]
class FirebaseChatService implements ChatService {
  final chatCollection = FirebaseFirestore.instance.collection("chats");
  final groupCollection = FirebaseFirestore.instance.collection("groups");

  @override
  Future<Message> addChat(String groupId, Message chat) async {
    if (chat.messageId == "") {
      chat.messageId = (await (chatCollection
              .doc(groupId)
              .collection("messages")
              .add(Message.toMap(chat))))
          .id;
    }
    await chatCollection
        .doc(groupId)
        .collection("messages")
        .doc(chat.messageId)
        .set(Message.toMap(chat));

    return chat;
  }

  @override
  Future<Group> saveGroup(Group group) async {
    if (group.groupId == "") {
      group.groupId = (await (groupCollection.add(group.toMap()))).id;
    }
    await groupCollection.doc(group.groupId).set(group.toMap());

    return group;
  }

  @override
  Future<void> deleteChat(String groupId, String chatId) {
    return chatCollection
        .doc(groupId)
        .collection("messages")
        .doc(chatId)
        .delete();
  }

  @override
  Stream<List<Message>> getChats(String groupId) {
    return chatCollection
        .doc(groupId)
        .collection("messages")
        .snapshots()
        .map((event) => event.docs)
        .map((event) {
      List<Message> chats = Message.fromMaps(event);
      chats.sort((b, a) => (a.date.compareTo(b.date)));
      return chats;
    });
  }

  @override
  Stream<List<Group>> getGroups() {
    return groupCollection
        .where("members", arrayContains: Auth().currentUser!.uid)
        .snapshots()
        .map((event) => event.docs)
        .map((event) {
      List<Group> groups = Group.fromMaps(event);
      groups.sort((b, a) => (a.lastUpdated.compareTo(b.lastUpdated)));
      return groups;
    });
  }

  @override
  Stream<Group?> getGroup(String groupId) {
    return groupCollection
        .doc(groupId)
        .snapshots()
        .map((event) => event.data())
        .map((event) => Group.fromMap(event!));
  }

  @override
  Future<void> deleteGroup(String groupId) {
    return groupCollection.doc(groupId).delete();
  }
}
