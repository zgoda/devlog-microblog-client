import 'dart:async';
import 'dart:io';

import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:devlog_microblog_client/utils/web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final serverStatusProvider = Provider<ServerStatus>((ref) {
  final service = ref.watch(serverStatusServiceProvider);
  return service.status;
});

final serverStatusServiceProvider = Provider<ServerStatusService>((ref) {
  final prefs = ref.watch(userPrefsProvider.state);
  return ServerStatusService.getInstance(prefs);
});

enum ServerStatus {
  OFFLINE,
  ERROR,
  ONLINE,
}

class ServerStatusService {
  static ServerStatusService _instance;

  Uri _url;
  final _http = http.Client();

  static const ENDPOINT = 'login';

  final Duration _interval = Duration(seconds: 15);
  Timer _timer;
  ServerStatus status = ServerStatus.OFFLINE;

  ServerStatusService(UserSettingsModel prefs) {
    _url = buildServerUrl(
      prefs.host,
      buildEndpointPath(ENDPOINT),
      secure: !prefs.unsecuredTransport,
    );
  }

  void start() {
    _timer = Timer.periodic(_interval, (timer) async {
      await _checkStatus();
    });
  }

  void stop() {
    _timer.cancel();
  }

  Future<void> _checkStatus() async {
    try {
      final resp = await _http.head(_url);
      if (resp.statusCode == 200) {
        status = ServerStatus.ONLINE;
      } else {
        status = ServerStatus.ERROR;
      }
    } on SocketException {
      status = ServerStatus.OFFLINE;
    }
  }

  static ServerStatusService getInstance(UserSettingsModel prefs) {
    if (_instance == null) {
      _instance = ServerStatusService(prefs);
    }
    return _instance;
  }
}
