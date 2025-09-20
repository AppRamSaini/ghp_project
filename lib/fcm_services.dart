import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ghp_society_management/controller/update_device_token/update_fcm_cubit.dart';

class FCMTokenService {
  static Future<void> initFCMToken() async {
    // पहला बार token लो
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      print("🔥 Initial FCM Token: $token");
      await sendTokenToServer(token);
    }

    // अगर token refresh हो तो ये listener trigger होगा
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print("♻️ Token refreshed: $newToken");
      await sendTokenToServer(newToken);
    });
  }

  static Future<void> sendTokenToServer(String token) async {
    UpdateFCMCubit updateFCMCubit = UpdateFCMCubit();

    try {
      updateFCMCubit.updateFCMData(token.toString());
    } catch (e) {
      print("❌ Failed to send token: $e");
    }
  }
}
