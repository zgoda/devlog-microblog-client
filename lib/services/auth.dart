import 'dart:convert';
import 'dart:io';

import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/utils/web.dart';
import 'package:devlog_microblog_client/viewmodels/credentials.dart';
import 'package:devlog_microblog_client/viewmodels/userprefs.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final authTokenProvider = Provider<String>((ref) {
  final service = ref.watch(authenticationServiceProvider);
  return service.token;
});

final authenticationServiceProvider = Provider<AuthenticationService>((ref) {
  final prefs = ref.watch(userPrefsProvider);
  final credentials = ref.watch(credentialsProvider);
  return AuthenticationService(
    host: prefs.host,
    secure: !prefs.insecureTransport,
    credentials: credentials,
  );
});

enum AuthResult {
  none,
  ok,
  networkError,
  clientError,
}

class AuthenticationService {
  final Credentials _credentials;
  final Uri _url;
  String _token;
  final _http = http.Client();

  static const _endpoint = 'login';

  AuthenticationService(
      {@required String host,
      @required bool secure,
      @required Credentials credentials})
      : this._credentials = credentials,
        this._url =
            buildServerUrl(host, buildEndpointPath(_endpoint), secure: secure),
        super();

  Map<String, String> authHeader() {
    if ([null, ''].contains(_token)) {
      return {};
    }
    return {'Authorization': 'Basic $_token'};
  }

  Future<AuthResult> login() async {
    try {
      final resp = await _http.post(_url, body: _credentials.loginData);
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

  String get token => _token;
}
