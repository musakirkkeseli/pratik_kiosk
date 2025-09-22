import '../../core/utility/cache_manager.dart';

class AppStorage {
  static final AppStorage _instance = AppStorage._internal();
  factory AppStorage() => _instance;

  final CacheManager _cacheManager = CacheManager();

  AppStorage._internal();

  // Key'leri burada sabit ve yönetilebilir yapıyoruz.
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'user_id';
  static const String _themeModeKey = 'theme_mode';


  Future<void> saveToken(String token) async {
    await _cacheManager.writeString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return await _cacheManager.readString(_tokenKey);
  }

  Future<void> removeToken() async {
    await _cacheManager.remove(_tokenKey);
  }

  // UserId işlemleri
  Future<void> saveUserId(String userId) async {
    await _cacheManager.writeString(_userIdKey, userId);
  }

  Future<String?> getUserId() async {
    return await _cacheManager.readString(_userIdKey);
  }

  Future<void> removeUserId() async {
    await _cacheManager.remove(_userIdKey);
  }

  // ThemeMode işlemleri (örnek boolean flag string olabilir)
  Future<void> saveThemeMode(String mode) async {
    await _cacheManager.writeString(_themeModeKey, mode);
  }

  Future<String?> getThemeMode() async {
    return await _cacheManager.readString(_themeModeKey);
  }

  Future<void> removeThemeMode() async {
    await _cacheManager.remove(_themeModeKey);
  }

  // Genel clear işlemi
  Future<void> clearAll() async {
    await _cacheManager.clear();
  }
}
