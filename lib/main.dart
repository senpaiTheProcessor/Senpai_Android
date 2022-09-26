// ignore_for_file: avoid_print, annotate_overrides, prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:senpai/Call/CallScreen.dart';
import 'package:senpai/View/Splash.dart';
import 'package:senpai/View/Verification.dart';
import 'package:senpai/onboarding/home_onboradind.dart';
import 'package:senpai/onboarding/walletscreen.dart';
import 'Prefrence/prefrence.dart';
import 'onboarding/booking_Onborading.dart';
import 'onboarding/callscreen.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(

    //'badrustuts', 'High Importance Notification',
    'badrustuts', // id
    'High Importance Notifications', // title
    enableLights: true,
    enableVibration: true,
   // sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('background message ${message.messageId}');
  print('background message ${message.notification?.title}');
  //  try {
  //         print("message...${message.data['body'].toString()}");

  //         if (message.data['body'].toString().contains('sent you request') ||
  //             message.data['body']
  //                 .toString()
  //                 .contains('Accpeted your request') ||
  //             message.data['body']
  //                 .toString()
  //                 .contains('Rejected your request') ||
  //             message.data['body'].toString().contains('reviewed you') ||
  //             message.notification!.title
  //                 .toString()
  //                 .contains('Add Wallet Amount')) {
  //         } else {
  //           FlutterRingtonePlayer.playRingtone();
  //         }
  //       } catch (e) {
  //         print("Exception occurs.....");
  //       }


}


Future<void> main() async {
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Preference().instance();

  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sanpai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'OpenSans'),
      home: Splash(),
    );
  }
}
