class UriBuilder {
  final String _scheme;
  final String _host;
  final List<String> _path;
  final Map<String,String> _queryParameters;

  UriBuilder(Uri uri) 
    : _scheme = uri.scheme,
      _host = uri.host,
      _path = List.from(uri.pathSegments),
      _queryParameters = Map.from(uri.queryParameters);

  UriBuilder addSubPath(Uri uri) {
    _path.addAll(uri.pathSegments);
    _queryParameters.addAll(uri.queryParameters);
    return this;
  }

  UriBuilder addPathSegment(String segment) {
    _path.add(segment);
    return this;
  }

  UriBuilder addPathSegments(List<String> segments) {
    _path.addAll(segments);
    return this;
  }

  UriBuilder addQueryParameter(String key, String value) {
    _queryParameters[key] = value;
    return this;
  }
  
  Uri build() {
    return Uri(
      scheme: _scheme,
      host: _host,
      pathSegments: _path,
      queryParameters: (_queryParameters.isNotEmpty)? _queryParameters : null,
    );
  }
}

extension UriBuilderHelper on Uri {
  UriBuilder buildUpon() => UriBuilder(this);
}