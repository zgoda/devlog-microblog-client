import 'dart:async';
import 'dart:io';

import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/utils/web.dart';
import 'package:devlog_microblog_client/viewmodels/userprefs.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final currentStatusProvider = FutureProvider<ServerStatus>((ref) async {
  final stream = ref.watch(serverStatusProvider.stream);
  return await stream.last;
});

final serverStatusProvider = StreamProvider<ServerStatus>((ref) {
  final service = ref.watch(serverStatusServiceProvider);
  return service.status();
});

final serverStatusServiceProvider = Provider<ServerStatusService>((ref) {
  final prefsProvider = ref.watch(userPrefsViewModelProvider);
  return ServerStatusService(prefs: prefsProvider);
});

enum ServerStatus {
  offline,
  error,
  online,
}

class ServerStatusService {
  final Uri _url;
  final _http = http.Client();

  static const _endpoint = 'login';

  final Duration _interval = Duration(seconds: 15);
  var _stopStream = false;

  ServerStatusService({@required AppPrefs prefs})
      : _url = buildServerUrl(
          prefs.host,
          buildEndpointPath(_endpoint),
          secure: !prefs.insecureTransport,
        ),
        super();

  void stop() {
    _stopStream = true;
  }

  Stream<ServerStatus> status() async* {
    while (true) {
      if (_stopStream) {
        break;
      }
      final status = await _checkStatus();
      yield status;
      await Future.delayed(_interval);
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
}
