import 'package:flutter/material.dart';

enum ServerStatus {
  OFFLINE,
  ERROR,
  ONLINE,
}

Icon serverStatusIcon(ServerStatus status) {
  Icon icon;
  switch (status) {
    case ServerStatus.OFFLINE:
      icon = Icon(Icons.lightbulb_outline);
      break;
    case ServerStatus.ERROR:
      icon = Icon(
        Icons.lightbulb,
        color: Colors.red,
      );
      break;
    case ServerStatus.ONLINE:
      icon = Icon(
        Icons.lightbulb,
        color: Colors.green,
      );
      break;
  }
  return icon;
}
