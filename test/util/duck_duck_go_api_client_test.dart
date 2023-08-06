import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simpsons_demo/util/duck_duck_go_api_client.dart';
import 'package:simpsons_demo/util/rest_client.dart';

import 'duck_duck_go_api_client_test.mocks.dart';

String buildDuckDuckGoObject(List<Map<String, dynamic>> relatedTopics) {
  return """{
        "RelatedTopics": ${jsonEncode(relatedTopics)},
        "Abstract":"",
        "AbstractSource":"Wikipedia",
        "AbstractText":"",
        "AbstractURL":"https://en.wikipedia.org/wiki/The_Simpsons_characters",
        "Answer":"",
        "AnswerType":"",
        "Definition":"",
        "DefinitionSource":"",
        "DefinitionURL":"",
        "Entity":"",
        "Heading":"The Simpsons characters",
        "Image":"",
        "ImageHeight":0,
        "ImageIsLogo":0,
        "ImageWidth":0,
        "Infobox":"",
        "Redirect":"",
        "Type":"C",
        "meta":{
          "attribution":null,
          "blockgroup":null,
          "created_date":null,
          "description":"Wikipedia",
          "designer":null,
          "dev_date":null,
          "dev_milestone":"live",
          "developer":[
            {
              "name":"DDG Team",
              "type":"ddg",
              "url":"http://www.duckduckhack.com"
            }
          ],
          "example_query":"nikola tesla",
          "id":"wikipedia_fathead",
          "is_stackexchange":null,
          "js_callback_name":"wikipedia",
          "live_date":null,
          "maintainer":{
            "github":"duckduckgo"
          },
          "name":"Wikipedia",
          "perl_module":"DDG::Fathead::Wikipedia",
          "producer":null,
          "production_state":"online",
          "repo":"fathead",
          "signal_from":"wikipedia_fathead",
          "src_domain":"en.wikipedia.org",
          "src_id":1,
          "src_name":"Wikipedia",
          "src_options":{
            "directory":"",
            "is_fanon":0,
            "is_mediawiki":1,
            "is_wikipedia":1,
            "language":"en",
            "min_abstract_length":"20",
            "skip_abstract":0,
            "skip_abstract_paren":0,
            "skip_end":"0",
            "skip_icon":0,
            "skip_image_name":0,
            "skip_qr":"",
            "source_skip":"",
            "src_info":""
          },
        "src_url":null,
        "status":"live",
        "tab":"About",
        "topic":[
          "productivity"
        ],
        "unsafe":0
      }
    }""";
}

@GenerateMocks([HttpClient])
void main() {
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
  });

  group('DuckDuckGoSimpsonsClient', () {
    late DuckDuckGoSimpsonsClient apiClient;

    setUp(() {
      apiClient = DuckDuckGoSimpsonsClient(mockHttpClient);
    });

    test('successful response', () async {
      final jsonObj = {
        "FirstURL": "https://duckduckgo.com/Apu_Nahasapeemapetilan",
        "Icon": {"Height": "", "URL": "/1/2", "Width": ""},
        "Result":
            "<a href=\"https://duckduckgo.com/Apu_Nahasapeemapetilan\">Apu Nahasapeemapetilan</a><br>Apu Nahasapeemapetilan is a recurring character in the American animated television series The Simpsons. He is an Indian immigrant proprietor who runs the Kwik-E-Mart, a popular convenience store in Springfield, and is known for his catchphrase, \"Thank you, come again\".",
        "Text":
            "Apu Nahasapeemapetilan - Apu Nahasapeemapetilan is a recurring character in the American animated television series The Simpsons. He is an Indian immigrant proprietor who runs the Kwik-E-Mart, a popular convenience store in Springfield, and is known for his catchphrase, \"Thank you, come again\"."
      };

      final successResponse = buildDuckDuckGoObject([jsonObj]);

      when(mockHttpClient.execute(any))
          .thenAnswer((_) => Stream.value(successResponse.codeUnits));

      final models = await apiClient.loadCharacters();
      expect(models.length, 1);
    });

    test("request parameters", () async {
      when(mockHttpClient.execute(any))
          .thenAnswer((_) => Stream.value("{}".codeUnits));

      await apiClient.loadCharacters();
      verify(mockHttpClient.execute(argThat(predicate((p0) {
        final restfulRequest = p0 as HttpRequest;
        expect(restfulRequest.uri,
            duckDuckGoApiUri.resolve("?q=simpsons+characters&format=json"));
        expect(restfulRequest.method, "GET");
        return true;
      }))));
    });
  });

  group('DuckDuckGoTheWireClient', () {
    late DuckDuckGoTheWireClient apiClient;

    setUp(() {
      apiClient = DuckDuckGoTheWireClient(mockHttpClient);
    });

    test('successful response', () async {
      final jsonObj = {
        "FirstURL": "https://duckduckgo.com/Apu_Nahasapeemapetilan",
        "Icon": {"Height": "", "URL": "/1/2", "Width": ""},
        "Result":
            "<a href=\"https://duckduckgo.com/Apu_Nahasapeemapetilan\">Apu Nahasapeemapetilan</a><br>Apu Nahasapeemapetilan is a recurring character in the American animated television series The Simpsons. He is an Indian immigrant proprietor who runs the Kwik-E-Mart, a popular convenience store in Springfield, and is known for his catchphrase, \"Thank you, come again\".",
        "Text":
            "Apu Nahasapeemapetilan - Apu Nahasapeemapetilan is a recurring character in the American animated television series The Simpsons. He is an Indian immigrant proprietor who runs the Kwik-E-Mart, a popular convenience store in Springfield, and is known for his catchphrase, \"Thank you, come again\"."
      };

      final successResponse = buildDuckDuckGoObject([jsonObj]);

      when(mockHttpClient.execute(any))
          .thenAnswer((_) => Stream.value(successResponse.codeUnits));

      final models = await apiClient.loadCharacters();
      expect(models.length, 1);
    });

    test("request parameters", () async {
      when(mockHttpClient.execute(any))
          .thenAnswer((_) => Stream.value("{}".codeUnits));

      await apiClient.loadCharacters();
      verify(mockHttpClient.execute(argThat(predicate((p0) {
        final restfulRequest = p0 as HttpRequest;
        expect(restfulRequest.uri,
            duckDuckGoApiUri.resolve("?q=the+wire+characters&format=json"));
        expect(restfulRequest.method, "GET");
        return true;
      }))));
    });
  });
}
