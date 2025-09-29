// import 'package:shared_preferences/shared_preferences.dart';

// class CacheManager {
//   static final CacheManager _instance = CacheManager._internal();
//   factory CacheManager() => _instance;

//   static SharedPreferences? _prefs;

//   CacheManager._internal();

//   Future<void> init() async {
//     _prefs ??= await SharedPreferences.getInstance();
//   }

//   Future<void> writeString(String key, String value) async {
//     await init();
//     await _prefs!.setString(key, value);
//   }

//   Future<String?> readString(String key) async {
//     await init();
//     return _prefs!.getString(key);
//   }

//   Future<void> remove(String key) async {
//     await init();
//     await _prefs!.remove(key);
//   }

//   Future<bool> containsKey(String key) async {
//     await init();
//     return _prefs!.containsKey(key);
//   }

//   Future<void> clear() async {
//     await init();
//     await _prefs!.clear();
//   }
// }
