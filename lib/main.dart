import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/view/resident/sos/sos_incoming_alert.dart';
import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    criticalAlert: true,
  );
  print("🔔 Permission: ${settings.authorizationStatus}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalStorage.init();
  await requestNotificationPermission();

  await FirebaseNotificationService.initialize();

  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();

  runApp(MyApp(initialMessage: initialMessage));
}

late Size size;

class MyApp extends StatefulWidget {
  final RemoteMessage? initialMessage;
  const MyApp({super.key, this.initialMessage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    /// Foreground notification listener
    FirebaseMessaging.onMessage.listen((message) {
      FirebaseNotificationService.handleMessage(message, source: "foreground");
      FirebaseNotificationService.showCustomNotification(message: message);
    });

    /// Background notification listener (user taps)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      FirebaseNotificationService.handleMessage(message, source: "background");
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
            title: "Ghp Society",
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
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
            home: _getStartPage(widget.initialMessage),
          );
        },
      ),
    );
  }

  /// Terminated state page handling
  Widget _getStartPage(RemoteMessage? remoteMessage) {
    if (remoteMessage != null && remoteMessage.data.isNotEmpty) {
      final type = remoteMessage.data['type'];
      print("📩 Message type (terminated): $type");

      if (type == 'incoming_request') {
        return VisitorsIncomingRequestPage(
          message: remoteMessage,
          fromPage: "terminate",
          setPageValue: (val) {
            if (val) FirebaseNotificationService.stopVibrationAndRingtone();
          },
        );
      } else if (type == 'sos_alert') {
        return SosIncomingAlert(
          message: remoteMessage,
          setPageValue: (val) {
            if (val) FirebaseNotificationService.stopVibrationAndRingtone();
          },
        );
      }
    }

    return SplashScreen(); // default page
  }
}
