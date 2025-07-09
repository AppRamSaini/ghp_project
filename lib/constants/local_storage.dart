import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences localStorage;

  static init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}
