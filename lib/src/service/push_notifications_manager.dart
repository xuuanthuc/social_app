import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../preferences/app_preference.dart';
import '../utilities/logger.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late StreamSubscription _refreshTokenStreamSubscription;
  late StreamSubscription _onMessageStreamSubscription;
  late StreamSubscription _onMessageOpenedAppStreamSubscription;
  bool _initialized = false;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final StreamController<dynamic> _newMessageController =
      StreamController<dynamic>();

  Future<void> init() async {
    if (!_initialized) {
      _firebaseMessaging.requestPermission();
      _firebaseMessaging.setForegroundNotificationPresentationOptions();
      _refreshTokenStreamSubscription =
          _firebaseMessaging.onTokenRefresh.listen((newToken) {
            LoggerUtils.d("FirebaseMessaging newToken: $newToken");
        _saveFirebaseToken(newToken);
      });
      _onMessageStreamSubscription =
          FirebaseMessaging.onMessage.listen((remoteMessage) {
            LoggerUtils.d('onMessage = remoteMessage ${remoteMessage.data}');
        // String screenName = MyRouteObserver.currentScreenName;
        // PrefManager.saveReadNotice(false);
        // if (screenName == RouteConstants.flashJob.chatDetailScreen) return;
        _showLocalPush(remoteMessage);
      });
      _onMessageOpenedAppStreamSubscription =
          FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
        // PrefManager.saveReadNotice(false);
            LoggerUtils.d('onMessageOpenedApp = remoteMessage ${remoteMessage.data}');
        // String payload = json.encode(remoteMessage.data);
        // eventBus.fire(HandleWhenUserClickNotificationEvent(payload));
        // if (remoteMessage.data['reasonable_type'] == 'Survey') {
        //   eventBus.fire(NavigateWhenClickSurveyEvent(payload));
        // } else {
        //   eventBus.fire(NavigateWhenClickNotificationEvent(payload));
        // }
      });

      String token = await _firebaseMessaging.getToken() ?? '';
      _saveFirebaseToken(token);
      LoggerUtils.d("FirebaseMessaging token: $token");
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');
      final IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings(
              requestAlertPermission: false,
              requestBadgePermission: false,
              requestSoundPermission: false,
              onDidReceiveLocalNotification:
                  (int id, String? title, String? body, String? payload) async {
                debugPrint('newMessage Here?');
                _newMessageController.add(ReceivedNotification(
                    id: id,
                    title: title ?? '',
                    body: body ?? '',
                    payload: payload ?? ''));
              });
      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (String? payload) async {
        if (payload != null) {
          LoggerUtils.d('notification local payload: $payload');
          // Map<String, dynamic> data = json.decode(payload);
          // if (data['reasonable_type'] == 'Survey') {
          //   eventBus.fire(NavigateWhenClickSurveyEvent(payload));
          // } else {
          //   eventBus.fire(NavigateWhenClickNotificationEvent(payload));
          // }
          // eventBus.fire(HandleWhenUserClickNotificationEvent(payload));
        }
      });
      _initialized = true;
    }
  }

  void _showLocalPush(RemoteMessage remoteMessage) {
    _showNotificationWithNoBody(remoteMessage);
  }

  Future<void> _showNotificationWithNoBody(RemoteMessage remoteMessage) async {
    Map<String, dynamic> customData = remoteMessage.data;
    String id = customData['id'] ?? '1';
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            color: Color(0xff66BADA),
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
        int.parse(id),
        remoteMessage.notification?.title,
        remoteMessage.notification?.body,
        platformChannelSpecifics,
        payload: json.encode(customData));
  }

  static Future<void> myBackgroundMessageHandler(
      RemoteMessage remoteMessage) async {
    debugPrint(
        'myBackgroundMessageHandler --- message = ${remoteMessage.data}');
  }

  void close() {
    _newMessageController.close();
    _refreshTokenStreamSubscription.cancel();
    _onMessageStreamSubscription.cancel();
    _onMessageOpenedAppStreamSubscription.cancel();
    _initialized = false;
  }

  void _saveFirebaseToken(String token) async {
    await AppPreference().setFirebaseToken(token);
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}
