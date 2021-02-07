Uri buildServerUrl(String host, String path,
    {Map<String, dynamic> params, bool secure = true}) {
  if (params == null) {
    params = {};
  }
  if (secure) {
    return Uri.https(host, path, params);
  }
  return Uri.http(host, path, params);
}
