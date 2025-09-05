import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:ghp_society_management/constants/export.dart';
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

    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (response) {
      print("🔔 Notification tapped: ${response.payload}");
    });
  }

  /// Handle message safely
  static void handleMessage(RemoteMessage? message,
      {bool fromTerminated = false}) async {
    if (message == null || message.data.isEmpty) return;

    final data = message.data;
    final type = data['type']?.toString() ?? '';
    final visitorId = data['visitor_id']?.toString() ?? '';

    // Save visitorId
    if (type == 'incoming_request' && visitorId.isNotEmpty) {
      LocalStorage.localStorage.setString("visitor_id", visitorId);
    }

    // // 🔔 Play alerts
    // if (type == 'incoming_request' || type == 'sos_alert') {
    //   startVibrationAndRingtone();
    // }

    // Page navigation
    if (type == 'incoming_request') {
      navigateToVisitorsPage(message);
    } else if (type == 'sos_alert') {
      _navigateToSosPage(message);
    }
  }

  /// Vibrate & ringtone
  static Future<void> startVibrationAndRingtone() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: -1);
    }
    FlutterRingtonePlayer().play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.alarm,
      looping: true,
      volume: 1.0,
      asAlarm: true, // required for iOS
    );
    print("▶️ Ringtone & vibration started");
    _ringtoneTimer = Timer(const Duration(seconds: 15), () {
      stopVibrationAndRingtone();
    });
  }

  /// 🔴 Global Stop Function
  static void stopVibrationAndRingtone() {
    FlutterRingtonePlayer().stop();
    Vibration.cancel();
    _ringtoneTimer?.cancel();
    _ringtoneTimer = null;
    print("⏹️ Global ringtone & vibration stopped!");
  }

  /// Visitors Page
  static void navigateToVisitorsPage(RemoteMessage message) {
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => VisitorsIncomingRequestPage(
        message: message,
        setPageValue: (val) {
          if (val) stopVibrationAndRingtone();
        },
      ),
    ));
    // _ringtoneTimer = Timer(const Duration(seconds: 10), () {
    //   stopVibrationAndRingtone();
    // });
  }

  /// SOS Page
  static void _navigateToSosPage(RemoteMessage message) {
    navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => SosIncomingAlert(
            message: message,
            setPageValue: (val) {
              if (val) stopVibrationAndRingtone();
            })));
    _ringtoneTimer = Timer(const Duration(seconds: 15), () {
      stopVibrationAndRingtone();
    });
  }
}
