import 'dart:convert';

import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final authenticationServiceProvider = Provider<AuthenticationService>((ref) {
  final settingsData = ref.watch(settingsProvider);
  AuthenticationService service;
  settingsData.whenData(
    (settings) => service = AuthenticationService.getInstance(settings),
  );
  return service;
});

class AuthenticationService {
  static AuthenticationService _instance;
  String _userName;
  String _password;
  String _url;
  String _token;

  UserSettingsModel _settings;

  static getInstance(UserSettingsModel settings) {
    if (_instance == null) {
      _instance = AuthenticationService(settings);
    }
    return _instance;
  }

  AuthenticationService(UserSettingsModel settings) {
    _settings = settings;
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
