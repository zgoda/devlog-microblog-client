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
  static const _contentType = 'application/json';
  static const _contentTypeHeaderKey = 'Content-Type';

  PostService({@required AppPrefs prefs, @required AuthenticationService auth})
      : _host = prefs.host,
        _useHttps = !prefs.insecureTransport,
        _collectionUrl = buildServerUrl(
          prefs.host,
          buildEndpointPath(_collectionEndpoint),
          secure: !prefs.insecureTransport,
        ),
        _auth = auth,
        super();

  Uri _itemUrl(Post post) {
    final path =
        [buildEndpointPath(_itemEndpoint), post.pk.toString()].join('/');
    return buildServerUrl(_host, path, secure: _useHttps);
  }

  Map<String, String> _headers() {
    final headers = _auth.authHeader();
    headers[_contentTypeHeaderKey] = _contentType;
    return headers;
  }

  Future<List<Post>> fetchCollection({int page: 1}) async {
    final List<Post> posts = [];
    final url = _collectionUrl.replace(queryParameters: {'p': page.toString()});
    await _auth.login();
    try {
      final resp = await _http.get(url, headers: _headers());
      if (resp.statusCode == 200) {
        final respData = jsonDecode(resp.body);
        posts.addAll(
          respData['quips'].map<Post>((item) => Post.fromMap(item)).toList(),
        );
      }
    } catch (err) {
      print('Err on post list load: $err');
    }
    return posts;
  }

  Future<Post> addPost(Post post) async {
    final requestBody = jsonEncode(post.toMap());
    await _auth.login();
    final resp = await _http.post(
      _collectionUrl,
      headers: _headers(),
      body: requestBody,
    );
    if (resp.statusCode < 300) {
      return Post.fromMap(jsonDecode(resp.body)['quip']);
    }
    return null;
  }

  Future<Post> updatePost(Post post) async {
    final url = _itemUrl(post);
    final requestBody = jsonEncode(post.toMap());
    await _auth.login();
    final resp = await _http.put(url, headers: _headers(), body: requestBody);
    if (resp.statusCode < 300) {
      return Post.fromMap(jsonDecode(resp.body)['quip']);
    }
    return null;
  }
}
