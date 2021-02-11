import 'dart:convert';

import 'package:devlog_microblog_client/models/post.dart';
import 'package:devlog_microblog_client/models/userprefs.dart';
import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:devlog_microblog_client/utils/web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final postListProvider = StateNotifierProvider((ref) => PostListNotifier());

class PostListNotifier extends StateNotifier<List<Post>> {
  PostListNotifier() : super([]);

  void add(Post post) {
    state = [...state, post];
  }

  void addAll(List<Post> posts) {
    state = [...state, ...posts];
  }
}

final postCollectionServiceProvider = Provider<PostService>((ref) {
  final prefs = ref.watch(userPrefsProvider.state);
  final auth = ref.watch(authenticationServiceProvider);
  final service = PostService(prefs, auth);
  service.notifier = ref.read(postListProvider);
  return service;
});

class PostService {
  Uri _collectionUrl;
  var _currentPage = 1;
  final _http = http.Client();

  static const ENDPOINT = 'quips';

  AuthenticationService _auth;
  PostListNotifier _notifier;

  PostService(UserSettingsModel prefs, AuthenticationService auth) {
    _collectionUrl = buildServerUrl(
      prefs.host,
      buildEndpointPath(ENDPOINT),
      secure: !prefs.unsecuredTransport,
    );
    _auth = auth;
  }

  set notifier(PostListNotifier pln) => _notifier = pln;

  Future<int> fetchCollection({int page: 1}) async {
    final List<Post> posts = [];
    final url = _collectionUrl.replace(queryParameters: {'p': page.toString()});
    if (!_auth.hasToken()) {
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
      posts.addAll(
        respData['quips'].map<Post>((item) => Post.fromJson(item)).toList(),
      );
      _currentPage = page;
    }
    _notifier.addAll(posts);
    return _currentPage;
  }
}
