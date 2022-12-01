import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/chat.dart';
import 'package:project/models/group.dart';
import 'package:project/services/auth_service.dart';

abstract class ChatService {
  Future<Group> saveGroup(Group group);

  Future<Chat> addChat(String groupId, Chat chat);

  Stream<List<Group>> getGroups();

  Stream<Group?> getGroup(String groupId);

  Stream<List<Chat>> getChats(String groupId);

  Future<void> deleteChat(String chatId);
}

class FirebaseChatService implements ChatService {
  final chatCollection = FirebaseFirestore.instance.collection("chats");
  final groupCollection = FirebaseFirestore.instance.collection("groups");

  @override
  Future<Chat> addChat(String groupId, Chat chat) async {
    if (chat.chatId == "") {
      chat.chatId = (await (chatCollection
              .doc(groupId)
              .collection("messages")
              .add(chat.toMap())))
          .id;
      await chatCollection
          .doc(groupId)
          .collection("messages")
          .doc(chat.chatId)
          .set(chat.toMap());
    } else {
      await chatCollection
          .doc(groupId)
          .collection("messages")
          .doc(chat.chatId)
          .set(chat.toMap());
    }
    return chat;
  }

  @override
  Future<Group> saveGroup(Group group) async {
    if (group.groupId == "") {
      group.groupId = (await (groupCollection.add(group.toMap()))).id;
      await groupCollection.doc(group.groupId).set(group.toMap());
    } else {
      await groupCollection.doc(group.groupId).set(group.toMap());
    }

    return group;
  }

  @override
  Future<void> deleteChat(String chatId) {
    // TODO: implement deleteChat
    throw UnimplementedError();
  }

  @override
  Stream<List<Chat>> getChats(String groupId) {
    return chatCollection
        .doc(groupId)
        .collection("messages")
        .snapshots()
        .map((event) => event.docs)
        .map((event) {
      List<Chat> chats = Chat.fromMaps(event);
      chats.sort((b, a) => (a.createdAt.compareTo(b.createdAt)));
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
}
