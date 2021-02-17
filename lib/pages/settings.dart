import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:devlog_microblog_client/utils/forms.dart';
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
    final defaultAuthorController = useTextEditingController(
      text: settings.defaultAuthor,
    );
    final unsecuredTransport = useState(settings.unsecuredTransport);
    final storeCredentials = useState(settings.storeCredentials);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ustawienia aplikacji'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: Theme.of(context).dialogBackgroundColor,
            ),
            onPressed: () {
              settingsNotifier.update(UserPrefs(
                unsecuredTransport.value,
                storeCredentials.value,
                hostController.text,
                defaultAuthorController.text,
                settings.username,
                settings.password,
              ));
              Navigator.of(context).pop();
            },
            child: Text('Zapisz'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DEFAULT_FIELD_SPACER,
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Serwer',
                hintText: 'Nazwa serwera lub jego adres IP',
                contentPadding: DEFAULT_TEXTFIELD_INSETS,
              ),
              controller: hostController,
              autofocus: true,
            ),
            DEFAULT_FIELD_SPACER,
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Autor',
                hintText: 'Domyślny autor',
                contentPadding: DEFAULT_TEXTFIELD_INSETS,
              ),
              controller: defaultAuthorController,
            ),
            DEFAULT_FIELD_SPACER,
            UserPrefsSwitch(
              title: 'Transfer bez SSL',
              initialValue: unsecuredTransport.value,
              onChanged: (value) => unsecuredTransport.value = value,
            ),
            UserPrefsSwitch(
              title: 'Zapisz dane logowania',
              initialValue: storeCredentials.value,
              onChanged: (value) => storeCredentials.value = value,
            ),
          ],
        ),
      ),
    );
  }
}
