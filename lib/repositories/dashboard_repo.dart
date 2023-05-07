import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:savia/models/chat_user.dart';
import 'dart:developer';

class DashboardRepository {
  ChatUserModel? currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // get the chatusermodel of currentuser
  Future<ChatUserModel?> getCurrentUser() async {
    try {
      var userId = _auth.currentUser?.uid;
      var user = await _store.collection('users').doc(userId).get();
      currentUser = ChatUserModel.fromJson(user.data()!);
      // when user enter app => update status of user is online
      await getFirebaseMessagingToken(currentUser: currentUser!);
      return currentUser;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // get firebase message token
  Future<void> getFirebaseMessagingToken(
      {required ChatUserModel currentUser}) async {
    var user = _auth.currentUser;
    await _messaging.requestPermission();

    await _messaging.getToken().then((token) {
      if (token != null) {
        currentUser.pushToken = token;
        _updatePushToken(user, token);
      }
    });
  }

  void _updatePushToken(User? user, String token) {
    _store.collection('users').doc(user!.uid).update({'push_token': token});
  }

  Future<void> updateUserStatus({required bool status}) async {
    var user = _auth.currentUser;
    await _store.collection('users').doc(user!.uid).update({
      'is_online': status,
    });
  }

  // check user exist
  Future<bool> checkUserExist() async {
    return (await _store.collection('users').doc(_auth.currentUser!.uid).get())
        .exists;
  }

  String _generateRandomString() {
    Random random = Random();
    String result = '';
    for (int i = 0; i < 6; i++) {
      result += random.nextInt(10).toString();
    }
    return result;
  }

  // when new user is created => push their data too datastore
  Future<void> createNewDataUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = ChatUserModel(
        image:
            'https://firebasestorage.googleapis.com/v0/b/savia-de0b4.appspot.com/o/profile_pictures%2Fs2Cl4xfoiSXXxKFiybyoZVBvTXV2.jpg?alt=media&token=a873b424-48c7-4605-ac91-950ae28a18f4',
        about: 'Introduce',
        name: 'Name',
        createdAt: time,
        lastActive: time,
        id: _auth.currentUser!.uid,
        isOnline: false,
        checkId: _generateRandomString(),
        email: '',
        gender: 'Không xác định',
        pushToken: '',
        phoneNumber: '');
    await _store
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set(chatUser.toJson());
  }
}
