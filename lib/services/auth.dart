import 'dart:convert';

import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  String _userName;
  String _password;
  String _url;
  String _token;

  AuthenticationService(UserSettingsModel settings) {
    if (settings.hasCredentials()) {
      _userName = settings.username;
      _password = settings.password;
    }
    final List<String> parts = [];
    if (settings.unsecuredTransport) {
      parts.add('http:/');
    } else {
      parts.add('https:/');
    }
    parts.addAll([settings.host, 'api/v1/login']);
    _url = parts.join('/');
  }

  Map<String, String> authHeader() {
    if ([null, ''].contains(_token)) {
      return {};
    }
    return {'Authorization': 'Basic $_token'};
  }

  bool hasCredentials() => ![_userName, _password].contains(null);

  Future<bool> login() async {
    final data = {
      'name': _userName,
      'password': _password,
    };
    final resp = await http.post(_url, body: data);
    if (resp.statusCode == 200) {
      final Map<String, String> respData = jsonDecode(resp.body);
      _token = respData['token'];
      return true;
    }
    _token = '';
    return false;
  }

  void setCredentials(String userName, String password) {
    _userName = userName;
    _password = password;
  }
}
