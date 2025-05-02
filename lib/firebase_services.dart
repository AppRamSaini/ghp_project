import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/accept_request/accept_request_cubit.dart';
import 'package:ghp_society_management/view/resident/sos/sos_incoming_alert.dart';
import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';
import 'package:vibration/vibration.dart';

// Initialize global variables
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// // Initialize Firebase Analytics
// FirebaseAnalytics analytics = FirebaseAnalytics.instance;
// FirebaseAnalyticsObserver analyticsObserver =
// FirebaseAnalyticsObserver(analytics: analytics);

class FirebaseNotificationService {
  static bool _isRingtonePlaying = false;
  static bool _isOnIncomingPage = false;

  /// Initialize Firebase Messaging and Notification Settings
  static Future<void> initialize() async {
    final messaging = FirebaseMessaging.instance;

    // Request notification permissions
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Foreground message received: ${message.data}');
        handleForegroundMessage(message);
      });

      // Handle background messages (when the app is not terminated)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Clicked notification: ${message.data}');

        String type = message.data['type'] ?? '';
        if (type == 'incoming_request') {
          LocalStorage.localStorage
              .setString("visitor_id", message.data['visitor_id']);
          _navigateToVisitorsPage(message, false);
        } else if (type == 'sos_alert') {
          _navigateToSosPage(message, false);
        }
      });

      // Handle terminated state notifications
      messaging.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          print('Terminated state notification received: ${message.data}');
          String type = message.data['type'] ?? '';
          if (type == 'incoming_request') {
            LocalStorage.localStorage
                .setString("visitor_id", message.data['visitor_id']);
            _navigateToVisitorsPage(message, false, data: 'Terminated State');
          } else if (type == 'sos_alert') {
            _navigateToSosPage(message, true);
          }
        }
      });
    } else {
      print('User denied or has not granted permissions');
    }
  }

  /// Show local notification with vibration and ringtone
  static void handleForegroundMessage(RemoteMessage message) {
    String type = message.data['type'] ?? '';
    if (type == 'incoming_request') {
      LocalStorage.localStorage
          .setString("visitor_id", message.data['visitor_id']);
      _startVibrationAndRingtone();
      // showLocalNotification(message);
      _navigateToVisitorsPage(message, true);
    } else if (type == 'sos_alert') {
      _navigateToSosPage(message, true);
    }
  }

  /// Show local notification with vibration and ringtone
  static void handleBackgroundMessage(RemoteMessage message) {
    String type = message.data['type'] ?? '';
    if (type == 'incoming_request') {
      LocalStorage.localStorage
          .setString("visitor_id", message.data['visitor_id']);
      _startVibrationAndRingtone();
      // showLocalNotification(message);
      _navigateToVisitorsPage(message, false);
    } else if (type == 'sos_alert') {
      _navigateToSosPage(message, false);
    }
  }

  /// Start vibration and ringtone
  static Future<void> _startVibrationAndRingtone() async {
    if (_isRingtonePlaying) return;

    _isRingtonePlaying = true;
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
    }
    FlutterRingtonePlayer().play(
        looping: true, asAlarm: true, fromAsset: "assets/sounds/ringtone.mp3");
    Timer(const Duration(seconds: 10), _stopVibrationAndRingtone);
  }

  /// Stop vibration and ringtone
  static void _stopVibrationAndRingtone() {
    if (!_isOnIncomingPage) {
      print('----->>>called stop vibration');
      Vibration.cancel();
      FlutterRingtonePlayer().stop();
      _isRingtonePlaying = false;
    } else {
      print('----->>> Not called stop vibration');
    }
  }

  static void checkInitialMessage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("🚀 App Opened from Terminated State: ${initialMessage.data}");
      _navigateToVisitorsPage(initialMessage, false);
    }
  }

  /// Show local notification with action buttons (Allow and Decline)
  static void showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'visitor_channel_id',
      'Visitor Notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: "@mipmap/ic_launcher",
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('ALLOW_ACTION', 'Allow',
            showsUserInterface: true),
        AndroidNotificationAction('DECLINE_ACTION', 'Decline',
            showsUserInterface: true)
      ],
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'Incoming Request',
      message.notification?.body ?? 'You have a new request.',
      notificationDetails,
      payload: 'VisitorsIncomingRequestPage',
    );
  }

  /// Navigate to visitors page
  static void _navigateToVisitorsPage(RemoteMessage message, bool value,
      {String? data}) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => VisitorsIncomingRequestPage(
          from: data.toString(),
          message: message,
          fromForegroundMsg: value,
          setPageValue: (value) {
            _isOnIncomingPage = value;
          },
        ),
      ),
    );
  }

  /// Navigate to sos page
  static void _navigateToSosPage(RemoteMessage message, bool value) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => SosIncomingAlert(
          message: message,
          fromForegroundMsg: value,
          setPageValue: (value) {
            _isOnIncomingPage = value;
          },
        ),
      ),
    );
  }

  /// Initialize the notification handler
  static void initializeNotificationHandler() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
          print('Notification action clicked: ${response.payload}');

          // Handle actions based on the actionId
          if (response.actionId == 'ALLOW_ACTION') {
            print('Allow button clicked');
            _handleApiCall('allowed'); // Call API or perform action
          } else if (response.actionId == 'DECLINE_ACTION') {
            print('Decline button clicked');
            _handleApiCall('not_allowed'); // Call API or perform action
          }
          _stopVibrationAndRingtone();
        });
  }

  /// Handle API calls for Allow/Decline actions
  static void _handleApiCall(String action) async {
    print('Calling API with action: $action');
    try {
      final String visitorsID =
      LocalStorage.localStorage.getString("visitor_id").toString();
      var data = {
        "visitor_id": visitorsID.toString(),
        "status": action
      }; // Update as needed
      navigatorKey.currentState?.context
          .read<AcceptRequestCubit>()
          .acceptRequestAPI(statusBody: data);
    } catch (e) {
      print('Error calling API: $e');
    }
  }

  /// for background notifications
  static Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? 'You have a new message.',
      notificationDetails,
    );

    // Vibrate and Play Ringtone
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
    }
    FlutterRingtonePlayer().play(
        looping: true, asAlarm: true, fromAsset: "assets/sounds/ringtone.mp3");
    Timer(const Duration(seconds: 10), () {
      Vibration.cancel();
      FlutterRingtonePlayer().stop();
    });
  }

  static void initialize2() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}