import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ghp_society_management/constants/export.dart';

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
  print("App Started");
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
          return MaterialApp(title: "Ghp Society",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(color: AppTheme.white),
                backgroundColor: AppTheme.primaryColor,
                centerTitle: false,
                iconTheme: IconThemeData(color: Colors.white),
              ),
            ),
            navigatorKey: navigatorKey,
            // navigatorObservers: [analyticsObserver],
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
