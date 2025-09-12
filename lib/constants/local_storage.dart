import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences localStorage;

  static init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}

Future<bool> hasSeenShowcase() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hasSeenShowcase') ?? false;
}

Future<void> setShowcaseSeen() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasSeenShowcase', true);
}
