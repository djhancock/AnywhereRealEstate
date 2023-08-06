import 'dart:convert';
import 'dart:io' as io;

class HttpRequest {
  final Uri uri;
  final String method;
  final Map<String,String> headers;
  final dynamic payload;

  HttpRequest._(this.uri, this.method, {
    Map<String,String>? headers,
    this.payload,
  })
  : headers = Map.from(headers ?? <String,String>{});

  HttpRequest.get(Uri uri, [ Map<String,String>? headers ])
    : this._(uri, "GET", headers: headers);
}

class HttpException implements Exception {
  final int code;
  final String message;

  HttpException({
    required this.code,
    required this.message,
  });
}

class HttpClient {
  HttpClient();

  io.HttpClient _buildClient() => io.HttpClient();

  Stream<List<int>> execute(HttpRequest restfulRequest) async* {
    final client = _buildClient();

    try {
      final request =  await client.openUrl(restfulRequest.method, restfulRequest.uri);
      restfulRequest.headers.forEach((key, value) {
        request.headers.add(key, value);
      });

      final response = await request.close();
      if(response.statusCode != 200) {
        final message = await response.transform(const Utf8Decoder()).first;
        throw HttpException(
          code: response.statusCode, 
          message: message,
        );
      }
      yield* response;
    }
    finally {
      client.close();
    }
  }
}