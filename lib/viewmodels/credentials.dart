import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/credentials.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final credentialsProvider = Provider<Credentials>((ref) {
  final credentials = ref.watch(credentialsViewModelProvider);
  return credentials;
});

final credentialsViewModelProvider =
    StateNotifierProvider<CredentialsNotifier, Credentials>(
        (ref) => CredentialsNotifier());

class CredentialsNotifier extends StateNotifier<Credentials> {
  CredentialsNotifier() : super(Credentials(name: '', password: ''));

  CredentialsService _service;

  Future<void> init(CredentialsService service) async {
    _service = service;
    state = await service.credentials;
  }

  Credentials get credentials => state;

  Future<void> updateCredentials(Credentials credentials) async {
    await _service.saveCredentials(credentials);
    state = credentials;
  }
}
