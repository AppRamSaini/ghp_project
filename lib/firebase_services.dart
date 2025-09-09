import 'dart:async';
import 'dart:io';

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

    const iosSettings = DarwinInitializationSettings(requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,);
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (response) {
      print("🔔 Notification tapped: ${response.payload}");
    });
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      // do not display default fcm notification
      alert: true,
      badge: true,
      sound: true,
    );
    _createNotificationChannels();
    // Check if app was launched by tapping a notification
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      // Handle the notification that launched the app
      final response = notificationAppLaunchDetails!.notificationResponse;
      flutterLocalNotificationsPlugin.cancelAll();
      flutterLocalNotificationsPlugin.cancelAllPendingNotifications();
    }
    final token = Platform.isIOS ?  await FirebaseMessaging.instance.getAPNSToken() : await FirebaseMessaging.instance.getToken();
    print("FCM + $token");
  }

  static Future<void> _createNotificationChannels() async {
    // Custom channel for intercepted Firebase messages
    const AndroidNotificationChannel customChannel =
    AndroidNotificationChannel(
      'custom_firebase_channel',
      'Custom Firebase Notifications',
      description: 'Custom handled Firebase notifications',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('custom_notification'),
    );

    // High priority channel
    const AndroidNotificationChannel priorityChannel =
    AndroidNotificationChannel(
      'priority_channel',
      'Priority Notifications',
      description: 'High priority custom notifications',
      importance: Importance.max,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('ringtone'),
      //vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
    );

    final plugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await plugin?.createNotificationChannel(customChannel);
    await plugin?.createNotificationChannel(priorityChannel);
  }

  // static String _getChannelId(String soundName) {
  //   if (soundName.contains('custom_sound_1')) return 'custom_sound_1';
  //   if (soundName.contains('custom_sound_2')) return 'custom_sound_2';
  //   return 'priority_channel';
  // }
  //
  // static String _getSoundResource(String soundName) {
  //   // Remove file extension for Android raw resource
  //   return soundName.replaceAll('.wav', '').replaceAll('.mp3', '');
  // }

  static String _getChannelName(String channelId) {
    switch (channelId) {
      case 'custom_sound_1': return 'Custom Sound 1';
      case 'custom_sound_2': return 'Custom Sound 2';
      default: return 'priority_channel';
    }
  }

  static String _getChannelDescription(String channelId) {
    switch (channelId) {
      case 'custom_sound_1': return 'Notifications with custom sound 1';
      case 'custom_sound_2': return 'Notifications with custom sound 2';
      default: return 'Default notification channel';
    }
  }
  static Future<void> showCustomNotification({
    required RemoteMessage message,
    String? customTitle,
    String? customBody,
    String? customSound,
    Map<String, dynamic>? customData,
  }) async {

    // Extract data from Firebase message or use custom data
    final title = customTitle ??
        message.notification?.title ??
        message.data['title'] ??
        'New Message';

    final body = customBody ??
        message.notification?.body ??
        message.data['body'] ??
        'You have a new message';

    final sound = customSound ?? message.data['sound'] ?? 'default';
    final priority = message.data['priority'] ?? 'high';
    final category = message.data['category'] ?? 'message';

    // Create custom notification based on message data
    String channelId = _getChannelForMessage(priority, category);

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: priority == 'high' ? Importance.max : Importance.high,
      priority: priority == 'high' ? Priority.max : Priority.high,
      ticker: title,
      sound: sound != 'default' ? RawResourceAndroidNotificationSound(sound) : null,
      enableVibration: true,
      // vibrationPattern: priority == 'high'
      //     ? Int64List.fromList([0, 500, 200, 500])
      //     : Int64List.fromList([0, 300]),
      // Custom notification style
      styleInformation: BigTextStyleInformation(
        body,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
      ),
      // Add custom actions if needed
      actions: _getNotificationActions(category),
      // Custom notification appearance
      color: _getNotificationColor(category),
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      sound: "ringtone.caf",
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      subtitle: category,
      threadIdentifier: category, // Group similar notifications
      // Custom iOS actions
      categoryIdentifier: 'custom_category',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Create unique notification ID
    int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    // Store message data for handling taps
    String payload = _createPayload(message, customData);

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    print('Custom notification shown: $title');
  }

  static String _createPayload(RemoteMessage message, Map<String, dynamic>? customData) {
    Map<String, dynamic> payloadData = {
      'messageId': message.messageId,
      'data': message.data,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (customData != null) {
      payloadData['customData'] = customData;
    }

    return payloadData.toString();
  }

  static String _getChannelForMessage(String priority, String category) {
    if (priority == 'high') return 'priority_channel';
    return 'custom_firebase_channel';
  }

  static List<AndroidNotificationAction>? _getNotificationActions(String category) {
    switch (category) {
      case 'message':
        return [
          const AndroidNotificationAction('reply', 'Reply'),
          const AndroidNotificationAction('mark_read', 'Mark as Read'),
        ];
      case 'reminder':
        return [
          const AndroidNotificationAction('done', 'Done'),
          const AndroidNotificationAction('snooze', 'Snooze'),
        ];
      default:
        return null;
    }
  }

  static Color? _getNotificationColor(String category) {
    switch (category) {
      case 'urgent': return Colors.red;
      case 'message': return Colors.blue;
      case 'reminder': return Colors.orange;
      default: return null;
    }
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
