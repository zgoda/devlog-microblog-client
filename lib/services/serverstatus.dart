import 'dart:async';
import 'dart:io';

import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:devlog_microblog_client/utils/web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final serverStatusProvider = StreamProvider<ServerStatus>((ref) {
  final service = ref.watch(serverStatusServiceProvider);
  return service.status();
});

final serverStatusServiceProvider = Provider<ServerStatusService>((ref) {
  final prefs = ref.watch(userPrefsProvider.state);
  return ServerStatusService.getInstance(prefs);
});

enum ServerStatus {
  offline,
  error,
  online,
}

class ServerStatusService {
  static ServerStatusService _instance;

  Uri _url;
  final _http = http.Client();

  static const ENDPOINT = 'login';

  final Duration _interval = Duration(seconds: 15);
  var _stopStream = false;

  ServerStatusService(UserSettingsModel prefs) {
    _url = buildServerUrl(
      prefs.host,
      buildEndpointPath(ENDPOINT),
      secure: !prefs.unsecuredTransport,
    );
  }

  void stop() {
    _stopStream = true;
  }

  Stream<ServerStatus> status() async* {
    while (true) {
      await Future.delayed(_interval);
      final status = await _checkStatus();
      yield status;
      if (_stopStream) {
        break;
      }
    }
  }

  Future<ServerStatus> _checkStatus() async {
    try {
      final resp = await _http.head(_url);
      if (resp.statusCode == 200) {
        return ServerStatus.online;
      } else {
        return ServerStatus.error;
      }
    } on SocketException {
      return ServerStatus.offline;
    }
  }

  static ServerStatusService getInstance(UserSettingsModel prefs) {
    if (_instance == null) {
      _instance = ServerStatusService(prefs);
    }
    return _instance;
  }
}
