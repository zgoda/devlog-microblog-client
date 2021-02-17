import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefsService {
  final SharedPreferences _storage;

  UserPrefsService(
    SharedPreferences storage,
  )   : this._storage = storage,
        super();

  static const _hostKey = 'host';
  static const _insecureTransportKey = 'unsecuredTransport';
  static const _storeCredentialsKey = 'storeCredentials';
  static const _defaultAuthorKey = 'defaultAuthor';

  AppPrefs get prefs {
    return AppPrefs(
      host: _storage.getString(_hostKey) ?? '',
      defaultAuthor: _storage.getString(_defaultAuthorKey) ?? '',
      insecureTransport: _storage.getBool(_insecureTransportKey) ?? false,
      storeCredentials: _storage.getBool(_storeCredentialsKey) ?? true,
    );
  }

  Future<void> savePrefs(AppPrefs prefs) async {
    await _storage.setString(_hostKey, prefs.host);
    await _storage.setString(_defaultAuthorKey, prefs.defaultAuthor);
    await _storage.setBool(_insecureTransportKey, prefs.insecureTransport);
    await _storage.setBool(_storeCredentialsKey, prefs.storeCredentials);
  }
}
