import 'dart:convert';
import 'dart:io';

import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:devlog_microblog_client/utils/web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final authTokenProvider = Provider<String>((ref) {
  final service = ref.watch(authenticationServiceProvider);
  return service.token;
});

final authenticationServiceProvider = Provider<AuthenticationService>((ref) {
  final prefs = ref.watch(userPrefsProvider.state);
  return AuthenticationService(prefs);
});

enum AuthResult {
  none,
  ok,
  networkError,
  clientError,
}

class AuthenticationService {
  String _userName;
  String _password;
  Uri _url;
  String _token;
  final _http = http.Client();

  static const ENDPOINT = 'login';

  AuthenticationService(UserSettingsModel settings) {
    _userName = settings.username;
    _password = settings.password;
    _url = buildServerUrl(
      settings.host,
      buildEndpointPath(ENDPOINT),
      secure: !settings.unsecuredTransport,
    );
  }

  Map<String, String> authHeader() {
    if ([null, ''].contains(_token)) {
      return {};
    }
    return {'Authorization': 'Basic $_token'};
  }

  bool hasCredentials() => ![_userName, _password].contains(null);
  bool hasToken() => !['', null].contains(_token);

  Future<AuthResult> login() async {
    final data = {
      'name': _userName,
      'password': _password,
    };
    _token = '';
    try {
      final resp = await _http.post(_url, body: data);
      if (resp.statusCode == 200) {
        final Map<String, dynamic> respData = jsonDecode(resp.body);
        _token = respData['token'];
        return AuthResult.ok;
      }
      return AuthResult.clientError;
    } on SocketException {
      return AuthResult.networkError;
    }
  }

  String get token {
    return _token;
  }
}
