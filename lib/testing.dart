// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:ghp_society_management/constants/export.dart';
// import 'package:ghp_society_management/view/resident/sos/sos_incoming_alert.dart';
// import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';
// import 'package:vibration/vibration.dart';
//
// // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// class FirebaseNotificationService {
//   static Timer? _ringtoneTimer;
//
//   /// 🔹 Initialize Notification Handling
//   static Future<void> initialize() async {
//     const androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const iosSettings = DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );
//
//     const initSettings =
//     InitializationSettings(android: androidSettings, iOS: iosSettings);
//
//     await flutterLocalNotificationsPlugin.initialize(initSettings,
//         onDidReceiveNotificationResponse: (response) {
//           print("🔔 Notification tapped: ${response.payload}");
//         });
//
//     FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     await _createNotificationChannels();
//
//     // Check if app launched by tapping a notification
//     final NotificationAppLaunchDetails? details =
//     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//
//     if (details?.didNotificationLaunchApp ?? false) {
//       print("📲 App launched from terminated state via notification");
//     }
//   }
//
//   /// 🔹 Create Notification Channels
//   static Future<void> _createNotificationChannels() async {
//     const AndroidNotificationChannel customChannel = AndroidNotificationChannel(
//       'custom_firebase_channel',
//       'Custom Firebase Notifications',
//       description: 'General notifications from Firebase',
//       importance: Importance.high,
//       playSound: true,
//     );
//
//     const AndroidNotificationChannel priorityChannel =
//     AndroidNotificationChannel(
//       'priority_channel',
//       'Priority Notifications',
//       description: 'Alerts for visitor requests and SOS',
//       importance: Importance.max,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound('ringtone'),
//       enableVibration: true,
//     );
//
//     final plugin =
//     flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//
//     await plugin?.createNotificationChannel(customChannel);
//     await plugin?.createNotificationChannel(priorityChannel);
//   }
//
//   /// 🔹 Show Custom Notification
//   static Future<void> showCustomNotification(
//       {required RemoteMessage message}) async {
//     final data = message.data;
//
//     final title = message.data['title'] ?? data['title'] ?? 'New Message';
//     final body =
//         message.data['body'] ?? data['body'] ?? 'You have a new message';
//     final type = data['type'] ?? '';
//     final category = data['category'] ?? 'message';
//
//     final bool isAlert = (type == 'incoming_request' || type == 'sos_alert');
//     final String channelId =
//     isAlert ? 'priority_channel' : 'custom_firebase_channel';
//
//     final androidDetails = AndroidNotificationDetails(
//       channelId,
//       isAlert ? 'Priority Notifications' : 'General Notifications',
//       channelDescription: isAlert
//           ? 'Notifications with ringtone (Visitor/SOS)'
//           : 'Regular app notifications',
//       importance: isAlert ? Importance.max : Importance.high,
//       priority: isAlert ? Priority.max : Priority.high,
//       sound: isAlert
//           ? const RawResourceAndroidNotificationSound('ringtone')
//           : null,
//       enableVibration: true,
//       styleInformation: BigTextStyleInformation(body),
//       actions: _getNotificationActions(category),
//       color: _getNotificationColor(category),
//       largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
//     );
//
//     final iosDetails = DarwinNotificationDetails(
//         sound: isAlert ? "ringtone.caf" : null, // iOS handles sound
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true);
//
//     final notificationDetails =
//     NotificationDetails(android: androidDetails, iOS: iosDetails);
//
//     await flutterLocalNotificationsPlugin.show(
//         DateTime.now().millisecondsSinceEpoch.remainder(100000),
//         title,
//         body,
//         notificationDetails,
//         payload: data.toString());
//
//     print("📩 Notification shown: $title");
//   }
//
//   /// 🔹 Handle message (navigate)
//   static void handleMessage(RemoteMessage? message,
//       {bool fromTerminated = false}) async {
//     if (message == null || message.data.isEmpty) return;
//
//     final data = message.data;
//     final type = data['type']?.toString() ?? '';
//     final visitorId = data['visitor_id']?.toString() ?? '';
//
//     if (type == 'incoming_request' && visitorId.isNotEmpty) {
//       LocalStorage.localStorage.setString("visitor_id", visitorId);
//     }
//
//     if (type == 'incoming_request') {
//       navigateToVisitorsPage(message, isFromTerminated: fromTerminated);
//     } else if (type == 'sos_alert') {
//       _navigateToSosPage(message);
//     }
//   }
//
//   /// 🔹 Vibrate & Ringtone
//   /// 🔹 Vibrate & Ringtone (Singleton)
//   static Future<void> startVibrationAndRingtone() async {
//     // Start vibration
//     if (await Vibration.hasVibrator() ?? false) {
//       Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: -1);
//     }
//     // Start ringtone
//     FlutterRingtonePlayer().play(
//         android: AndroidSounds.ringtone,
//         ios: IosSounds.alarm,
//         looping: true,
//         volume: 1.0,
//         fromAsset: "assets/sounds/ringtone.mp3");
//     _ringtoneTimer = Timer(const Duration(seconds: 50), () {
//       stopVibrationAndRingtone();
//     });
//
//     print("▶️ Ringtone & vibration started");
//   }
//
//   /// 🔹 Stop Alerts
//   static void stopVibrationAndRingtone() {
//     if (_ringtoneTimer != null) {
//       FlutterRingtonePlayer().stop();
//       Vibration.cancel();
//       _ringtoneTimer?.cancel();
//       _ringtoneTimer = null;
//       print("⏹️ Alerts stopped");
//     }
//   }
//
//   /// 🔹 Visitors Page
//   static void navigateToVisitorsPage(RemoteMessage message,
//       {bool isFromTerminated = false}) {
//     navigatorKey.currentState?.push(MaterialPageRoute(
//       builder: (_) => VisitorsIncomingRequestPage(
//         message: message,
//         fromPage: isFromTerminated ? "terminate" : null,
//         setPageValue: (val) {
//           if (val) stopVibrationAndRingtone();
//         },
//       ),
//     ));
//   }
//
//   /// 🔹 SOS Page
//   static void _navigateToSosPage(RemoteMessage message) {
//     navigatorKey.currentState?.push(MaterialPageRoute(
//       builder: (_) => SosIncomingAlert(
//         message: message,
//         setPageValue: (val) {
//           if (val) stopVibrationAndRingtone();
//         },
//       ),
//     ));
//   }
//
//   /// Helpers
//   static List<AndroidNotificationAction>? _getNotificationActions(
//       String category) {
//     switch (category) {
//       case 'message':
//         return [
//           const AndroidNotificationAction('reply', 'Reply'),
//           const AndroidNotificationAction('mark_read', 'Mark as Read'),
//         ];
//       default:
//         return null;
//     }
//   }
//
//   static Color? _getNotificationColor(String category) {
//     switch (category) {
//       case 'urgent':
//         return Colors.red;
//       case 'message':
//         return Colors.blue;
//       case 'reminder':
//         return Colors.orange;
//       default:
//         return null;
//     }
//   }
// }
//
// // /// Handle message safely
// //  /* static void handleMessage(RemoteMessage? message,
// //       {bool fromTerminated = false}) async {
// //     if (message == null || message.data.isEmpty) return;
// //
// //     // final data = message.data;
// //     // final type = data['type']?.toString() ?? '';
// //     // final visitorId = data['visitor_id']?.toString() ?? '';
// //
// //     // final data = message.data;
// //     // final rawMessage = message.data['message'];
// //     // final Map<String, dynamic> data = jsonDecode(rawMessage);
// //     // final type = data['data']?['type'].toString() ?? '';
// //     // final visitorId = data['data']['visitor_id']?.toString() ?? '';
// //     // // 🔔 Play alerts
// //     // if (type == 'incoming_request' || type == 'sos_alert') {
// //     //   startVibrationAndRingtone();
// //     // }
// //
// //     final Map<String, dynamic> payload = message.toMap();
// //     final data = deepDecode(payload);
// //     String? type;
// //     if (data['data'] is Map) {
// //       type = data['data']?['type']?.toString();
// //       if (type == null && data['data']?['data'] is Map) {
// //         type = data['data']?['data']?['type']?.toString();
// //       }
// //     }
// //     type = type ?? '';
// //     print("📌 Extracted type: $type");
// //
// //     // Page navigation
// //     if (type == 'incoming_request') {
// //       navigateToVisitorsPage(message, isFromTerminated: true);
// //     } else if (type == 'sos_alert') {
// //       _navigateToSosPage(message);
// //     }
// //   }*/
// //
// //   static void handleMessage(RemoteMessage? message,
// //       {bool fromTerminated = false}) async {
// //     if (message == null || message.data.isEmpty) return;
// //
// //     final data = message.data;
// //     final type = data['type']?.toString() ?? '';
// //     final visitorId = data['visitor_id']?.toString() ?? '';
// //
// //     // Save visitorId
// //     if (type == 'incoming_request' && visitorId.isNotEmpty) {
// //       LocalStorage.localStorage.setString("visitor_id", visitorId);
// //     }
// //
// //     // // 🔔 Play alerts
// //     // if (type == 'incoming_request' || type == 'sos_alert') {
// //     //   startVibrationAndRingtone();
// //     // }
// //
// //     // Page navigation
// //     if (type == 'incoming_request') {
// //       navigateToVisitorsPage(message);
// //     } else if (type == 'sos_alert') {
// //       _navigateToSosPage(message);
// //     }
// //   }
// //   /// Vibrate & ringtone
// //   static Future<void> startVibrationAndRingtone() async {
// //     if (await Vibration.hasVibrator() ?? false) {
// //       Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: -1);
// //     }
// //     FlutterRingtonePlayer().play(
// //       android: AndroidSounds.ringtone,
// //       ios: IosSounds.alarm,
// //       looping: true,
// //       volume: 1.0,
// //       asAlarm: true, // required for iOS
// //     );
// //     print("▶️ Ringtone & vibration started");
// //     _ringtoneTimer = Timer(const Duration(seconds: 15), () {
// //       stopVibrationAndRingtone();
// //     });
// //   }
// //
// //   /// 🔴 Global Stop Function
// //   static void stopVibrationAndRingtone() {
// //     FlutterRingtonePlayer().stop();
// //     Vibration.cancel();
// //     _ringtoneTimer?.cancel();
// //     _ringtoneTimer = null;
// //     print("⏹️ Global ringtone & vibration stopped!");
// //   }
// //
// //   /// Visitors Page
// //   static void navigateToVisitorsPage(RemoteMessage message, {bool isFromTerminated = false}) {
// //     navigatorKey.currentState?.push(MaterialPageRoute(
// //       builder: (_) => VisitorsIncomingRequestPage(
// //         message: message,
// //         fromPage: isFromTerminated ? "terminated" : null,
// //         setPageValue: (val) {
// //           if (val) stopVibrationAndRingtone();
// //         },
// //       ),
// //     ));
// //     // _ringtoneTimer = Timer(const Duration(seconds: 10), () {
// //     //   stopVibrationAndRingtone();
// //     // });
// //   }
// //
// //   /// SOS Page
// //   static void _navigateToSosPage(RemoteMessage message) {
// //     navigatorKey.currentState?.push(MaterialPageRoute(
// //         builder: (_) => SosIncomingAlert(
// //             message: message,
// //             setPageValue: (val) {
// //               if (val) stopVibrationAndRingtone();
// //             })));
// //     _ringtoneTimer = Timer(const Duration(seconds: 15), () {
// //       stopVibrationAndRingtone();
// //     });
// //   }
// // }
