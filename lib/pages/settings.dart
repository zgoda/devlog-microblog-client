import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _unsecuredTransport;
  bool _saveCredentials;
  String _host;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _host = prefs.getString('host');
        _unsecuredTransport = prefs.getBool('unsecuredTransport');
        _saveCredentials = prefs.getBool('storeCredentials');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              initialValue: _host,
              onChanged: (value) {
                setState(() {
                  _host = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Use unsecured transport'),
              value: _unsecuredTransport,
              onChanged: (value) {
                setState(() {
                  _unsecuredTransport = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Store login credentials'),
              value: _saveCredentials,
              onChanged: (value) {
                setState(() {
                  _saveCredentials = value;
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
  }

  void _saveSettings() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('unsecuredTransport', _unsecuredTransport);
      prefs.setBool('storeCredentials', _saveCredentials);
      prefs.setString('host', _host);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Form data saved'),
        ),
      );
    });
  }
}
