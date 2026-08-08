import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ufc_delivery_app/config/dio.dart';
import 'package:ufc_delivery_app/shared/utils/log/log_utils.dart';

class FirebaseNotification {
  FirebaseNotification();

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );

  static Future<void> initMessaging() async {
    await messaging.requestPermission();

    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSetting = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await flutterLocalNotificationsPlugin
        .initialize(const InitializationSettings(
      iOS: iosSetting,
      android: androidSetting,
    ));

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await messaging.getToken();
    debugLog('Token FCM: $token');
    await registerFCM(token);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        log('Message also contained a notification: ${notification.body ?? ''} title: ${notification.title ?? ''}');

        await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }

  static Future<void> registerFCM(String? fcmToken) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appVersion = packageInfo.version;
      // String deviceModel = '';
      String deviceOSName = '';
      String deviceOSVersion = '';
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        deviceOSVersion = androidInfo.version.release;
        // deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
        deviceOSName = 'Android';
      }
      if (Platform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        deviceOSVersion = iosInfo.systemVersion;
        // deviceModel = iosInfo.name!;
        deviceOSName = 'iOS';
      }
      var data = {
        'os': deviceOSName,
        'os_version': deviceOSVersion,
        'os_type': deviceOSName,
        'app_version': appVersion,
        'fcm': fcmToken,
      };

      Response response =
          await api.post('/api/ufc-logistics/v1/driver/meta-data', data: data);

      debugPrint('sys in ${response.data}');
      // debugPrint('sys in $data');
    } on DioException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> removeToken() async {
    try {
      await messaging.deleteToken();
      print("fcm token removed");
    } catch (e) {
      print("Error removing token: $e");
    }
  }
}
