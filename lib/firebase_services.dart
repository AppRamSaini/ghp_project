import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ghp_society_management/view/resident/sos/sos_incoming_alert.dart';
import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';
import 'package:ghp_society_management/view/resident/visitors/ringplay_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class FirebaseNotificationService {
  /// Initialize Notification Handling
  static Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload ?? '';
        print('Received MSG In onDidReceiveNotificationResponse : - $payload');
        if (payload.isEmpty) return;

        final decoded = jsonDecode(payload);

        final data = decoded['data'] ?? {};
        final type = data['type'] ?? '';
        final title = decoded['title'] ?? '';
        final body = decoded['body'] ?? '';

        print("🔔 Notification tapped by user: type=$type, data=$data");

        final fakeMessage = RemoteMessage(
            data: Map<String, dynamic>.from(data),
            notification: RemoteNotification(title: title, body: body));
        if (type == 'incoming_request') {
          navigateToVisitorsPage(fakeMessage);
        } else if (type == 'sos_alert') {
          _navigateToSosPage(fakeMessage);
        }
      },
    );
    _createNotificationChannels();
  }

  static Future<void> _createNotificationChannels() async {
    final plugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    // 🔹 Delete old channels to enforce sound update
    final channels = await plugin?.getNotificationChannels();
    for (var ch in channels ?? []) {
      if (ch.id == 'priority_channel' || ch.id == 'silent_channel') {
        await plugin?.deleteNotificationChannel(ch.id);
        print("🔔 Deleted old channel: ${ch.id}");
      }
    }

    // 🔹 Priority Channel (with ringtone)
    final AndroidNotificationChannel priorityChannel =
        AndroidNotificationChannel(
      'priority_channel',
      'Priority Notifications',
      description: 'Incoming requests / SOS alerts with ringtone',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound(
          'ringtone'), // res/raw/ringtone.mp3
    );

    // 🔹 Silent Channel
    final AndroidNotificationChannel silentChannel =
        const AndroidNotificationChannel(
      'silent_channel',
      'Silent Notifications',
      description: 'Other notifications without ringtone',
      importance: Importance.high,
      playSound: false,
    );

    await plugin?.createNotificationChannel(priorityChannel);
    await plugin?.createNotificationChannel(silentChannel);
    print("🔔 Channels recreated ✅");
  }

  static Future<void> showCustomNotification(
      {required RemoteMessage message}) async {
    final type = message.data['type'] ?? '';
    final title = message.data['title'] ?? 'New Message';
    final body = message.data['body'] ?? 'You have a new message';

    // 🔹 हर notification से पहले channel recreate करें
    await _createNotificationChannels();

    final channelId = (type == 'incoming_request' || type == 'sos_alert')
        ? 'priority_channel'
        : 'silent_channel';

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelId == 'priority_channel'
          ? "Priority Notifications"
          : "Silent Notifications",
      channelDescription: 'App notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: channelId == 'priority_channel',
      sound: channelId == 'priority_channel'
          ? const RawResourceAndroidNotificationSound('ringtone')
          : null,
      enableVibration: true,
    );

    final iosDetails = DarwinNotificationDetails(
      sound: (type == 'incoming_request' || type == 'sos_alert')
          ? 'ringtone.caf'
          : null,
      presentAlert: true,
      presentBadge: true,
      presentSound: type == 'incoming_request' || type == 'sos_alert',
    );

    final details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    final payload = jsonEncode({
      "type": type,
      "data": message.data,
      "title": title,
      "body": body,
    });

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );

    print("✅ Notification shown (type=$type → channel=$channelId)");
  }

  /// Navigation
  static void handleMessage(RemoteMessage? message,
      {String source = "unknown"}) async {
    if (message == null || message.data.isEmpty) return;

    final type = message.data['type'] ?? '';
    print("📩 HandleMessage from: $source | type: $type");

    if (type == 'incoming_request') {
      navigateToVisitorsPage(message);
    } else if (type == 'sos_alert') {
      _navigateToSosPage(message);
    }
  }

  static void navigateToVisitorsPage(RemoteMessage message) {
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => VisitorsIncomingRequestPage(
        message: message,
        setPageValue: (val) {
          if (val) FirebaseNotificationRingServices.stopVibrationAndRingtone();
        },
      ),
    ));
  }

  static void _navigateToSosPage(RemoteMessage message) {
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => SosIncomingAlert(
        message: message,
        setPageValue: (val) {
          if (val) FirebaseNotificationRingServices.stopVibrationAndRingtone();
        },
      ),
    ));
  }
}
