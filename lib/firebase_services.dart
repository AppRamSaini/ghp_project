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

    print("Notification permission: ${settings.authorizationStatus}");
    // Initialize local notification
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (response) {
      // Notification tapped
      print("Notification tapped payload: ${response.payload}");
      // Here you can navigate if needed
    });

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
        handleMessage(message, isForeground: false, fromTerminated: true);
      }
    });

    // Background handler registration (Android)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Background handler (runs in separate isolate)
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await LocalStorage.init();
    print("BG message received: ${message.data}");

    // Only local notification in background
    await _showLocalNotification(message);
  }

  /// Handle message safely
  static void handleMessage(RemoteMessage? message,
      {bool isForeground = false, bool fromTerminated = false}) {
    if (message == null || message.data.isEmpty) {
      print("Null or empty message, skipping handleMessage.");
      return;
    }

    final data = message.data;
    final type = data['type']?.toString() ?? '';
    final visitorId = data['visitor_id']?.toString() ?? '';

    // Save visitor ID if exists
    if (type == 'incoming_request' && visitorId.isNotEmpty) {
      LocalStorage.localStorage.setString("visitor_id", visitorId);
    }

    // Foreground ringtone & vibration
    if (isForeground) startVibrationAndRingtone();

    // Show local notification
    _showLocalNotification(message);

    // Navigate only in foreground or terminated tapped
    if (isForeground || fromTerminated) {
      if (type == 'incoming_request') {
        navigateToVisitorsPage(message, isForeground,
            fromTerminated: fromTerminated);
      } else if (type == 'sos_alert') {
        _navigateToSosPage(message, isForeground);
      }
    }
  }

  /// Vibrate & ringtone
  static Future<void> startVibrationAndRingtone() async {
    if (_isRingtonePlaying) return;
    _isRingtonePlaying = true;

    if (await Vibration.hasVibrator() ?? false) {
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
  static void navigateToVisitorsPage(RemoteMessage message, bool fromForeground,
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

  /// Navigate to SOS Page
  static void _navigateToSosPage(RemoteMessage message, bool fromForeground) {
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => SosIncomingAlert(
        message: message,
        fromForegroundMsg: fromForeground,
        setPageValue: (val) => _isOnIncomingPage = val,
      ),
    ));
  }

  /// Show local notification
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'visitor_channel_id',
      'Visitor Notifications',
      channelDescription: 'For incoming visitor requests',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const platformDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'Incoming Request',
      message.notification?.body ?? 'You have a new request.',
      platformDetails,
      payload: 'VisitorsIncomingRequestPage',
    );
  }
}
