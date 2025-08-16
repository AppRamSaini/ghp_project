import 'dart:async';

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

Future<void> setupLocalNotifications() async {
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// FirebaseAnalytics analytics = FirebaseAnalytics.instance;
// FirebaseAnalyticsObserver analyticsObserver =
// FirebaseAnalyticsObserver(analytics: analytics);

class FirebaseNotificationService {
  static bool _isRingtonePlaying = false;
  static bool _isOnIncomingPage = false;

  /// Initialize Firebase Notification Handling
  static Future<void> initialize() async {
    final messaging = FirebaseMessaging.instance;

    // Request notification permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Foreground
      FirebaseMessaging.onMessage.listen((message) {
        print('------->>>>>Foreground message');

        _handleMessage(message, isForeground: true);
      });

      // Background - tapped from system tray
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('------->>>>> Background - tapped from system tray');

        _handleMessage(message, isForeground: false);
      });

      // Terminated - first time app opened via notification
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        print(
            '------->>>>>Terminated - first time app opened via notification');

        if (message != null) {
          _handleMessage(message, isForeground: false, fromTerminated: true);
        }
      });
    }
  }

  static void _handleMessage(RemoteMessage message,
      {bool isForeground = false, bool fromTerminated = false}) {
    final data = message.data;
    final type = data['type'] ?? '';

    print('------------------------------>>>>>>>$data');

    if (type == 'incoming_request') {
      LocalStorage.localStorage.setString("visitor_id", data['visitor_id']);
      if (isForeground) startVibrationAndRingtone();
      _navigateToVisitorsPage(message, isForeground,
          fromTerminated: fromTerminated);
    } else if (type == 'sos_alert') {
      if (isForeground) startVibrationAndRingtone();
      _navigateToSosPage(message, isForeground);
    }
    // Optional: Show system tray notification
    if (isForeground) {
      _showLocalNotification(message);
    }
  }

  /// Vibrate and Ring
  static Future<void> startVibrationAndRingtone() async {
    if (_isRingtonePlaying) return;
    _isRingtonePlaying = true;

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
    }

    FlutterRingtonePlayer().play(
      looping: true,
      asAlarm: true,
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
      RemoteMessage message, bool fromForeground,
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
  static void _navigateToSosPage(RemoteMessage message, bool fromForeground) {
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => SosIncomingAlert(
        message: message,
        fromForegroundMsg: fromForeground,
        setPageValue: (val) => _isOnIncomingPage = val,
      ),
    ));
  }

  /// Local Notification for Action Buttons
  static void _showLocalNotification(RemoteMessage message) {
    const androidDetails = AndroidNotificationDetails(
      'visitor_channel_id',
      'Visitor Notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: "@mipmap/ic_launcher",
      actions: [
        AndroidNotificationAction('ALLOW_ACTION', 'Allow',
            showsUserInterface: true),
        AndroidNotificationAction('DECLINE_ACTION', 'Decline',
            showsUserInterface: true),
      ],
    );

    const details = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'Incoming Request',
      message.notification?.body ?? 'You have a new request.',
      details,
      payload: 'VisitorsIncomingRequestPage',
    );
  }

  /// Initialize Local Notification Handler
  static void initializeNotificationHandler() {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      if (response.actionId == 'ALLOW_ACTION') {
        _handleApiCall('allowed');
      } else if (response.actionId == 'DECLINE_ACTION') {
        _handleApiCall('not_allowed');
      }
      _stopVibrationAndRingtone();
    });
  }

  /// API Call for Visitor Approval
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
