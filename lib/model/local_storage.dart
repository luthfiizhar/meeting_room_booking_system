import 'dart:html' as html;

class LocalStorage {
  final html.Storage _localStorage = html.window.localStorage;

  Future save(String url) async {
    _localStorage['url'] = url;
  }

  Future<String?> getUrl() async => _localStorage['url'];

  Future invalidate() async {
    _localStorage.remove('url');
  }
}
