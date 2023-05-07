import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:savia/models/chat_user.dart';

class ContactRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _listenContactUser;

  final StreamController<List<ChatUserModel>> _streamContactUser =
      StreamController.broadcast();

  Stream<List<ChatUserModel>> get streamContactUser =>
      _streamContactUser.stream;
  ContactRepository() {
    final user = _auth.currentUser;
    _listenContactUser = _store
        .collection('users')
        .doc(user!.uid)
        .collection('contacts')
        .snapshots()
        .listen((chatIdSnapshot) async {
      List<ChatUserModel> listChatUser = await _loadRawData(chatIdSnapshot);
      _streamContactUser.add(listChatUser);
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

  Future<void> deleteContactUser({required String id}) async {
    var user = _auth.currentUser;
    await _deleteSecondCollection(user, id, 'contacts');
    await _deleteSecondCollection(user, id, 'chat_users');
  }

  Future<void> _deleteSecondCollection(
      User? user, String id, String textCollection) async {
    await _store
        .collection('users')
        .doc(user!.uid)
        .collection(textCollection)
        .doc(id)
        .delete();
  }

  Future<bool> addChatUser(String checkID) async {
    var user = _auth.currentUser;
    final data = await _store
        .collection('users')
        .where('check_id', isEqualTo: checkID)
        .get();
    if (data.docs.isNotEmpty && data.docs.first.id != user!.uid) {
      _store
          .collection('users')
          .doc(user.uid)
          .collection('chat_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      return false;
    }
  }

  void close() {
    _listenContactUser?.cancel();
    _streamContactUser.close();
  }
}
