import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/view/resident/sos/sos_incoming_alert.dart';
import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';

/// Background Notification Handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalStorage.init();

  FirebaseNotificationService.showCustomNotification(
      message: message, customSound: "ringtone.caf");

  // final Map<String, dynamic> payload = message.toMap();
  // final decoded = deepDecode(payload);
  // print("Background MSG Payload ----->>> $decoded");
  // String? type;
  // if (decoded['data'] is Map) {
  //   if (decoded['data']?['data'] is Map) {
  //     type = decoded['data']?['data']?['type'];
  //   } else {
  //     type = decoded['data']?['type'];
  //   }
  // }
  // print("Message type ----->>> $type");
  // FirebaseNotificationService.handleMessage(message);
  // if (type == 'incoming_request' || type == 'sos_alert') {
  //   FirebaseNotificationService.startVibrationAndRingtone();
  // }
}

/// Ask for Notification Permission
Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
      alert: true, badge: true, sound: true, criticalAlert: true);

  print("🔔 Permission: ${settings.authorizationStatus}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalStorage.init();

  await requestNotificationPermission();

  // Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Init Notification Service
  await FirebaseNotificationService.initialize();

  // ✅ Get initial message for terminated state
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

    FirebaseMessaging.onMessage.listen((message) {
      final Map<String, dynamic> payload = message.toMap();
      final decoded = deepDecode(payload);
      print("Foreground message received  ----->>> $decoded");
      String? type;
      if (decoded['data'] is Map) {
        if (decoded['data']?['data'] is Map) {
          type = decoded['data']?['data']?['type'];
        } else {
          type = decoded['data']?['type'];
        }
      }
      print("Message type ----->>> $type");
      FirebaseNotificationService.handleMessage(message);
      if (type == 'incoming_request' || type == 'sos_alert') {
        FirebaseNotificationService.startVibrationAndRingtone();
      }
    });

    // Foreground listener
    // FirebaseMessaging.onMessage.listen((message) {
    //   // final rawMessage = message.data['message'];
    //   // final Map<String, dynamic> data = jsonDecode(rawMessage);
    //   //
    //   // print('Full MSG ----->>>$data');
    //   // final type = data['type'] ?? data['data']?['type'];
    //   // print('Message type ----->>> $type');
    //   // FirebaseNotificationService.handleMessage(message);
    //   // if (data['data']?['type'] == 'incoming_request' ||
    //   //     data['data']?['type'] == 'sos_alert') {
    //   //   FirebaseNotificationService.startVibrationAndRingtone();
    //   // }
    //
    //   // final rawMessage = message.data['message'];
    //   // final Map<String, dynamic> data = jsonDecode(rawMessage);
    //   // print("Full message----->>> : ${message.toMap()}");
    //   // FirebaseNotificationService.handleMessage(message);
    //   // if (message.data['type'] == 'incoming_request' ||
    //   //     message.data['type'] == 'sos_alert') {
    //   //   FirebaseNotificationService.startVibrationAndRingtone();
    //   // }
    //
    //   final Map<String, dynamic> payload = message.toMap();
    //
    //   final data = deepDecode(payload);
    //
    //   print("-----------<<<<<<<<$data");
    //   FirebaseNotificationService.handleMessage(message);
    //   if (data['data']['data']?['type'] == 'incoming_request' ||
    //       data['data']['data']?['type'] == 'sos_alert') {
    //     FirebaseNotificationService.startVibrationAndRingtone();
    //   }
    //   //
    //   // // Pretty JSON format
    //   // final prettyJson =
    //   //     const JsonEncoder.withIndent("  ").convert(decodedPayload);
    //   //
    //   // print("📩 Complete Decoded Payload:\n$prettyJson");
    // });

    // Background → Foreground (tap on notification)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Notification tapped (background): ${message.data}");
      final Map<String, dynamic> payload = message.toMap();
      final decoded = deepDecode(payload);
      print("Decoded Payload ----->>> $decoded");
      String? type;
      if (decoded['data'] is Map) {
        if (decoded['data']?['data'] is Map) {
          type = decoded['data']?['data']?['type'];
        } else {
          type = decoded['data']?['type'];
        }
      }
      print("Message type ----->>> $type");
      FirebaseNotificationService.handleMessage(message);
      if (type == 'incoming_request' || type == 'sos_alert') {
        FirebaseNotificationService.startVibrationAndRingtone();
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

  /// Decide initial page for terminated state
  Widget _getStartPage(RemoteMessage? message) {
    if (message != null && message.data.isNotEmpty) {
      final type = message.data['type'] ?? '';

      if (type == 'incoming_request') {
        return VisitorsIncomingRequestPage(
          message: message,
          fromPage: "terminate",
          setPageValue: (val) {
            if (val) FirebaseNotificationService.stopVibrationAndRingtone();
          },
        );
      } else if (type == 'sos_alert') {
        return SosIncomingAlert(
          message: message,
          setPageValue: (val) {
            if (val) FirebaseNotificationService.stopVibrationAndRingtone();
          },
        );
      }
    }
    return SplashScreen(); // default page
  }
}

/// Recursive JSON decoder: हर nested JSON string को decode कर देता है
dynamic deepDecode(dynamic value) {
  if (value is String) {
    try {
      final decoded = jsonDecode(value);
      return deepDecode(decoded); // दुबारा check करो अंदर और nested तो नहीं
    } catch (_) {
      return value; // अगर decode न हुआ तो string ही रहने दो
    }
  } else if (value is Map) {
    return value.map((key, val) => MapEntry(key, deepDecode(val)));
  } else if (value is List) {
    return value.map((val) => deepDecode(val)).toList();
  }
  return value;
}
