import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Credentials extends Equatable {
  final String name;
  final String password;

  Credentials({
    @required String name,
    @required String password,
  })  : this.name = name,
        this.password = password,
        super();

  @override
  List<Object> get props => [name, password];

  bool get isValid => !['', null].contains(name) && password != null;

  Map<String, String> get loginData => {'name': name, 'password': password};
}

class AppPrefs extends Equatable {
  final String host;
  final bool storeCredentials;
  final bool insecureTransport;
  final String defaultAuthor;

  AppPrefs({
    @required String host,
    String defaultAuthor,
    bool storeCredentials = true,
    bool insecureTransport = false,
  })  : this.host = host,
        this.defaultAuthor = defaultAuthor,
        this.storeCredentials = storeCredentials,
        this.insecureTransport = insecureTransport,
        super();

  @override
  List<Object> get props =>
      [host, storeCredentials, insecureTransport, defaultAuthor];

  bool get isConfigured => !['', null].contains(host);
}
