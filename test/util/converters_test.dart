import 'package:flutter_test/flutter_test.dart';
import 'package:simpsons_demo/model/character_model.dart';
import 'package:simpsons_demo/util/converters.dart';

import '../helper.dart';

final testRoot = Uri.parse("http://test.com");

void main() {
  group("TheWireCharacterConverter", () {
    final jsonObject = <String,dynamic>{
      "FirstURL":"https://duckduckgo.com/Bubbles_(The_Wire)",
      "Icon":{
        "Height":"100",
        "URL":"/i/521af1f0.jpg",
        "Width":""
      },
      "Result":"<a href=\"https://duckduckgo.com/Bubbles_(The_Wire)\">Bubbles (The Wire)</a><br>Reginald \"Bubbles\" Cousins is a fictional character on the HBO drama The Wire, played by actor Andre Royo. Bubbles is a recovering heroin addict. His real name is not revealed until a fourth-season episode when he is called \"Mr. Cousins\" and in the fifth-season premiere when he is called \"Reginald\".",
      "Text":"Bubbles (The Wire) - Reginald \"Bubbles\" Cousins is a fictional character on the HBO drama The Wire, played by actor Andre Royo. Bubbles is a recovering heroin addict. His real name is not revealed until a fourth-season episode when he is called \"Mr. Cousins\" and in the fifth-season premiere when he is called \"Reginald\"."
    };

    late TheWireCharacterConverter converter;

    setUp(() {
      converter = TheWireCharacterConverter(testRoot);
    });
    
    test('The character properties are properly parsed', () {
      final character = converter.convert(jsonObject);


      expect(character.firstUrl, Uri.parse("https://duckduckgo.com/Bubbles_(The_Wire)"));
      expect(character.icon, CharacterIconMatcher(CharacterIcon(uri: Uri.parse("http://test.com/i/521af1f0.jpg"), height: 100, width: null)));
      expect(character.name, "Bubbles (The Wire)");
      expect(character.description, "Reginald \"Bubbles\" Cousins is a fictional character on the HBO drama The Wire, played by actor Andre Royo. Bubbles is a recovering heroin addict. His real name is not revealed until a fourth-season episode when he is called \"Mr. Cousins\" and in the fifth-season premiere when he is called \"Reginald\".");
    });

    test('null icons are properly hanbdled', () {
      final copy = Map<String,dynamic>.from(jsonObject);
      copy["Icon"]["URL"] = "";
      final character1 = converter.convert(copy);
      expect(character1.icon, null);

      copy["Icon"] = null;
      
      final character2 = converter.convert(copy);
      expect(character2.icon, null);
     });
  });

  group("TheSimpsonsCharacterConverter", () {
    final jsonObject = <String,dynamic>{     
      "FirstURL":"https://duckduckgo.com/Barney_Gumble",
      "Icon":{
        "Height":"",
        "URL":"/i/39ce98c0.png",
        "Width":""
      },
      "Result":"<a href=\"https://duckduckgo.com/Barney_Gumble\">Barney Gumble</a><br>Barnard Arnold \"Barney\" Gumble is a recurring character in the American animated TV series The Simpsons. He is voiced by Dan Castellaneta and first appeared in the series premiere episode \"Simpsons Roasting on an Open Fire\". Barney is the town drunk of Springfield and one of Homer Simpson's friends.",
      "Text":"Barney Gumble - Barnard Arnold \"Barney\" Gumble is a recurring character in the American animated TV series The Simpsons. He is voiced by Dan Castellaneta and first appeared in the series premiere episode \"Simpsons Roasting on an Open Fire\". Barney is the town drunk of Springfield and one of Homer Simpson's friends."
    };

    late TheSimpsonsCharacterConverter converter;

    setUp(() {
      converter = TheSimpsonsCharacterConverter(testRoot);
    });
    
    test('The character properties are properly parsed', () {
      final character = converter.convert(jsonObject);

      expect(character.firstUrl, Uri.parse("https://duckduckgo.com/Barney_Gumble"));
      expect(character.icon, CharacterIconMatcher(CharacterIcon(uri: Uri.parse("http://test.com/i/39ce98c0.png"), height: null, width: null)));
      expect(character.name, "Barney Gumble");
      expect(character.description, "Barnard Arnold \"Barney\" Gumble is a recurring character in the American animated TV series The Simpsons. He is voiced by Dan Castellaneta and first appeared in the series premiere episode \"Simpsons Roasting on an Open Fire\". Barney is the town drunk of Springfield and one of Homer Simpson's friends.");
      expect(character.isFamilyMember, false);
      expect(character.isSideCharacter, false);
    });

    test('null icons are properly hanbdled', () {
      final copy = Map<String,dynamic>.from(jsonObject);
      copy["Icon"]["URL"] = "";

      final character1 = converter.convert(copy);
      expect(character1.icon, null);

      copy["Icon"] = null;
      
      final character2 = converter.convert(copy);
      expect(character2.icon, null);
     });

     test('isFamilyMember is properly Parsed', () async {
      final copy = Map<String,dynamic>.from(jsonObject);

      var character1 = converter.convert(copy);
      expect(character1.isFamilyMember, false);

      copy['Text'] = (copy['Text'] as String).replaceFirst("Barney Gumble", "Barney Simpson");
      character1 = converter.convert(copy);
      expect(character1.isFamilyMember, true);
     });  

     test('isSideCharacter is properly Parsed', () async {
      final copy = Map<String,dynamic>.from(jsonObject);

      var character1 = converter.convert(copy);
      expect(character1.isSideCharacter, false);

      copy['Text'] = "${(copy['Text'] as String)} The Simpsons includes a large array of supporting/minor characters";
      character1 = converter.convert(copy);
      expect(character1.isSideCharacter, true);
     });  
  });
}