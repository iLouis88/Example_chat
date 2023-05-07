import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:savia/models/chat_user.dart';

class ChatRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _listenChatUsers;

  final StreamController<List<ChatUserModel>> _streamChatUsers =
      StreamController.broadcast();

  Stream<List<ChatUserModel>> get streamChatUsers => _streamChatUsers.stream;

  ChatRepository() {
    final user = _auth.currentUser;
    _listenChatUsers = _store
        .collection('users')
        .doc(user!.uid)
        .collection('chat_users')
        .snapshots()
        .listen((chatIdSnapshot) async {
      List<ChatUserModel> listChatUser = await _loadRawData(chatIdSnapshot);
      // TODO: bad state
      _streamChatUsers.add(listChatUser);
    });
  }





  Future<List<ChatUserModel>> _loadRawData(
      QuerySnapshot<Map<String, dynamic>> chatIdSnapshot) async {
    final listChatId = chatIdSnapshot.docs.map((doc) => doc.id).toList();
    final chatUserSnapshot = await _store
        .collection('users')
        .where('id', whereIn: listChatId.isEmpty ? [''] : listChatId)
        .get();
    final listChatUser = chatUserSnapshot.docs
        .map((doc) => ChatUserModel.fromJson(doc.data()))
        .toList();
    return listChatUser;
  }

  void close() {
    _listenChatUsers?.cancel();
    _streamChatUsers.close();
  }

  // add id of another user to chat_users collection
  Future<bool> addChatUser(String checkID) async {
    var user = _auth.currentUser;
    final data = await _store
        .collection('users')
        .where('check_id', isEqualTo: checkID)
        .get();
    if (data.docs.isNotEmpty && data.docs.first.id != user!.uid) {
      _setSecondCollection(
          user: user, data: data, textCollection: 'chat_users');
      _setSecondCollection(user: user, data: data, textCollection: 'contacts');

      return true;
    } else {
      return false;
    }
  }

  void _setSecondCollection(
      {required User user,
      required QuerySnapshot<Map<String, dynamic>> data,
      required String textCollection}) {
    _store
        .collection('users')
        .doc(user.uid)
        .collection(textCollection)
        .doc(data.docs.first.id)
        .set({});
  }

  Future<void> deleteChatUser({required String id}) async {
    var user = _auth.currentUser;
    await _store
        .collection('users')
        .doc(user!.uid)
        .collection('chat_users')
        .doc(id)
        .delete();
  }
}
