import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {

  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static String connectStateKey = "connect_state_key";
  static String storeNameKey = "store_name_key";

  static bool? getBool({
    required String key,
  }) => sharedPreferences.getBool(key);

  static String? getString({
    required String key,
  }) =>  sharedPreferences.getString(key);

  static int getInt({required String key}) {
    var value = sharedPreferences.getInt(key);
    if (value == null) {
      return -1;
    } else {
      return value;
    }
  }


  static double? getDouble({
    required String key,
  }) =>  sharedPreferences.getDouble(key);

  static Future<bool> setData({
    required String key,
    required dynamic value,
  }) async {
    if(value is String) return await sharedPreferences.setString(key, value);
    if(value is int) return await sharedPreferences.setInt(key, value);
    if(value is bool) return await sharedPreferences.setBool(key, value);
    return await sharedPreferences.setDouble(key, value);
  }

}