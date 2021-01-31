import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSettingsModel {
  bool unsecuredTransport;
  bool storeCredentials;
  bool modeOffline;
  String host;
  String defaultAuthor;
  String username;
  String password;

  UserSettingsModel(
    this.unsecuredTransport,
    this.storeCredentials,
    this.modeOffline,
    this.host,
    this.defaultAuthor,
  );

  static Future<UserSettingsModel> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final unsecuredTransport = prefs.getBool('unsecuredTransport') ?? false;
    final storeCredentials = prefs.getBool('storeCredentials') ?? true;
    final modeOffline = prefs.getBool('modeOffline') ?? false;
    final host = prefs.getString('host');
    final defaultAuthor = prefs.getString('defaultAuthor');
    final model = UserSettingsModel(
      unsecuredTransport,
      storeCredentials,
      modeOffline,
      host,
      defaultAuthor,
    );
    final FlutterSecureStorage securePrefs = FlutterSecureStorage();
    try {
      model.username = await securePrefs.read(key: 'username');
      model.password = await securePrefs.read(key: 'password');
    } catch (e) {
      securePrefs.deleteAll();
    }
    return model;
  }

  void setCredentials(String username, String password) {
    this.username = username;
    this.password = password;
  }

  void saveCredentials(String username, String password) {
    if (storeCredentials) {
      final FlutterSecureStorage securePrefs = FlutterSecureStorage();
      try {
        securePrefs.write(key: 'username', value: username);
        securePrefs.write(key: 'password', value: password);
      } catch (e) {
        securePrefs.deleteAll();
      }
    }
  }

  bool hasCredentials() {
    return storeCredentials && username != null && password != null;
  }

  bool isConfigured() {
    return ![null, ''].contains(host);
  }

  void save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('unsecuredTransport', unsecuredTransport);
    prefs.setBool('storeCredentials', storeCredentials);
    prefs.setBool('modeOffline', modeOffline);
    prefs.setString('host', host);
    prefs.setString('defaultAuthor', defaultAuthor);
    saveCredentials(username, password);
  }
}
