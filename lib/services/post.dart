import 'dart:convert';

import 'package:devlog_microblog_client/models/post.dart';
import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/utils/web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

class PostService {
  Uri _collectionUrl;
  var _currentPage = 1;
  final _http = http.Client();
  bool _useHttps;
  String _host;

  static const _collectionEndpoint = 'quips';
  static const _itemEndpoint = 'quip';

  AuthenticationService _auth;
  PostListNotifier _notifier;

  PostService(UserPrefs prefs, AuthenticationService auth) {
    _host = prefs.host;
    _useHttps = !prefs.unsecuredTransport;
    _collectionUrl = buildServerUrl(
      _host,
      buildEndpointPath(_collectionEndpoint),
      secure: _useHttps,
    );
    _auth = auth;
  }

  set notifier(PostListNotifier pln) => _notifier = pln;

  Uri _itemUrl(Post post) {
    final path =
        [buildEndpointPath(_itemEndpoint), post.pk.toString()].join('/');
    return buildServerUrl(_host, path, secure: _useHttps);
  }

  Future<int> fetchCollection({int page: 1}) async {
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
      _currentPage = page;
    }
    if (posts != []) {
      _notifier.addAll(posts);
    }
    return _currentPage;
  }

  Future<void> addPost(Post post) async {
    final requestBody = jsonEncode(post.toMap());
    await _auth.login();
    final headers = _auth.authHeader();
    headers['Content-Type'] = 'application/json';
    final resp =
        await _http.post(_collectionUrl, headers: headers, body: requestBody);
    if (resp.statusCode < 300) {
      final newPost = Post.fromMap(jsonDecode(resp.body)['quip']);
      _notifier.add(newPost);
    }
  }

  Future<void> updatePost(Post post) async {
    final url = _itemUrl(post);
    final requestBody = jsonEncode(post.toMap());
    await _auth.login();
    final headers = _auth.authHeader();
    headers['Content-Type'] = 'application/json';
    final resp = await _http.put(url, headers: headers, body: requestBody);
    if (resp.statusCode < 300) {
      final newPost = Post.fromMap(jsonDecode(resp.body)['quip']);
      _notifier.update(newPost);
    }
  }
}
