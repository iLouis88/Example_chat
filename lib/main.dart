import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:savia/firebase_options.dart';
import 'my_app.dart';

Future<void> backgrounHandler(RemoteMessage message)
async{
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
    actionButtons: [
      NotificationActionButton(key: "ACCEPT", label: "Accept Call",
        color: Colors.green,
        autoDismissible: true,
      ),
      NotificationActionButton(key: "No", label: "No Call",
        color: Colors.red,
        autoDismissible: true,
      ),
    ]
  );
}
Future<void> main() async {

  AwesomeNotifications().initialize(null, [
    NotificationChannel(channelKey: "call_channel",
        channelName: "Call Channel",
        channelDescription: "Channel of calling",
      defaultColor: Colors.cyan,
      ledColor: Colors.white,
      importance: NotificationImportance.Max,
      channelShowBadge: true,
      locked: true,
      defaultRingtoneType: DefaultRingtoneType.Ringtone
    )
  ]);
  FirebaseMessaging.onBackgroundMessage(backgrounHandler);
  WidgetsFlutterBinding.ensureInitialized();
  // full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
    // runApp(
    //   DevicePreview(
    //     enabled: !kReleaseMode,
    //     builder: (context) => const MyApp(), // Wrap your app
    //   ),
    // );
  });
}
