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
    final _hostController = useTextEditingController(text: _settings.host);
    final _defaultAuthor = useState(_settings.defaultAuthor);
    final _defaultAuthorController =
        useTextEditingController(text: _settings.defaultAuthor);
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
          SizedBox(height: 15),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Host',
              hintText: 'Host name or IP address',
              contentPadding: EdgeInsets.all(10),
            ),
            controller: _hostController,
            onChanged: (value) {
              _host.value = value;
              _settings.host = value;
            },
          ),
          SizedBox(height: 25),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Author',
              hintText: 'Default post author',
              contentPadding: EdgeInsets.all(10),
            ),
            controller: _defaultAuthorController,
            onChanged: (value) {
              _defaultAuthor.value = value;
              _settings.defaultAuthor = value;
            },
          ),
          SizedBox(height: 25),
          SwitchListTile(
            title: const Text('Use unsecured transport'),
            value: _unsecuredTransport.value,
            onChanged: (value) {
              _unsecuredTransport.value = value;
              _settings.unsecuredTransport = value;
            },
          ),
          SwitchListTile(
            title: const Text('Offline mode'),
            value: _modeOffline.value,
            onChanged: (value) {
              _modeOffline.value = value;
              _settings.modeOffline = value;
            },
          ),
          SwitchListTile(
            title: const Text('Store login credentials'),
            value: _storeCredentials.value,
            onChanged: (value) {
              _storeCredentials.value = value;
              _settings.storeCredentials = value;
            },
          ),
          SizedBox(height: 25),
          ElevatedButton(
            child: Text('Save'),
            onPressed: () {
              _saveSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    _settings.save();
  }
}
