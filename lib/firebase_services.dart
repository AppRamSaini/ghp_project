import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/accept_request/accept_request_cubit.dart';
import 'package:ghp_society_management/view/resident/sos/sos_incoming_alert.dart';
import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';
import 'package:vibration/vibration.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class FirebaseNotificationService {
  static bool _isRingtonePlaying = false;
  static bool _isOnIncomingPage = false;

  /// Initialize Firebase Notification Handling
  static Future<void> initialize() async {
    final messaging = FirebaseMessaging.instance;

    // Request permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Foreground
      FirebaseMessaging.onMessage.listen((message) {
        print('Foreground message: ${message.data}');
        handleMessage(message, isForeground: true);
      });

      // Background tapped
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('Background tapped: ${message.data}');
        handleMessage(message, isForeground: false);
      });

      // Terminated -> first launch via notification
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          print('Terminated app launch: ${message.data}');
          handleMessage(message, isForeground: false, fromTerminated: true);
        }
      });
      final token = Platform.isIOS ?  await FirebaseMessaging.instance.getAPNSToken() : await FirebaseMessaging.instance.getToken();

      print("FCM $token");
      // Background handler registration (Android)
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }
  }

  /// Background handler (runs in separate isolate)
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("BG/Terminated message: ${message.data}");
    await _showLocalNotification(message); //
  }

  /// Handle message
  static void handleMessage(RemoteMessage message,
      {bool isForeground = false, bool fromTerminated = false}) {
    final data = message.data;
    final type = data['type'] ?? '';

    if (type == 'incoming_request') {
      LocalStorage.localStorage.setString("visitor_id", data['visitor_id']);
      if (isForeground) startVibrationAndRingtone(); // 🔊 foreground ringtone
      _navigateToVisitorsPage(message, isForeground,
          fromTerminated: fromTerminated);
    } else if (type == 'sos_alert') {
      if (isForeground) startVibrationAndRingtone(); // 🔊 foreground ringtone
      _navigateToSosPage(message, isForeground);
    }

    // Show system notification (only in foreground, background handled separately)
    if (isForeground) {
      _showLocalNotification(message);
    }
  }

  /// Vibrate & ringtone (for foreground only)
  static Future<void> startVibrationAndRingtone() async {
    if (_isRingtonePlaying) return;
    _isRingtonePlaying = true;

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
    }

    FlutterRingtonePlayer().play(
      looping: true,
      asAlarm: false,
      fromAsset: "assets/sounds/ringtone.mp3",
    );

    Timer(const Duration(seconds: 10), _stopVibrationAndRingtone);
  }

  static void _stopVibrationAndRingtone() {
    if (!_isOnIncomingPage) {
      Vibration.cancel();
      FlutterRingtonePlayer().stop();
      _isRingtonePlaying = false;
    }
  }

  /// Navigate to Visitor Page
  static void _navigateToVisitorsPage(
      RemoteMessage? message, bool fromForeground,
      {bool fromTerminated = false}) {
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => VisitorsIncomingRequestPage(
        message: message,
        fromForegroundMsg: fromForeground,
        from: fromTerminated ? "Terminated State" : "Notification",
        setPageValue: (val) => _isOnIncomingPage = val,
      ),
    ));
  }

  /// Navigate to SOS Alert Page
  static void _navigateToSosPage(RemoteMessage? message, bool fromForeground) {
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => SosIncomingAlert(
        message: message,
        fromForegroundMsg: fromForeground,
        setPageValue: (val) => _isOnIncomingPage = val,
      ),
    ));
  }

  /// Show local notification (works for foreground + background + terminated)
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'visitor_channel_id',
      'Visitor Notifications',
      channelDescription: 'For incoming visitor requests',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('ringtone'),
      // 🔔 custom ringtone
      enableVibration: true,
      fullScreenIntent: true,
      // like call screen
      styleInformation: BigTextStyleInformation(''),
      actions: [
        AndroidNotificationAction('ALLOW_ACTION', 'Allow',
            showsUserInterface: true),
        AndroidNotificationAction('DECLINE_ACTION', 'Decline',
            showsUserInterface: true),
      ],
    );

    const details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'Incoming Request',
      message.notification?.body ?? 'You have a new request.',
      details,
      payload: 'VisitorsIncomingRequestPage',
    );
  }

  /// Handle API call on notification action
  static void _handleApiCall(String status) async {
    try {
      final visitorId =
          LocalStorage.localStorage.getString("visitor_id").toString();
      final data = {"visitor_id": visitorId, "status": status};

      navigatorKey.currentState?.context
          .read<AcceptRequestCubit>()
          .acceptRequestAPI(statusBody: data);
    } catch (e) {
      print("API Error: $e");
    }
  }
}
