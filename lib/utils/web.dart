const API_ROOT = '/api/v1';

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

String buildEndpointPath(String endpoint) {
  return [API_ROOT, endpoint].join('/');
}
