import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefController {
  late SharedPreferences _sharedPreferences;

  SharedPrefController._internal();

  static final SharedPrefController _instance = SharedPrefController._internal();
  factory SharedPrefController() {
    return _instance;
  }
  Future<void> initSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  SharedPreferences get pref => _sharedPreferences;

  Future<bool> save({required String key, required dynamic value}) async {
    if (value is String) {
      return await _sharedPreferences.setString(key, value);
    } else if (value is int) {
      return await _sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      return await _sharedPreferences.setBool(key, value);
    } else if (value is double) {
      return await _sharedPreferences.setDouble(key, value);
    } else if (value is List<String>) {
      return await _sharedPreferences.setStringList(key, value);
    }
    throw Exception('The Input Type unacceptable');
  }

  dynamic get({required String key}) {
    return _sharedPreferences.get(key);
  }

  Future<bool> removeKey({required String key}) async {
    return await _sharedPreferences.remove(key);
  }
}
