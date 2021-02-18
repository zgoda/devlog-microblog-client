import 'dart:convert';

import 'package:devlog_microblog_client/models/post.dart';
import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/utils/web.dart';
import 'package:devlog_microblog_client/viewmodels/userprefs.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final postServiceProvider = Provider<PostService>((ref) {
  final prefs = ref.watch(userPrefsProvider);
  final auth = ref.watch(authenticationServiceProvider);
  return PostService(prefs: prefs, auth: auth);
});

class PostService {
  final Uri _collectionUrl;
  final _http = http.Client();
  final bool _useHttps;
  final String _host;
  final AuthenticationService _auth;

  static const _collectionEndpoint = 'quips';
  static const _itemEndpoint = 'quip';

  PostService({@required AppPrefs prefs, @required AuthenticationService auth})
      : _host = prefs.host,
        _useHttps = !prefs.insecureTransport,
        _collectionUrl = buildServerUrl(
            prefs.host, buildEndpointPath(_collectionEndpoint),
            secure: !prefs.insecureTransport),
        _auth = auth,
        super();

  Uri _itemUrl(Post post) {
    final path =
        [buildEndpointPath(_itemEndpoint), post.pk.toString()].join('/');
    return buildServerUrl(_host, path, secure: _useHttps);
  }

  Future<List<Post>> fetchCollection({int page: 1}) async {
    final List<Post> posts = [];
    final url = _collectionUrl.replace(queryParameters: {'p': page.toString()});
    await _auth.login();
    final headers = _auth.authHeader();
    final resp = await _http.get(url, headers: headers);
    if (resp.statusCode == 200) {
      final respData = jsonDecode(resp.body);
      posts.addAll(
        respData['quips'].map<Post>((item) => Post.fromMap(item)).toList(),
      );
    }
    return posts;
  }

  Future<Post> addPost(Post post) async {
    final requestBody = jsonEncode(post.toMap());
    await _auth.login();
    final headers = _auth.authHeader();
    headers['Content-Type'] = 'application/json';
    final resp =
        await _http.post(_collectionUrl, headers: headers, body: requestBody);
    if (resp.statusCode < 300) {
      return Post.fromMap(jsonDecode(resp.body)['quip']);
    }
    return null;
  }

  Future<Post> updatePost(Post post) async {
    final url = _itemUrl(post);
    final requestBody = jsonEncode(post.toMap());
    await _auth.login();
    final headers = _auth.authHeader();
    headers['Content-Type'] = 'application/json';
    final resp = await _http.put(url, headers: headers, body: requestBody);
    if (resp.statusCode < 300) {
      return Post.fromMap(jsonDecode(resp.body)['quip']);
    }
    return null;
  }
}
