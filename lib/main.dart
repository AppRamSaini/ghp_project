// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:ghp_society_management/constants/export.dart';
// import 'package:ghp_society_management/firebase_services.dart';
// import 'dart:async';
//
// late Size size;
// // Firebase background message handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   FirebaseNotificationService.initialize(); // Handle notification in background
// }
//
// // Request notification permission
// Future<void> requestNotificationPermission() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//
//   if (settings.authorizationStatus == AuthorizationStatus.denied) {
//     print("User Denied Notification Permission");
//   } else {
//     print("Notification Permission Granted");
//   }
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize local storage and Firebase
//   await LocalStorage.init();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   // Request permission for notifications
//   await requestNotificationPermission();
//
//   // Set up background message handler
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   // Initialize Firebase Notification Service
//   FirebaseNotificationService.initialize();
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize Firebase Notification Service
//     FirebaseNotificationService.initialize();
//     FirebaseNotificationService.initializeNotificationHandler();
//
//     // Handling foreground notifications
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print(
//           'Received a message while in foreground: ${message.notification?.title}');
//       // You can show a local notification or perform other actions here
//     });
//
//     // Handle notification when app is opened from background
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print(
//           'App opened from background by message: ${message.notification?.title}');
//       // You can navigate to a specific screen here
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: BlocProviders.providers,
//       child: ScreenUtilInit(
//         designSize: Size(MediaQuery.of(context).size.width,
//             MediaQuery.of(context).size.height),
//         builder: (context, child) {
//           size = MediaQuery.sizeOf(context);
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(
//                 useMaterial3: true,
//                 scaffoldBackgroundColor: AppTheme.white,
//                 appBarTheme: AppBarTheme(
//                     centerTitle: false,
//                     iconTheme: IconThemeData(color: Colors.black),
//                     backgroundColor: AppTheme.white)),
//             home: SplashScreen(),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/vibration.dart';

import 'constants/export.dart';
import 'firebase_services.dart';

late Size size;

/// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Vibrate and Play Ringtone

  await Firebase.initializeApp();
  await LocalStorage.init();
  FirebaseNotificationService.showNotification(message);
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

/// Ask user for notification permission
Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    debugPrint("🚨 User Denied Notification Permission");
  } else {
    debugPrint("✅ Notification Permission Granted");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // सबसे पहले यह जरूरी है
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ); // Firebase को initialize करें
  await LocalStorage.init(); // फिर अपनी custom storage init करें

  await requestNotificationPermission(); // Notification permission मांगें

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); // Background handler सेट करें
  FirebaseNotificationService.initialize2(); // Custom Firebase Notification Init

  runApp(const MyApp()); // App शुरू करें
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseNotificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProviders.providers,
      child: Builder(builder: (context) {
        final mediaSize = MediaQuery.of(context).size;
        size = mediaSize;
        return ScreenUtilInit(
          designSize: Size(mediaSize.width, mediaSize.height),
          builder: (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: AppTheme.white,
              appBarTheme:  AppBarTheme(
                centerTitle: false,
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: AppTheme.white,
              ),
            ),
            navigatorKey: navigatorKey,
            home: SplashScreen(),
          ),
        );
      }),
    );
  }
}
