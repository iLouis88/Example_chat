import 'dart:convert';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:savia/main.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:savia/constant/text_constant.dart';
import 'package:savia/models/chat_user.dart';
import 'package:savia/models/message.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallPage extends StatefulWidget {
  final ChatUserModel guestUser;
  final ChatUserModel currentUser;
  final bool? isVideoCall;

  const VideoCallPage(
      {super.key,
        required this.guestUser,
        required this.currentUser,
        required this.isVideoCall});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String? title=message.notification!.title;
      String? body=message.notification!.body;
      AwesomeNotifications().createNotification(content: NotificationContent(id: 123,
        channelKey: "call_channel",
        color: Colors.white,
        title: title,
        body: body,
        category: NotificationCategory.Call,
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: false,
        backgroundColor: Colors.orange,
      ),

      );
     });

    final initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {});

    pushMessageNotification(
        currentUser: widget.currentUser,
        guestUser: widget.guestUser,
        title: widget.isVideoCall!
            ? ' ${widget.currentUser.name} is calling you'
            : ' ${widget.currentUser.name} is calling you');
  }

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID: TextConstant.appIDVideoCall,
        appSign: TextConstant.appSignVideoCall,
        userID: widget.guestUser.checkId,
        userName: widget.guestUser.name,
        callID: _getConversationID(guestId: widget.guestUser.id),
        onDispose: () {
          sendMessage(
              guestUser: widget.guestUser,
              currentUser: widget.currentUser,
              msg: widget.isVideoCall!
                  ? 'Call ended'
                  : 'Call ended',
              type: Type.text);
        },
        config: widget.isVideoCall!
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall());
  }

  Future<void> sendMessage(
      {required ChatUserModel guestUser,
        required ChatUserModel currentUser,
        required String msg,
        required Type type}) async {
    final user = _auth.currentUser;
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final MessageModel message = MessageModel(
        toId: guestUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user!.uid,
        sent: time);

    // create message with document is the time of message
    final ref = _store.collection(
        'chats/${_getConversationID(guestId: guestUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());

    // create lass_message collection
    final lastMessageRef = _store.collection(
        'chats/${_getConversationID(guestId: guestUser.id)}/last_message');
    await lastMessageRef.doc('message').set(message.toJson());

  }

  // get conversation'id
  String _getConversationID({required String guestId}) {
    var user = _auth.currentUser;

    return user!.uid.hashCode <= guestId.hashCode
        ? '${user.uid}_$guestId'
        : '${guestId}_${user.uid}';
  }



  Future<void> pushMessageNotification(
      {required ChatUserModel currentUser,
        required String title,
        required ChatUserModel guestUser}) async {
    try {
      final body = {
        "to": guestUser.pushToken,
        "notification": {
          "title": title,
          //our name should be send
          "body": '${widget.currentUser.name} call',
          "android_channel_id": "chats"
        },
      };

      await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
            'key=${TextConstant.serviceKeyForNotification}'
          },
          body: jsonEncode(body));
      final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );
      final iOSPlatformChannelSpecifics = IOSNotificationDetails();
      final platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await _flutterLocalNotificationsPlugin.show(
          0,
          title,
          '${widget.currentUser.name} is calling',
          platformChannelSpecifics,
          payload: '');

    } catch (e) {
      throw Exception(e);
    }
  }
}
