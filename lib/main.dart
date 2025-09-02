// import 'dart:developer';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_callkit_incoming/entities/android_params.dart';
// import 'package:flutter_callkit_incoming/entities/call_event.dart';
// import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:ghp_society_management/bloc_provider/bloc_provider.dart';
// import 'package:ghp_society_management/constants/app_theme.dart';
// import 'package:ghp_society_management/constants/local_storage.dart';
// import 'package:ghp_society_management/firebase_services.dart';
// import 'package:ghp_society_management/view/splash_screen.dart';
//
// import 'firebase_options.dart'; // <- अपनी Firebase config वाली फाइल
//
// late Size size;
//
// /// Background handler → App terminated / background में trigger होगा
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await LocalStorage.init();
//
//   log("🔥 BG Handler message: ${message.data}", name: "FCM_BG");
//
//   if (message.data['type'] == 'incoming_request') {
//     final params = CallKitParams(
//       id: message.data['visitor_id'] ?? '0',
//       nameCaller: message.data['name'] ?? 'Visitor',
//       appName: 'GHP Society',
//       handle: message.data['mob'] ?? '0000000000',
//       type: 0,
//       duration: 30000,
//       textAccept: 'Accept',
//       textDecline: 'Decline',
//       extra: message.data,
//       android: AndroidParams(
//         isCustomNotification: true,
//         isShowLogo: true,
//         isShowFullLockedScreen: true,
//         backgroundColor: '#0955fa',
//         ringtonePath: 'ringtone',
//         logoUrl: message.data['img'],
//       ),
//     );
//     await FlutterCallkitIncoming.showCallkitIncoming(params);
//   }
// }
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await LocalStorage.init();
//   // Background handler register
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
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
//     // Foreground notification
//     FirebaseMessaging.onMessage.listen((message) {
//       log("🔥 Foreground: ${message.data}", name: "FCM_FG");
//       if (message.data['type'] == 'incoming_request') {
//         _showIncomingCall(message.data);
//       }
//     });
//
//     // App background से open
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       log("🔥 onMessageOpenedApp: ${message.data}", name: "FCM_BG_OPEN");
//       if (message.data['type'] == 'incoming_request') {
//         _showIncomingCall(message.data);
//       // }
//     });
//
//     // // 3️⃣ App terminated state
//     // FirebaseMessaging.instance.getInitialMessage().then((message) {
//     //   _showIncomingCall(message!.data);
//     //   Future.delayed(const Duration(milliseconds: 500), () {
//     //     FirebaseNotificationService.navigateToVisitorsPage(message, false);
//     //   });
//     //   // if (message != null && message.data['type'] == 'incoming_request') {
//     //   //   // Show Call UI first
//     //   //   _showIncomingCall(message.data);
//     //   //
//     //   //   // Redirect automatically to visitor page after short delay
//     //   //   Future.delayed(const Duration(milliseconds: 500), () {
//     //   //     FirebaseNotificationService.navigateToVisitorsPage(message, false);
//     //   //   });
//     //   // }
//     // });
//
//     // CallKit Events → Accept/Decline
//     FlutterCallkitIncoming.onEvent.listen((event) {
//       if (event == null) return;
//       log("📞 CallKit Event: ${event.event}", name: "CALLKIT");
//
//       final visitorId = event.body?['extra']?['visitor_id'];
//
//       switch (event.event) {
//         case Event.actionCallAccept:
//           FirebaseNotificationService.handleApiCall("allowed", visitorId);
//           break;
//         case Event.actionCallDecline:
//           FirebaseNotificationService.handleApiCall("not_allowed", visitorId);
//           break;
//         default:
//           log("Unhandled CallKit event: ${event.event}", name: "CALLKIT");
//       }
//     });
//   }
//
//   /// Common function → हर जगह से Call UI दिखाने के लिए
//   void _showIncomingCall(Map<String, dynamic> data) async {
//     final params = CallKitParams(
//       id: data['visitor_id'] ?? '0',
//       nameCaller: data['name'] ?? 'Visitor',
//       appName: 'GHP Society',
//       handle: data['mob'] ?? '0000000000',
//       type: 0,
//       duration: 30000,
//       textAccept: 'Accept',
//       textDecline: 'Decline',
//       extra: data,
//       android: AndroidParams(
//         isCustomNotification: true,
//         isShowLogo: true,
//         isShowFullLockedScreen: true,
//         backgroundColor: '#0955fa',
//         ringtonePath: 'ringtone',
//         logoUrl: data['img'],
//       ),
//     );
//
//     await FlutterCallkitIncoming.showCallkitIncoming(params);
//
//     // CallKit Events → Accept/Decline
//     FlutterCallkitIncoming.onEvent.listen((event) {
//       if (event == null) return;
//       log("---->>>>CallKit Event: ${event.event}", name: "CALLKIT");
//       log("---->>>body: ${event.body}");
//
//       final visitorId = event.body?['extra']?['visitor_id'];
//
//       switch (event.event) {
//         case Event.actionCallAccept:
//           FirebaseNotificationService.handleApiCall("allowed", visitorId);
//           break;
//         case Event.actionCallDecline:
//           FirebaseNotificationService.handleApiCall("not_allowed", visitorId);
//           break;
//         default:
//           log("Unhandled CallKit event: ${event.event}", name: "CALLKIT");
//       }
//     });
//   }
//
//   @override
//   @override
//   Widget build(BuildContext context) {
//     size = MediaQuery.sizeOf(context);
//     return MultiBlocProvider(
//       providers: BlocProviders.providers,
//       child: ScreenUtilInit(
//         designSize: const Size(360, 690),
//         builder: (context, child) {
//           return MaterialApp(
//             title: "Ghp Society",
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(
//               scaffoldBackgroundColor: Colors.white,
//               useMaterial3: true,
//               appBarTheme: AppBarTheme(
//                 titleTextStyle: TextStyle(color: AppTheme.white),
//                 backgroundColor: AppTheme.primaryColor,
//                 centerTitle: false,
//                 iconTheme: const IconThemeData(color: Colors.white),
//               ),
//             ),
//             navigatorKey: navigatorKey,
//             home: SplashScreen(),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ghp_society_management/constants/export.dart';

/// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase & LocalStorage for background isolate
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalStorage.init();

  print("📩 Background message received: ${message.data}");

  // Only show local notification, no navigation in background isolate
  await FirebaseNotificationService.firebaseMessagingBackgroundHandler(message);
}

/// Request Notification Permission
Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
      alert: true, badge: true, sound: true, criticalAlert: true);
  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print("🚨 User Denied Notification Permission");
  } else {
    print("✅ Notification Permission Granted");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase & Local Storage
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalStorage.init();

  // Ask user for notification permission
  await requestNotificationPermission();

  // Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Notification Service (Local + Firebase)
  await FirebaseNotificationService.initialize();

  runApp(const MyApp());
}

late Size size;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    /// Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      print("📩 Foreground message received: ${message.data}");
      FirebaseNotificationService.handleMessage(message, isForeground: true);
    });

    /// Background → Foreground (when notification tapped)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("🔔 Notification tapped from background: ${message.data}");
      FirebaseNotificationService.handleMessage(message, isForeground: false);
    });

    /// Terminated state
    FirebaseMessaging.instance.getInitialMessage().then((mess) {
      if (mess != null) {
        print("🚀 App launched from terminated via notification: ${mess.data}");
        FirebaseNotificationService.handleMessage(mess,
            isForeground: false, fromTerminated: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.sizeOf(context);

    return MultiBlocProvider(
      providers: BlocProviders.providers,
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) {
          return MaterialApp(
            title: "GHP Society",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(color: AppTheme.white),
                backgroundColor: AppTheme.primaryColor,
                centerTitle: false,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
            ),
            navigatorKey: navigatorKey,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
