import 'package:firebase_notifications/Controller/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotificationsController notificationsController =
      Get.put(NotificationsController());

  @override
  void initState() {
    super.initState();
    notificationsController.requiestNotificationsPermissions();
    notificationsController.firebaseInitialization();
    // notificationsController.isTokenRefresh();
    notificationsController.getDeviceToken().then((value) {
      print("Device Token ${value}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home View"),
      ),
      body: Center(
        child: Text("Notification App"),
      ),
    );
  }
}
