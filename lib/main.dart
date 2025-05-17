import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/firebase_services.dart';

/// Handle Background Notification
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await LocalStorage.init();
  FirebaseNotificationService.startVibrationAndRingtone();
}
/// Request Notification Permission
Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings =
      await messaging.requestPermission(alert: true, badge: true, sound: true);
  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print("🚨 User Denied Notification Permission");
  } else {
    print("✅ Notification Permission Granted");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalStorage.init();

  await requestNotificationPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Local Notification + Foreground Notification Setup
  FirebaseNotificationService.initialize(); // InitializeNotificationHandler

  runApp(MyApp());
}

late Size size;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.sizeOf(context);
    return MultiBlocProvider(
      providers: BlocProviders.providers,
      child: ScreenUtilInit(
        designSize: Size(360, 690), // Set default design size
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                centerTitle: false,
                iconTheme: IconThemeData(color: Colors.black),
              ),
            ),
            navigatorKey: navigatorKey,
            navigatorObservers: [analyticsObserver],
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}

// Future<void> showFullScreenNotification(RemoteMessage message) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'full_screen_channel',
//     'Full Screen Notifications',
//     channelDescription: 'Incoming call or SOS alerts',
//     importance: Importance.max,
//     priority: Priority.high,
//     fullScreenIntent: true,
//     playSound: true,
//     sound:
//         RawResourceAndroidNotificationSound('ringtone'), // Put this in res/raw
//     enableVibration: true,
//     ticker: 'Incoming Alert',
//   );
//
//   const NotificationDetails platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//   );
//
//   await flutterLocalNotificationsPlugin.show(
//     888,
//     message.notification?.title ?? 'Incoming Request',
//     message.notification?.body ?? 'Tap to respond',
//     platformChannelSpecifics,
//     payload: 'VisitorsIncomingRequestPage',
//   );
// }
//
// class ForegroundServiceController {
//   static const platform = MethodChannel("ringtone.service");
//
//   static Future<void> startRingtoneService() async {
//     try {
//       await platform.invokeMethod("startService");
//     } catch (e) {
//       print("Error starting service: $e");
//     }
//   }
//
//   static Future<void> stopRingtoneService() async {
//     try {
//       await platform.invokeMethod("stopService");
//     } catch (e) {
//       print("Error stopping service: $e");
//     }
//   }
// }
