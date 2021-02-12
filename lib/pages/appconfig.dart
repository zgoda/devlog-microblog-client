import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/widgets/misc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppConfigWizard extends HookWidget {
  ListTile _verificationStatus(AuthResult status) {
    Icon icon;
    String message;
    String state;
    switch (status) {
      case AuthResult.none:
        icon = Icon(Icons.lightbulb_outline);
        message = 'Próba połączenia z serwerem';
        state = 'Brak danych';
        break;
      case AuthResult.ok:
        icon = Icon(
          Icons.lightbulb,
          color: Colors.green,
        );
        message = 'Wszystko gra';
        state = 'OK';
        break;
      case AuthResult.networkError:
        icon = Icon(
          Icons.lightbulb,
          color: Colors.red,
        );
        message = 'Serwer nie odpowiada';
        state = 'Błąd';
        break;
      case AuthResult.clientError:
        icon = Icon(
          Icons.lightbulb,
          color: Colors.red,
        );
        message = 'Nieprawidłowe dane logowania';
        state = 'Błąd';
        break;
    }
    return ListTile(
      leading: icon,
      isThreeLine: true,
      title: Text(state),
      subtitle: Text(message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = useState(0);
    final complete = useState(false);
    final hostController = useTextEditingController();
    final insecureTransfer = useState(false);
    final storeCredentials = useState(true);
    final userNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final verificationStatus = useState(AuthResult.none);
    final steps = <Step>[
      Step(
        title: const Text('Serwer'),
        state: currentStep.value == 0 ? StepState.editing : StepState.indexed,
        isActive: true,
        content: Column(
          children: <Widget>[
            TextFormField(
              controller: hostController,
              decoration: InputDecoration(
                labelText: 'Serwer',
                hintText: 'Nazwa serwera albo jego adres IP',
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            userPrefsSwitch(
              'Transfer bez SSL',
              insecureTransfer.value,
              (value) => insecureTransfer.value = value,
            ),
          ],
        ),
      ),
      Step(
        title: const Text('Login'),
        state: currentStep.value == 1 ? StepState.editing : StepState.indexed,
        isActive: true,
        content: Column(
          children: <Widget>[
            userPrefsSwitch(
              'Zapisuj dane logowania',
              storeCredentials.value,
              (value) => storeCredentials.value = value,
            ),
            TextFormField(
              controller: userNameController,
              decoration: InputDecoration(
                labelText: 'Nazwa',
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Hasło',
                contentPadding: EdgeInsets.all(10),
              ),
            )
          ],
        ),
      ),
      Step(
        title: const Text('Weryfikacja'),
        state: currentStep.value == 2 ? StepState.editing : StepState.indexed,
        isActive: true,
        content: Column(
          children: <Widget>[
            _verificationStatus(verificationStatus.value),
            ElevatedButton(
              child: Text('Sprawdź'),
              onPressed: () async {
                final svc = AuthenticationService(
                  hostController.text,
                  !insecureTransfer.value,
                  Credentials(
                    name: userNameController.text,
                    password: passwordController.text,
                  ),
                );
                verificationStatus.value = await svc.login();
              },
            )
          ],
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Ustawienia aplikacji'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stepper(
              steps: steps,
              currentStep: currentStep.value,
              onStepTapped: (value) => currentStep.value = value,
              onStepContinue: () async {
                if (currentStep.value < steps.length - 1) {
                  currentStep.value = currentStep.value + 1;
                } else {
                  final prefs = UserSettingsModel(
                    insecureTransfer.value,
                    storeCredentials.value,
                    hostController.text,
                    userNameController.text,
                    userNameController.text,
                    passwordController.text,
                  );
                  prefs.save();
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
              onStepCancel: () {
                if (currentStep.value != 0) {
                  currentStep.value = currentStep.value - 1;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
