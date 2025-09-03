// import 'dart:async';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:ghp_society_management/constants/export.dart';
// import 'package:ghp_society_management/view/resident/sos/sos_incoming_alert.dart';
// import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';
// import 'package:vibration/vibration.dart';
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// class FirebaseNotificationService {
//   static bool _isRingtonePlaying = false;
//   static bool _isOnIncomingPage = false;
//
//   /// Initialize Notification Handling
//   static Future<void> initialize() async {
//     const androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = DarwinInitializationSettings();
//     const initSettings =
//         InitializationSettings(android: androidSettings, iOS: iosSettings);
//     await flutterLocalNotificationsPlugin.initialize(initSettings,
//         onDidReceiveNotificationResponse: (response) {
//       print("🔔 Notification tapped: ${response.payload}");
//     });
//   }
//
//   /// Handle message
//   static void handleMessage(RemoteMessage? message) {
//     if (message == null || message.data.isEmpty) return;
//     final data = message.data;
//     final type = data['type']?.toString() ?? '';
//     final visitorId = data['visitor_id']?.toString() ?? '';
//     if (type == 'incoming_request' && visitorId.isNotEmpty) {
//       LocalStorage.localStorage.setString("visitor_id", visitorId);
//     }
//     startVibrationAndRingtone();
//     if (type == 'incoming_request') {
//       navigateToVisitorsPage(message);
//     } else if (type == 'sos_alert') {
//       _navigateToSosPage(message);
//     }
//   }
//
//   /// Vibrate & ringtone
//   /// Vibrate & ringtone
//   static Future<void> startVibrationAndRingtone() async {
//     if (_isRingtonePlaying) return;
//     _isRingtonePlaying = true;
//
//     if (await Vibration.hasVibrator() ?? false) {
//       Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
//     }
//
//     FlutterRingtonePlayer().play(
//       fromAsset: "assets/sounds/ringtone.mp3",
//       looping: true,
//       asAlarm: true,
//     );
//
//     // ⏱ 55 sec बाद सिर्फ ringtone/vibration बंद करो
//     Timer(const Duration(seconds: 55), () {
//       Vibration.cancel();
//       FlutterRingtonePlayer().stop();
//       _isRingtonePlaying = false;
//     });
//   }
//
//   static void _stopVibrationAndRingtone() {
//     if (!_isOnIncomingPage) {
//       Vibration.cancel();
//       FlutterRingtonePlayer().stop();
//       _isRingtonePlaying = false;
//     }
//   }
//
//   /// Reset flags when page closed
//   static void resetFlags() {
//     _isRingtonePlaying = false;
//   }
//
//   /// Visitors Page
//   static void navigateToVisitorsPage(RemoteMessage message) {
//     navigatorKey.currentState?.push(MaterialPageRoute(
//       builder: (_) => VisitorsIncomingRequestPage(
//         message: message,
//         setPageValue: (val) {
//           // _isOnIncomingPage = val;
//           // if (!val) resetFlags();
//         },
//       ),
//     ));
//   }
//
//   /// SOS Page
//   static void _navigateToSosPage(RemoteMessage message) {
//     navigatorKey.currentState?.push(MaterialPageRoute(
//       builder: (_) => SosIncomingAlert(
//         message: message,
//         setPageValue: (val) {
//           _isOnIncomingPage = val;
//           if (!val) resetFlags();
//         },
//       ),
//     ));
//   }
//
//   /// Local Notification
//   static Future<void> _showLocalNotification(RemoteMessage message) async {
//     const androidDetails = AndroidNotificationDetails(
//       'visitor_channel_id',
//       'Visitor Notifications',
//       channelDescription: 'Incoming visitor requests',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//       fullScreenIntent: true,
//       styleInformation: BigTextStyleInformation(''),
//     );
//
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     const details =
//         NotificationDetails(android: androidDetails, iOS: iosDetails);
//
//     await flutterLocalNotificationsPlugin.show(
//       message.hashCode,
//       message.notification?.title ?? 'Incoming Request',
//       message.notification?.body ?? 'You have a new visitor request.',
//       details,
//       payload: 'VisitorsIncomingRequestPage',
//     );
//   }
// }
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
    // // Auto stop after 59s
    // _ringtoneTimer = Timer(const Duration(seconds: 50), () {
    //   stopVibrationAndRingtone();
    // });
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
    if (_isOnIncomingPage) return; // अगर already open है तो दुबारा मत खोलो
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
    Future.delayed(const Duration(seconds: 30), () {
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
