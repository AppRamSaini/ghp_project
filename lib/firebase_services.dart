import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:ghp_society_management/view/resident/sos/sos_incoming_alert.dart';
import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';
import 'package:vibration/vibration.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class FirebaseNotificationService {
  static Timer? _ringtoneTimer;

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
        if (payload.isEmpty) return;

        final decoded = jsonDecode(payload);
        final type = decoded['type'] ?? '';
        final data = decoded['data'] ?? {};
        final title = decoded['title'] ?? '';
        final body = decoded['body'] ?? '';

        print("🔔 Notification tapped: type=$type, data=$data");

        final fakeMessage = RemoteMessage(
          data: Map<String, dynamic>.from(data),
          notification: RemoteNotification(title: title, body: body),
        );

        if (type == 'incoming_request') {
          navigateToVisitorsPage(fakeMessage);
        } else if (type == 'sos_alert') {
          _navigateToSosPage(fakeMessage);
        }
        },
    );

    _createNotificationChannels();
  }

  /// Notification Channels
  static Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel priorityChannel =
    AndroidNotificationChannel(
      'priority_channel',
      'Priority Notifications',
      description: 'High priority notifications with sound',
      importance: Importance.max,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('ringtone'),
    );

    const AndroidNotificationChannel customChannel = AndroidNotificationChannel(
      'custom_firebase_channel',
      'Custom Firebase Notifications',
      description: 'Custom handled notifications',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    final plugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await plugin?.createNotificationChannel(priorityChannel);
    await plugin?.createNotificationChannel(customChannel);
  }

  /// Show Notification
  static Future<void> showCustomNotification(
      {required RemoteMessage message, bool playSound = true}) async {
    final title = message.notification?.title ?? 'New Message';
    final body = message.notification?.body ?? 'You have a new message';
    final type = message.data['type'] ?? '';

    final channelId = (type == 'incoming_request' || type == 'sos_alert')
        ? 'priority_channel'
        : 'custom_firebase_channel';

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      channelId == 'priority_channel'
          ? "Priority Notifications"
          : "General Notifications",
      channelDescription: 'App notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: playSound && (type == 'incoming_request' || type == 'sos_alert'),
    );

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      sound: playSound && (type == 'incoming_request' || type == 'sos_alert')
          ? "ringtone.caf"
          : null,
      presentAlert: true,
      presentBadge: true,
      presentSound: playSound && (type == 'incoming_request' || type == 'sos_alert'),
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

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

    print(
        "✅ Notification shown: $title - type: $type - playSound: $playSound");
  }

  /// Foreground & Background ringtone
  static Future<void> startVibrationAndRingtone() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: -1);
    }
    FlutterRingtonePlayer().play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.alarm,
      looping: true,
      volume: 1.0,
      asAlarm: true,
    );
    print("▶️ Ringtone & vibration started");

    _ringtoneTimer = Timer(const Duration(seconds: 15), () {
      stopVibrationAndRingtone();
    });
  }

  static void stopVibrationAndRingtone() {
    FlutterRingtonePlayer().stop();
    Vibration.cancel();
    _ringtoneTimer?.cancel();
    _ringtoneTimer = null;
    print("⏹️ Ringtone & vibration stopped!");
  }

  /// Navigation
  static void handleMessage(RemoteMessage? message,
      {String source = "unknown"}) async {
    if (message == null || message.data.isEmpty) return;

    final type = message.data['type'] ?? '';
    print("📩 HandleMessage from: $source | type: $type");

// Navigate
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
          if (val) stopVibrationAndRingtone();
        },
      ),
    ));
  }

  static void _navigateToSosPage(RemoteMessage message) {
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => SosIncomingAlert(
        message: message,
        setPageValue: (val) {
          if (val) stopVibrationAndRingtone();
        },
      ),
    ));
  }
}


