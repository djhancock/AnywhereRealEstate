import 'package:simpsons_demo/model/character_model.dart';
import 'package:simpsons_demo/util/converters.dart';
import 'package:simpsons_demo/util/rest_client.dart';
import 'package:simpsons_demo/util/uri_builder.dart';import 'dart:async';
import 'dart:convert';


final duckDuckGoApiUri = Uri.parse("http://api.duckduckgo.com");
final duckDuckGoRootUri = Uri.parse("http://www.duckduckgo.com");

/*
{
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
  "RelatedTopics":[],
  "Results":[ ],
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
}
*/

abstract class DuckDuckGoApiClient {
  final HttpClient _client;

  DuckDuckGoApiClient._(this._client);


  Future<List<CharacterModel>> loadCharacters();

  Future<List<X>> _doLoadCharacters<X extends CharacterModel>(String characterType, CharacterConverter<X> converter) async {
    // request format = http://api.duckduckgo.com/?q=simpsons+characters&format=json
    final uri = duckDuckGoApiUri.buildUpon()
      .addQueryParameter("q", characterType)
      .addQueryParameter("format", "json")
      .build();
    
    final request = HttpRequest.get(uri);
    final parser = CharacterParser<X>(converter);

    return _client.execute(request)
            .transform(parser)
            .first;
  }
}

class DuckDuckGoSimpsonsClient extends DuckDuckGoApiClient {
  DuckDuckGoSimpsonsClient(HttpClient client) : super._(client);

  @override
  Future<List<SimpsonsModel>> loadCharacters() => _doLoadCharacters("simpsons characters", TheSimpsonsCharacterConverter(duckDuckGoRootUri));
}

class DuckDuckGoTheWireClient extends DuckDuckGoApiClient {
  DuckDuckGoTheWireClient(HttpClient client) : super._(client);

  @override
  Future<List<TheWireModel>> loadCharacters() => _doLoadCharacters("the wire characters", TheWireCharacterConverter(duckDuckGoRootUri));
}

class CharacterParser<X 
  extends CharacterModel> 
  extends StreamTransformerBase<List<int>, List<X>> 
{
  final CharacterConverter<X> _converter;

  CharacterParser(this._converter);

  @override
  Stream<List<X>> bind(Stream<List<int>> stream) {
    return const Utf8Decoder()
      .fuse(const JsonDecoder())
      .bind(stream)
      .transform(StreamTransformer.fromHandlers(
        handleData: (data, sink) {                            
          final dict = data as Map<String,dynamic>;
          final results = (dict['RelatedTopics'] ?? []) as List<dynamic>;

          final characters = results.map((jsonObj) {
            return _converter.convert(jsonObj);
          });

          sink.add(characters.toList());
        },
      ));
  }
}
