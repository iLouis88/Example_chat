import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/message.dart';

class CommunicationChatMessageRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _listenLastMessage;
  final StreamController<List<MessageModel>> _streamLastMessage =
      StreamController.broadcast();

  Stream<List<MessageModel>> get streamLastMessage => _streamLastMessage.stream;
  static String? conversationId;
  CommunicationChatMessageRepository() {
    var user = _auth.currentUser;
    _listenLastMessage = _store
        .collection('chats/${getConversationID(guestId: user!.uid)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots()
        .listen((messageSnapshot) async {
      List<MessageModel> listMessage = _loadRawData(messageSnapshot);
      _streamLastMessage.add(listMessage);
    });
  }

  List<MessageModel> _loadRawData(
      QuerySnapshot<Map<String, dynamic>> messageSnapshot) {
    final listMessage = messageSnapshot.docs
        .map((doc) => MessageModel.fromJson(doc.data()))
        .toList();
    return listMessage;
  }

  // get conversation'id
  String getConversationID({required String guestId}) {
    var user = _auth.currentUser;
    // because conversationId is make from guestId and currentId but
    // so we have to make the same conversationId between 2 user
    return user!.uid.hashCode <= guestId.hashCode
        ? '${user.uid}_$guestId'
        : '${guestId}_${user.uid}';
  }

  void close() {
    _listenLastMessage?.cancel();
    _streamLastMessage.close();
  }
}
