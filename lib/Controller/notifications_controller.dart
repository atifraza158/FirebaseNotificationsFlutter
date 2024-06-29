import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  RxBool loader = false.obs;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requiestNotificationsPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Granted the Permissions");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User Granted Provisional Permissions");
    } else {
      print("User Denied Permissions");
    }
  }

  initLocalNotification(RemoteMessage message) async {
    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {});
  }

  firebaseInitialization() async {
    FirebaseMessaging.onMessage.listen((message) {
      print('Message Title: ${message.notification!.title}');
      print('Message body: ${message.notification!.body}');

      if (Platform.isAndroid) {
        initLocalNotification(message);
        showNotification(message);
      }

      showNotification(message);
    });
  }

  Future showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notification',
      importance: Importance.max,
    );

    // For Android..
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "You're Channel Description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    // iOS
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
        1,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  Future<String> getDeviceToken() async {
    var token = await messaging.getToken();
    return token!;
  }

  isTokenRefresh() async {
    messaging.onTokenRefresh.listen((token) {
      print('Token Status: ${token}');
    });
  }
}
