import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends HookWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AsyncValue<UserSettingsModel> settingsData =
        useProvider(userSettingsProvider);
    return settingsData.when(data: (settings) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Application settings'),
        ),
        body: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Host',
                hintText: 'Host name or IP address',
                contentPadding: EdgeInsets.all(10),
              ),
              initialValue: settings.host,
              onChanged: (value) {
                settings.host = value;
                settings.save();
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Author',
                hintText: 'Default post author',
                contentPadding: EdgeInsets.all(10),
              ),
              initialValue: settings.defaultAuthor,
              onChanged: (value) {
                settings.defaultAuthor = value;
                settings.save();
              },
            ),
            SwitchListTile(
              title: const Text('Use unsecured transport'),
              value: settings.unsecuredTransport,
              onChanged: (value) {
                settings.unsecuredTransport = value;
                settings.save();
              },
            ),
            SwitchListTile(
              title: const Text('Offline mode'),
              value: settings.modeOffline,
              onChanged: (value) {
                settings.modeOffline = value;
                settings.save();
              },
            ),
            SwitchListTile(
              title: const Text('Store login credentials'),
              value: settings.storeCredentials,
              onChanged: (value) {
                settings.storeCredentials = value;
                settings.save();
              },
            ),
          ],
        ),
      );
    }, loading: () {
      return Center(
        child: CircularProgressIndicator(),
      );
    }, error: (err, stack) {
      return Center(
        child: Text('Error: $err'),
      );
    });
  }
}
