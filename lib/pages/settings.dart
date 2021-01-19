import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsModel {
  bool unsecuredTransport;
  bool storeCredentials;
  String host;

  UserSettingsModel(this.unsecuredTransport, this.storeCredentials, this.host);

  void save(SharedPreferences prefs) {
    prefs.setBool('unsecuredTransport', unsecuredTransport);
    prefs.setBool('storeCredentials', storeCredentials);
    prefs.setString('host', host);
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  UserSettingsModel _settings;
  Future<UserSettingsModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserSettingsModel>(
      future: _future,
      builder: (context, AsyncSnapshot<UserSettingsModel> snapshot) {
        if (snapshot.hasData) {
          _settings = snapshot.data;
          return Scaffold(
            resizeToAvoidBottomPadding: true,
            appBar: AppBar(
              title: Text('Application settings'),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Host',
                      hintText: 'Host name or IP address',
                      contentPadding: EdgeInsets.all(10),
                    ),
                    initialValue: _settings.host,
                    onChanged: (value) {
                      setState(() {
                        _settings.host = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Use unsecured transport'),
                    value: _settings.unsecuredTransport,
                    onChanged: (value) {
                      setState(() {
                        _settings.unsecuredTransport = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Store login credentials'),
                    value: _settings.storeCredentials,
                    onChanged: (value) {
                      setState(() {
                        _settings.storeCredentials = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text('Save'),
                    onPressed: _saveSettings,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Future<UserSettingsModel> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final unsecuredTransport = prefs.getBool('unsecuredTransport');
    final storeCredentials = prefs.getBool('storeCredentials');
    final host = prefs.getString('host');
    return UserSettingsModel(unsecuredTransport, storeCredentials, host);
  }

  void _saveSettings() {
    SharedPreferences.getInstance().then((prefs) {
      _settings.save(prefs);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Form data saved'),
        ),
      );
    });
  }
}
