/// Create full [Uri] that represents endpoint.
///
/// It defaults to be https but may be changed. Query parameters are optional.
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

/// Build endpoint path element.
String buildEndpointPath(String endpoint) {
  const API_ROOT = '/api/v1';
  return [API_ROOT, endpoint].join('/');
}
