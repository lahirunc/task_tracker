import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  late SharedPreferences prefs;

  void init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    prefs.setString(key, value);
  }
}
