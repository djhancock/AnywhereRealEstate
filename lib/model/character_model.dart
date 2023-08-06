class CharacterIcon {
  final int? height;
  final int? width;
  final Uri uri;

  CharacterIcon({
    required this.uri,
    required this.height,
    required this.width,
  });
}

class CharacterModel {
  final Uri firstUrl;
  final CharacterIcon? icon;
  final String description;
  final String name;

  CharacterModel({
    required this.firstUrl,
    required this.icon,
    required this.description,
    required this.name,
  });
}

class SimpsonsModel extends CharacterModel {
  final bool isSideCharacter;
  final bool isFamilyMember;

  SimpsonsModel({
    required super.firstUrl,
    required super.icon,
    required super.description,
    required super.name,
    required this.isSideCharacter,
    required this.isFamilyMember,
  });
}

class TheWireModel extends CharacterModel {
  TheWireModel({
    required super.firstUrl,
    required super.icon,
    required super.description,
    required super.name,
  });
}
