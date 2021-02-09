import 'dart:convert';

import 'package:devlog_microblog_client/models/post.dart';
import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/utils/web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final postCollectionServiceProvider =
    Provider<PostService>((ref) => PostService.getInstance());

class PostService {
  static PostService _instance;
  Uri _collectionUrl;
  var _currentPage = 1;
  final _http = http.Client();

  AuthenticationService _auth;

  static PostService getInstance() {
    if (_instance == null) {
      _instance = PostService();
    }
    return _instance;
  }

  void init(UserSettingsModel prefs, AuthenticationService auth) {
    _collectionUrl = buildServerUrl(
      prefs.host,
      '/api/v1/quips',
      secure: !prefs.unsecuredTransport,
    );
    _auth = auth;
  }

  Future<List<Post>> fetchCollection({int page: 1}) async {
    _currentPage = page;
    final url =
        _collectionUrl.replace(queryParameters: {'p': _currentPage.toString()});
    if (!_auth.isLoggedIn()) {
      await _auth.login();
    }
    Map<String, String> headers = _auth.authHeader();
    http.Response resp = await _http.get(url, headers: headers);
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
