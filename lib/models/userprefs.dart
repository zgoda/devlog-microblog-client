import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Credentials {
  final String name;
  final String password;

  Credentials({@required String name, @required String password})
      : this.name = name,
        this.password = password,
        super();
}

class UserSettingsModel {
  final bool unsecuredTransport;
  bool storeCredentials;
  final String host;
  String defaultAuthor;
  String username;
  String password;

  UserSettingsModel(
    this.unsecuredTransport,
    this.storeCredentials,
    this.host,
    this.defaultAuthor,
    this.username,
    this.password,
  );

  UserSettingsModel.empty() : this(false, true, '', '', '', '');

  UserSettingsModel.copyFrom(UserSettingsModel other)
      : this(
          other.unsecuredTransport,
          other.storeCredentials,
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

  static Future<UserSettingsModel> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final unsecuredTransport = prefs.getBool('unsecuredTransport') ?? false;
    final storeCredentials = prefs.getBool('storeCredentials') ?? true;
    final host = prefs.getString('host');
    final defaultAuthor = prefs.getString('defaultAuthor');
    var username = '';
    var password = '';
    final FlutterSecureStorage securePrefs = FlutterSecureStorage();
    try {
      username = await securePrefs.read(key: 'username');
      password = await securePrefs.read(key: 'password');
    } catch (e) {
      await securePrefs.deleteAll();
    }
    return UserSettingsModel(
      unsecuredTransport,
      storeCredentials,
      host,
      defaultAuthor,
      username,
      password,
    );
  }

  void setCredentials({@required Credentials credentials}) {
    this.username = credentials.name;
    this.password = credentials.password;
  }

  Future<void> saveCredentials({@required Credentials credentials}) async {
    if (storeCredentials) {
      final FlutterSecureStorage securePrefs = FlutterSecureStorage();
      try {
        await securePrefs.write(key: 'username', value: credentials.name);
        await securePrefs.write(key: 'password', value: credentials.password);
      } catch (e) {
        await securePrefs.deleteAll();
      }
    }
  }

  bool hasCredentials() =>
      !['', null].contains(username) && !['', null].contains(password);

  bool isConfigured() => ![null, ''].contains(host);

  Future<void> save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('unsecuredTransport', unsecuredTransport);
    await prefs.setBool('storeCredentials', storeCredentials);
    await prefs.setString('host', host);
    await prefs.setString('defaultAuthor', defaultAuthor);
    await saveCredentials(
      credentials: Credentials(name: username, password: password),
    );
  }
}
