import 'dart:convert';

import 'package:devlog_microblog_client/models/posts.dart';
import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final postCollectionServiceProvider = Provider<PostCollectionService>((ref) {
  final settingsData = ref.watch(settingsProvider);
  final auth = ref.watch(authenticationServiceProvider);
  PostCollectionService service;
  settingsData
      .whenData((settings) => service = PostCollectionService(settings, auth));
  return service;
});

class PostCollectionService {
  String _collectionUrl;
  int _currentPage = 1;

  AuthenticationService _auth;

  PostCollectionService(
      UserSettingsModel settings, AuthenticationService auth) {
    _auth = auth;
    final List<String> parts = [];
    if (settings.unsecuredTransport) {
      parts.add('http:/');
    } else {
      parts.add('https:/');
    }
    parts.addAll([settings.host, 'api/v1']);
    final root = parts.join('/');
    _collectionUrl = root + '/quips';
  }

  Future<List<Post>> fetchCollection({int page: 1}) async {
    _currentPage = page;
    final url = '$_collectionUrl?p=$_currentPage';
    if (!_auth.isLoggedIn()) {
      await _auth.login();
    }
    Map<String, String> headers = _auth.authHeader();
    http.Response resp = await http.get(url, headers: headers);
    if (resp.statusCode == 400) {
      await _auth.login();
      headers = _auth.authHeader();
      resp = await http.get(url, headers: headers);
    }
    if (resp.statusCode == 200) {
      final Map<String, dynamic> respData = jsonDecode(resp.body);
      final posts =
          respData['quips'].map<Post>((item) => Post.fromJson(item)).toList();
      return posts;
    }
    return [];
  }
}
