import 'dart:convert';

import 'package:devlog_microblog_client/utils/userprefs.dart';
import 'package:http/http.dart' as http;

class Post {
  String title;
  String text;
  DateTime date;
  int postId;

  Post({this.postId, this.title, this.text, this.date});
}

class PostListModel {
  UserSettingsModel _settings;
  final List<Post> posts = [];
  int _page = 1;
  String _token;
  String _apiRoot;

  void _init() async {
    if (_settings == null) {
      _settings = await UserSettingsModel.load();
    }
    final List<String> parts = [];
    if (_settings.unsecuredTransport) {
      parts.add('http:/');
    } else {
      parts.add('https:/');
    }
    parts.addAll([_settings.host, 'api/v1']);
    _apiRoot = parts.join('/');
  }

  Future<bool> tryLogin() async {
    _init();
    if (_settings.hasCredentials()) {
      _token = await login(_settings.username, _settings.password);
      if (_token != '') {
        return true;
      }
    }
    return false;
  }

  Future<String> login(String name, String password) async {
    _init();
    final url = [_apiRoot, 'login'].join('/');
    final data = {
      'name': name,
      'password': password,
    };
    final resp = await http.post(url, body: data);
    if (resp.statusCode == 200) {
      final Map<String, String> respData = jsonDecode(resp.body);
      return respData['token'];
    }
    return '';
  }

  void fetchPosts({int page = 1}) async {
    if ([null, ''].contains(_token)) {
      return;
    }
    _page = page;
    final url = [_apiRoot, 'quips?p=$_page'].join('/');
    final headers = {
      'Authorization': 'Basic $_token',
    };
    final resp = await http.get(url, headers: headers);
    if (resp.statusCode == 200) {
      final Map<String, List> respData = jsonDecode(resp.body);
      respData['quips'].map((item) {
        posts.add(Post(
          postId: item['pk'],
          title: item['title'],
          text: item['text'],
          date: item['created'],
        ));
      });
    }
  }
}
