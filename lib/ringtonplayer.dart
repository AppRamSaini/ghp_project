// import 'dart:async';
//
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:vibration/vibration.dart';
//
// class GlobalAlertService {
//   static final FlutterRingtonePlayer _player = FlutterRingtonePlayer();
//   static bool _isPlaying = false;
//   static Timer? _ringtoneTimer;
//
//   /// Start ringtone + vibration
//   static Future<void> startAlerts({int durationSeconds = 50}) async {
//     if (_isPlaying) return;
//     _isPlaying = true;
//
//     // Vibration
//     if (await Vibration.hasVibrator() ?? false) {
//       Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: 0);
//     }
//
//     // Play ringtone (looping)
//     await _player.playRingtone(looping: true, asAlarm: false);
//
//     // Auto-stop after timeout
//     _ringtoneTimer = Timer(Duration(seconds: durationSeconds), stopAlerts);
//   }
//
//   /// Stop ringtone + vibration everywhere
//   static void stopAlerts() {
//     if (!_isPlaying) return;
//
//     _player.stop();
//     Vibration.cancel();
//     _ringtoneTimer?.cancel();
//     _ringtoneTimer = null;
//     _isPlaying = false;
//
//     print("🔕 SOS/Visitor ringtone stopped globally!");
//   }
// }
