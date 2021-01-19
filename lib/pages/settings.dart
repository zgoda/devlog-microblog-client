import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool unsecuredTransport = false;
  bool saveCredentials = true;

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
                hintText: 'Host name or IP address',
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            SwitchListTile(
              title: const Text('Use unsecured transport'),
              value: unsecuredTransport,
              onChanged: (value) {
                setState(() {
                  unsecuredTransport = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Store login credentials'),
              value: saveCredentials,
              onChanged: (value) {
                setState(() {
                  saveCredentials = value;
                });
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Form data saved'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
