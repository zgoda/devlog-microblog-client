import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends HookWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsData = useProvider(settingsProvider);
    return settingsData.when(
      data: (settings) {
        final host = useState(settings.host);
        final hostController = useTextEditingController(text: settings.host);
        final defaultAuthor = useState(settings.defaultAuthor);
        final defaultAuthorController =
            useTextEditingController(text: settings.defaultAuthor);
        final unsecuredTransport = useState(settings.unsecuredTransport);
        final modeOffline = useState(settings.modeOffline);
        final storeCredentials = useState(settings.storeCredentials);
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
                controller: hostController,
                onChanged: (value) {
                  host.value = value;
                  settings.host = value;
                },
              ),
              SizedBox(height: 25),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Author',
                  hintText: 'Default post author',
                  contentPadding: EdgeInsets.all(10),
                ),
                controller: defaultAuthorController,
                onChanged: (value) {
                  defaultAuthor.value = value;
                  settings.defaultAuthor = value;
                },
              ),
              SizedBox(height: 25),
              SwitchListTile(
                title: const Text('Use unsecured transport'),
                value: unsecuredTransport.value,
                onChanged: (value) {
                  unsecuredTransport.value = value;
                  settings.unsecuredTransport = value;
                },
              ),
              SwitchListTile(
                title: const Text('Offline mode'),
                value: modeOffline.value,
                onChanged: (value) {
                  modeOffline.value = value;
                  settings.modeOffline = value;
                },
              ),
              SwitchListTile(
                title: const Text('Store login credentials'),
                value: storeCredentials.value,
                onChanged: (value) {
                  storeCredentials.value = value;
                  settings.storeCredentials = value;
                },
              ),
              SizedBox(height: 25),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () {
                  settings.save();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, stack) => Center(
        child: Text(err),
      ),
    );
  }
}
