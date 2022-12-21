import 'dart:html' as html;

class LocalStorage {
  final html.Storage _localStorage = html.window.localStorage;

  Future save(String url) async {
    _localStorage['token'] = url;
  }

  Future<String?> getUrl() async => _localStorage['token'];

  Future invalidate() async {
    _localStorage.remove('token');
  }
}
