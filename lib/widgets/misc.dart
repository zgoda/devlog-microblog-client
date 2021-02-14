import 'package:devlog_microblog_client/services/serverstatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ServerStatusIcon extends HookWidget {
  Icon _serverStatusIcon(ServerStatus status) {
    Icon icon;
    switch (status) {
      case ServerStatus.offline:
        icon = Icon(Icons.lightbulb_outline);
        break;
      case ServerStatus.error:
        icon = Icon(
          Icons.lightbulb,
          color: Colors.red,
        );
        break;
      case ServerStatus.online:
        icon = Icon(
          Icons.lightbulb,
          color: Colors.green,
        );
        break;
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    final serverStatus = useProvider(serverStatusProvider);
    Widget result;
    serverStatus.when(
      data: (status) => result = _serverStatusIcon(status),
      loading: () => result = _serverStatusIcon(ServerStatus.offline),
      error: (_, __) => result = _serverStatusIcon(ServerStatus.error),
    );
    return result;
  }
}

SwitchListTile userPrefsSwitch(
  String title,
  bool initialValue,
  void Function(bool) onChanged,
) {
  return SwitchListTile(
    value: initialValue,
    onChanged: onChanged,
    title: Text(title),
  );
}
