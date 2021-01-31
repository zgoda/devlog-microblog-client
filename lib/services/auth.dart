import 'dart:convert';

import 'package:devlog_microblog_client/servicelocator.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  static AuthenticationService _instance;
  String _userName;
  String _password;
  String _url;
  String _token;

  final _settings = locator<LocalStorageService>().settings;

  static getInstance() {
    if (_instance == null) {
      _instance = AuthenticationService();
    }
    return _instance;
  }

  AuthenticationService() {
    final List<String> parts = [];
    if (_settings.unsecuredTransport) {
      parts.add('http:/');
    } else {
      parts.add('https:/');
    }
    parts.addAll([_settings.host, 'api/v1/login']);
    _url = parts.join('/');
  }

  Map<String, String> authHeader() {
    if ([null, ''].contains(_token)) {
      return {};
    }
    return {'Authorization': 'Basic $_token'};
  }

  bool hasCredentials() => ![_userName, _password].contains(null);
  bool isLoggedIn() => !['', null].contains(_token);

  Future<bool> login() async {
    final data = {
      'name': _settings.username,
      'password': _settings.password,
    };
    final resp = await http.post(_url, body: data);
    if (resp.statusCode == 200) {
      final Map<String, dynamic> respData = jsonDecode(resp.body);
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
