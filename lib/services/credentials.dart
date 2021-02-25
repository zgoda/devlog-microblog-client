import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialsService {
  final FlutterSecureStorage _storage;

  CredentialsService(FlutterSecureStorage storage)
      : this._storage = storage,
        super();

  static const _userNameKey = 'username';
  static const _passwordKey = 'password';

  Future<Credentials> get credentials async {
    final name = await _storage.read(key: _userNameKey);
    final password = await _storage.read(key: _passwordKey);
    return Credentials(name: name, password: password);
  }

  Future<void> saveCredentials(Credentials credentials) async {
    await _storage.write(key: _userNameKey, value: credentials.name);
    await _storage.write(key: _passwordKey, value: credentials.password);
  }
}
