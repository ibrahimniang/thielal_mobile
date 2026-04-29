import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionStorage {
  SessionStorage._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _sessionExpiryKey = 'session_expiry_at';

  static Future<void> saveSessionExpiry(DateTime dateTime) async {
    await _storage.write(
      key: _sessionExpiryKey,
      value: dateTime.toIso8601String(),
    );
  }

  static Future<DateTime?> getSessionExpiry() async {
    final value = await _storage.read(key: _sessionExpiryKey);
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  static Future<bool> isSessionExpired() async {
    final expiry = await getSessionExpiry();
    if (expiry == null) return true;
    return DateTime.now().isAfter(expiry);
  }

  static Future<void> clearSessionExpiry() async {
    await _storage.delete(key: _sessionExpiryKey);
  }
}
