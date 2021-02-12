import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ServerConfigForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CredentialsConfigForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class VerifySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AppConfigWizard extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final currentStep = useState(0);
    final complete = useState(false);
    final steps = <Step>[
      Step(
        title: const Text('Serwer'),
        content: ServerConfigForm(),
      ),
      Step(
        title: const Text('Login'),
        content: CredentialsConfigForm(),
      ),
      Step(
        title: const Text('Weryfikacja'),
        content: VerifySettingsPage(),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Ustawienia aplikacji'),
        actions: <Widget>[
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Zapisywanie ustawień...'))),
            child: Text('Zapisz'),
            style: TextButton.styleFrom(primary: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stepper(
              steps: steps,
            ),
          ),
        ],
      ),
    );
  }
}
