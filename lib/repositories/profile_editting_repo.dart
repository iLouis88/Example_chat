import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:savia/models/chat_user.dart';

class ProfileEdittingRepository {
  ChatUserModel? currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<ChatUserModel?> getCurrentUser() async {
    try {
      var userId = _auth.currentUser?.uid;
      var user = await _store.collection('users').doc(userId).get();
      currentUser = ChatUserModel.fromJson(user.data()!);
      return currentUser;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // update avatar
  Future<void> updateAvatar(File file) async {
    var user = _auth.currentUser;
    final ext = file.path.split('.').last;

    final ref = _storage.ref().child('profile_pictures/${user!.uid}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});

    currentUser!.image = await ref.getDownloadURL();
    await _store
        .collection('users')
        .doc(user.uid)
        .update({'image': currentUser!.image});
  }

  // update profile
  Future<void> updateProfile(
      {required String name,
      required String about,
      required String email,
      required String phoneNumber}) async {
    var user = _auth.currentUser;
    await _store.collection('users').doc(user!.uid).update({
      'name': name,
      'about': about,
      'email': email,
      'phone_number': phoneNumber
    });
  }
}
