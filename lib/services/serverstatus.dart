import 'dart:async';
import 'dart:io';

import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:devlog_microblog_client/utils/web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final serverStatusProvider = StateProvider<ServerStatus>((ref) {
  ServerStatus status = ServerStatus.OFFLINE;
  ref
      .watch(serverStatusServiceProvider.future)
      .then((service) => status = service.status);
  return status;
});

final serverStatusServiceProvider =
    FutureProvider<ServerStatusService>((ref) async {
  final settings = await ref.watch(settingsProvider.future);
  return ServerStatusService.getInstance(settings);
});

enum ServerStatus {
  OFFLINE,
  ERROR,
  ONLINE,
}

class ServerStatusService {
  static ServerStatusService _instance;
  Uri _url;

  UserSettingsModel _settings;
  http.Client _http;

  final Duration _interval = Duration(seconds: 15);
  Timer _timer;
  ServerStatus status = ServerStatus.OFFLINE;

  ServerStatusService(UserSettingsModel settings) {
    _settings = settings;
    _http = http.Client();
    start();
  }

  void start() {
    _url = buildServerUrl(_settings.host, '/api/v1/login',
        secure: !_settings.unsecuredTransport);
    _checkStatus();
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

  static getInstance(UserSettingsModel settings) {
    if (_instance == null) {
      _instance = ServerStatusService(settings);
    }
    return _instance;
  }
}
