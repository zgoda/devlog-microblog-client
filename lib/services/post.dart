import 'dart:convert';

import 'package:devlog_microblog_client/models/posts.dart';
import 'package:devlog_microblog_client/servicelocator.dart';
import 'package:devlog_microblog_client/services/auth.dart';
import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:http/http.dart' as http;

class PostCollectionService {
  String _collectionUrl;
  int _currentPage = 1;

  PostCollectionService() {
    final List<String> parts = [];
    locator.allReady().whenComplete(() {
      final settings = locator<LocalStorageService>().settings;
      if (settings.unsecuredTransport) {
        parts.add('http:/');
      } else {
        parts.add('https:/');
      }
      parts.addAll([settings.host, 'api/v1']);
      final root = parts.join('/');
      _collectionUrl = root + '/quips';
    });
  }

  Future<List<Post>> fetchCollection({int page: 1}) async {
    await locator.allReady();
    final auth = locator<AuthenticationService>();
    if (!auth.isLoggedIn()) {
      await auth.login();
    }
    _currentPage = page;
    final url = '$_collectionUrl?p=$_currentPage';
    Map<String, String> headers = auth.authHeader();
    http.Response resp = await http.get(url, headers: headers);
    if (resp.statusCode == 400) {
      await auth.login();
      headers = auth.authHeader();
      resp = await http.get(url, headers: headers);
    }
    if (resp.statusCode == 200) {
      final Map<String, dynamic> respData = jsonDecode(resp.body);
      List<Post> posts = [];
      respData['quips'].map((item) => posts.add(Post.fromJson(item)));
      return posts;
    }
    return [];
  }
}
