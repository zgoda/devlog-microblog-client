import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSettingsModel {
  final bool unsecuredTransport;
  bool storeCredentials;
  bool modeOffline;
  final String host;
  String defaultAuthor;
  String username;
  String password;

  UserSettingsModel(
    this.unsecuredTransport,
    this.storeCredentials,
    this.modeOffline,
    this.host,
    this.defaultAuthor,
    this.username,
    this.password,
  );

  UserSettingsModel.empty() : this(false, true, false, '', '', '', '');

  UserSettingsModel.copyFrom(UserSettingsModel other)
      : this(
          other.unsecuredTransport,
          other.storeCredentials,
          other.modeOffline,
          other.host,
          other.defaultAuthor,
          other.username,
          other.password,
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) &&
      other is UserSettingsModel &&
      runtimeType == other.runtimeType &&
      unsecuredTransport == other.unsecuredTransport &&
      host == other.host;

  @override
  int get hashCode => host.hashCode + unsecuredTransport.hashCode;

  static Future<UserSettingsModel> whenReady(
      Future<SharedPreferences> future) async {
    final prefs = await future;
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
      '',
      '',
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
      '',
      '',
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
    return storeCredentials &&
        !['', null].contains(username) &&
        !['', null].contains(password);
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
