import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/viewmodels/credentials.dart';
import 'package:devlog_microblog_client/viewmodels/userprefs.dart';
import 'package:devlog_microblog_client/widgets/misc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VerificationStatus extends StatelessWidget {
  final AuthResult _status;

  VerificationStatus({Key key, @required AuthResult status})
      : _status = status,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon icon;
    String message;
    String state;
    final errorIcon = Icon(Icons.lightbulb, color: Colors.red);
    switch (_status) {
      case AuthResult.none:
        icon = Icon(Icons.lightbulb_outline);
        message = 'Próba połączenia z serwerem';
        state = 'Brak danych';
        break;
      case AuthResult.ok:
        icon = Icon(Icons.lightbulb, color: Colors.green);
        message = 'Wszystko gra';
        state = 'OK';
        break;
      case AuthResult.networkError:
        icon = errorIcon;
        message = 'Serwer nie odpowiada';
        state = 'Błąd';
        break;
      case AuthResult.clientError:
        icon = errorIcon;
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
}

class AppConfigWizard extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = useState(0);
    final hostController = useTextEditingController();
    final insecureTransfer = useState(false);
    final storeCredentials = useState(true);
    final userNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final verificationStatus = useState(AuthResult.none);
    final prefsNotifier = ref.watch(userPrefsViewModelProvider.notifier);
    final credentialsNotifier =
        ref.watch(credentialsViewModelProvider.notifier);
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
            UserPrefsSwitch(
              title: 'Transfer bez SSL',
              initialValue: insecureTransfer.value,
              onChanged: (value) => insecureTransfer.value = value,
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
            UserPrefsSwitch(
              title: 'Zapisuj dane logowania',
              initialValue: storeCredentials.value,
              onChanged: (value) => storeCredentials.value = value,
            ),
            TextFormField(
              controller: userNameController,
              decoration: InputDecoration(
                labelText: 'Nazwa',
                hintText: 'Nazwa konta użytkownika',
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Hasło',
                hintText: 'Hasło do konta użytkownika',
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
            VerificationStatus(
              status: verificationStatus.value,
            ),
            ElevatedButton(
              child: Text('Sprawdź'),
              onPressed: () async {
                final svc = AuthenticationService(
                  host: hostController.text,
                  secure: !insecureTransfer.value,
                  credentials: Credentials(
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
                  await prefsNotifier.updatePrefs(
                    AppPrefs(
                      insecureTransport: insecureTransfer.value,
                      storeCredentials: storeCredentials.value,
                      host: hostController.text,
                      defaultAuthor: userNameController.text,
                    ),
                  );
                  await credentialsNotifier.updateCredentials(
                    Credentials(
                      name: userNameController.text,
                      password: passwordController.text,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Aplikacja została skonfigurowana'),
                    ),
                  );
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
