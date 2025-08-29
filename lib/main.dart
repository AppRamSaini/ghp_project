import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ghp_society_management/constants/export.dart';

/// Handle Background Notification (Android & iOS)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase & LocalStorage for background isolate
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalStorage.init();

  print("📩 Background message received: ${message.data}");

  // Forward to Notification Service (handle local notification + actions)
  await FirebaseNotificationService.firebaseMessagingBackgroundHandler(message);
}

/// Request Notification Permission
Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    criticalAlert: true,
  );

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

    // Foreground listener
    FirebaseMessaging.onMessage.listen((message) {
      print("Foreground message received: ${message.data}");
      FirebaseNotificationService.handleMessage(message, isForeground: true);
    });

    // Background → Foreground (when notification tapped)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Notification tapped: ${message.data}");
      FirebaseNotificationService.handleMessage(message, isForeground: false);
    });

    // Terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("App launched from terminated via notification: ${message.data}");
        FirebaseNotificationService.handleMessage(
          message,
          isForeground: false,
          fromTerminated: true,
        );
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
            title: "Ghp Society",
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
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
