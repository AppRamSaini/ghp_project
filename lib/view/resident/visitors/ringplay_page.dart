import 'dart:async';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';

class FirebaseNotificationRingServices {
  static Timer? _ringtoneTimer;

  /// Foreground & Background ringtone
  static Future<void> startVibrationAndRingtone() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: -1);
    }
    FlutterRingtonePlayer().play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.alarm,
      looping: true,
      volume: 1.0,
      asAlarm: true,
    );
    print("▶️ Ringtone & vibration started");
  }

  static void stopVibrationAndRingtone() {
    FlutterRingtonePlayer().stop();
    Vibration.cancel();
    _ringtoneTimer?.cancel();
    _ringtoneTimer = null;
    print("⏹️ Ringtone & vibration stopped!");
  }
}
