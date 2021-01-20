import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsModel {
  bool unsecuredTransport;
  bool storeCredentials;
  String host;
  String username;
  String password;

  UserSettingsModel(this.unsecuredTransport, this.storeCredentials, this.host);

  static Future<UserSettingsModel> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final unsecuredTransport = prefs.getBool('unsecuredTransport');
    final storeCredentials = prefs.getBool('storeCredentials');
    final host = prefs.getString('host');
    final model = UserSettingsModel(unsecuredTransport, storeCredentials, host);
    model.username = prefs.getString('username');
    model.password = prefs.getString('password');
    return model;
  }

  void setCredentials(String username, String password) {
    this.username = username;
    this.password = password;
  }

  void save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('unsecuredTransport', unsecuredTransport);
    prefs.setBool('storeCredentials', storeCredentials);
    prefs.setString('host', host);
    if (storeCredentials) {
      prefs.setString('username', username);
      prefs.setString('password', password);
    }
  }
}