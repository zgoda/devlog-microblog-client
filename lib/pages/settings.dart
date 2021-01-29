import 'package:devlog_microblog_client/servicelocator.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsScreen extends HookWidget {
  final _settings = locator<LocalStorageService>().settings;

  SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _host = useState(_settings.host);
    final _defaultAuthor = useState(_settings.defaultAuthor);
    final _unsecuredTransport = useState(_settings.unsecuredTransport);
    final _modeOffline = useState(_settings.modeOffline);
    final _storeCredentials = useState(_settings.storeCredentials);
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
            initialValue: _settings.host,
            onChanged: (value) {
              _host.value = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Author',
              hintText: 'Default post author',
              contentPadding: EdgeInsets.all(10),
            ),
            initialValue: _settings.defaultAuthor,
            onChanged: (value) {
              _defaultAuthor.value = value;
            },
          ),
          SwitchListTile(
            title: const Text('Use unsecured transport'),
            value: _settings.unsecuredTransport,
            onChanged: (value) {
              _unsecuredTransport.value = value;
            },
          ),
          SwitchListTile(
            title: const Text('Offline mode'),
            value: _settings.modeOffline,
            onChanged: (value) {
              _modeOffline.value = value;
            },
          ),
          SwitchListTile(
            title: const Text('Store login credentials'),
            value: _settings.storeCredentials,
            onChanged: (value) {
              _storeCredentials.value = value;
            },
          ),
          ElevatedButton(
            child: Text('Save'),
            onPressed: _saveSettings,
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    _settings.save();
  }
}
