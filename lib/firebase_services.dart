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
  static bool _isRingtonePlaying = false;
  static bool _isOnIncomingPage = false;
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
      {bool fromTerminated = false}) {
    if (message == null || message.data.isEmpty) return;

    final data = message.data;
    final type = data['type']?.toString() ?? '';
    final visitorId = data['visitor_id']?.toString() ?? '';

    // visitorId save
    if (type == 'incoming_request' && visitorId.isNotEmpty) {
      LocalStorage.localStorage.setString("visitor_id", visitorId);
    }

    // ringtone + vibration शुरू करो
    startVibrationAndRingtone();

    // Page navigation
    if (type == 'incoming_request') {
      navigateToVisitorsPage(message);
    } else if (type == 'sos_alert') {
      _navigateToSosPage(message);
    }
  }

  /// Vibrate & ringtone

  /// Vibrate & ringtone
  static Future<void> startVibrationAndRingtone() async {
    stopVibrationAndRingtone();
    if (_isRingtonePlaying) return; // already playing
    _isRingtonePlaying = true;

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: -1);
    }

    FlutterRingtonePlayer().play(
      ios: IosSounds.glass,
      fromAsset: "assets/sounds/ringtone.mp3",
      looping: true,
      asAlarm: false,
    );
    //
    // Auto stop after 59s
    _ringtoneTimer = Timer(const Duration(seconds: 20), () {
      stopVibrationAndRingtone();
    });
  }

  /// 🔴 Global Stop Function
  static void stopVibrationAndRingtone() {
    if (!_isRingtonePlaying) return;

    FlutterRingtonePlayer().stop();
    Vibration.cancel();
    _ringtoneTimer?.cancel();
    _ringtoneTimer = null;
    _isRingtonePlaying = false;

    print("🔕 Global ringtone stopped everywhere!");
  }

  /// Reset flags when page closed
  static void resetFlags() {
    _isRingtonePlaying = false;
    _isOnIncomingPage = false;
  }

  /// Visitors Page
  static void navigateToVisitorsPage(RemoteMessage message) {
    if (_isOnIncomingPage) return;
    _isOnIncomingPage = true;

    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => VisitorsIncomingRequestPage(
        message: message,
        setPageValue: (val) {
          _isOnIncomingPage = val;
          if (!val) resetFlags();
        },
      ),
    ));

    // Page open होने के बाद ringtone stop कर दो
    Future.delayed(const Duration(seconds: 20), () {
      stopVibrationAndRingtone();
    });
  }

  /// SOS Page
  static void _navigateToSosPage(RemoteMessage message) {
    if (_isOnIncomingPage) return;
    _isOnIncomingPage = true;

    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => SosIncomingAlert(
        message: message,
        setPageValue: (val) {
          _isOnIncomingPage = val;
          if (!val) resetFlags();
        },
      ),
    ));

    Future.delayed(const Duration(seconds: 50), () {
      stopVibrationAndRingtone();
    });
  }
}
