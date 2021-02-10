import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:devlog_microblog_client/widgets/misc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends HookWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsNotifier = useProvider(userPrefsProvider);
    final settings = useProvider(userPrefsProvider.state);
    final hostController = useTextEditingController(text: settings.host);
    final defaultAuthorController =
        useTextEditingController(text: settings.defaultAuthor);
    final unsecuredTransport = useState(settings.unsecuredTransport);
    final modeOffline = useState(settings.modeOffline);
    final storeCredentials = useState(settings.storeCredentials);
    final unsecuredTransportSwitch = userPrefsSwitch(
      'Use unsecured transport',
      unsecuredTransport.value,
      (value) => unsecuredTransport.value = value,
    );
    final modeOfflineSwitch = userPrefsSwitch(
      'Offline mode',
      modeOffline.value,
      (value) => modeOffline.value = value,
    );
    final storeCredentialsSwitch = userPrefsSwitch(
      'Store login credentials',
      storeCredentials.value,
      (value) => storeCredentials.value = value,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Application settings'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: Colors.white),
            onPressed: () {
              settingsNotifier.update(UserSettingsModel(
                unsecuredTransport.value,
                storeCredentials.value,
                modeOffline.value,
                hostController.text,
                defaultAuthorController.text,
                settings.username,
                settings.password,
              ));
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Host',
                hintText: 'Host name or IP address',
                contentPadding: EdgeInsets.all(10),
              ),
              controller: hostController,
            ),
            SizedBox(height: 25),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Author',
                hintText: 'Default post author',
                contentPadding: EdgeInsets.all(10),
              ),
              controller: defaultAuthorController,
            ),
            SizedBox(height: 25),
            unsecuredTransportSwitch,
            modeOfflineSwitch,
            storeCredentialsSwitch,
          ],
        ),
      ),
    );
  }
}
