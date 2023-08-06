import 'dart:convert';

import 'package:simpsons_demo/model/character_model.dart';
import 'package:simpsons_demo/util/uri_builder.dart';

abstract class CharacterConverter<X extends CharacterModel>
    extends Converter<Map<String, dynamic>, X> {
  final Uri rootImageUri;

  CharacterConverter(this.rootImageUri);

  @override
  X convert(Map<String, dynamic> input) {
    final iconMap = input['Icon'] as Map<String, dynamic>?;

    final icon = _processIcon(iconMap);

    final uri = Uri.parse(input['FirstURL']);
    final text = input['Text'] as String;
    final pieces = text.split(" - ");

    final String description;
    final String name;

    if (pieces.length == 1) {
      description = text;
      name = text;
    } else {
      description = pieces[1];
      name = pieces[0]
          .replaceFirst(
              RegExp("\\(The Simpsons( Character|)\\)", caseSensitive: false),
              "")
          .trim();
    }

    return _createObject(
      firstUrl: uri,
      icon: icon,
      name: name,
      description: description,
      jsonObject: input,
    );
  }

  CharacterIcon? _processIcon(Map<String, dynamic>? iconMap) {
    final iconUriStr = iconMap?['URL'] ?? "";

    if (iconUriStr.isNotEmpty) {
      var iconUri = Uri.tryParse(iconUriStr);
      if (iconUri != null) {
        final width = int.tryParse(iconMap?['Width'] ?? "");
        final height = int.tryParse(iconMap?['Height'] ?? "");

        if (!iconUri.isAbsolute) {
          iconUri = rootImageUri.buildUpon().addSubPath(iconUri).build();
        }

        return CharacterIcon(uri: iconUri, height: height, width: width);
      }
    }

    return null;
  }

  X _createObject(
      {required Uri firstUrl,
      required CharacterIcon? icon,
      required String description,
      required String name,
      required Map<String, dynamic> jsonObject});
}

class TheWireCharacterConverter extends CharacterConverter<TheWireModel> {
  TheWireCharacterConverter(super.rootImageUri);

  @override
  TheWireModel _createObject(
          {required Uri firstUrl,
          required CharacterIcon? icon,
          required String description,
          required String name,
          required Map<String, dynamic> jsonObject}) =>
      TheWireModel(
          firstUrl: firstUrl, icon: icon, description: description, name: name);
}

class TheSimpsonsCharacterConverter extends CharacterConverter<SimpsonsModel> {
  TheSimpsonsCharacterConverter(super.rootImageUri);

  @override
  SimpsonsModel _createObject(
      {required Uri firstUrl,
      required CharacterIcon? icon,
      required String description,
      required String name,
      required Map<String, dynamic> jsonObject}) {
    final isMinorCharacter = description.contains(
        "The Simpsons includes a large array of supporting/minor characters");
    final isFamilyMember = name.contains(" Simpson");

    return SimpsonsModel(
        firstUrl: firstUrl,
        icon: icon,
        description: description,
        name: name,
        isFamilyMember: isFamilyMember,
        isSideCharacter: isMinorCharacter);
  }
}
