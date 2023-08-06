import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:simpsons_demo/util/rest_client.dart';

void main() {
  group('RestfulClient', () {
    late MockWebServer mockWebServer;
    late Uri rootUri;
    late HttpClient restfulClient;

    setUp(() async {
      mockWebServer = MockWebServer();
      await mockWebServer.start();
      rootUri = Uri.parse(mockWebServer.url);

      restfulClient = HttpClient();
    });

    tearDown(() async {
      await mockWebServer.shutdown();
    });

    test('restful request parameters are properly translated', () async {
      mockWebServer.enqueue(body: "A successful response".codeUnits,);

      final request = HttpRequest.get(
        rootUri, 
        <String,String>{
          "A":"1",
          "B":"C"
        }  
      );

      await restfulClient.execute(request).first;

      final takeRequest = mockWebServer.takeRequest();
      
      // NOTE: the takeRequest.url is relative to the server's root
      expect(rootUri.resolveUri(takeRequest.uri), request.uri);

      // NOTE: the httpClient will add its own headers. We 
      // just need to make sure ours are present.
      request.headers.forEach((key, value) {
        expect(takeRequest.headers[key.toLowerCase()], value);
      });

      expect(takeRequest.method, request.method);
    });

    
    test('raw response is streamed back to the user', () async {
      mockWebServer.enqueue(body: "A successful response",);

      final request = HttpRequest.get(rootUri);

      expect(restfulClient.execute(request), emits(predicate((p0) {
        return const Utf8Decoder().convert(p0 as List<int>) == "A successful response";
      })));
    });

    test('error messages are translated to exceptions', () async {
      mockWebServer.enqueue(body: "Test Error Message", httpCode: 300);

      final request = HttpRequest.get(rootUri);

      expect(restfulClient.execute(request), emitsError(predicate((p0) {
        return p0 is HttpException &&
                p0.code == 300 &&
                p0.message == "Test Error Message";
      })));
    });
  });
}