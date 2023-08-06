import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simpsons_demo/model/character_model.dart';

class TestRig extends StatelessWidget {
  final Widget child;

  const TestRig(this.child, { super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: child,
      ),
    );
  }
}

class CharacterIconMatcher extends Matcher {
  final CharacterIcon characterIcon;

  CharacterIconMatcher(this.characterIcon);

  @override
  Description describe(Description description) => description;

  @override
  bool matches(item, Map matchState) {
    final argIcon = item as CharacterIcon;
  
    matchState["HeightMatches"] = argIcon.height == characterIcon.height;
    matchState["WidthMatches"] = argIcon.width == characterIcon.width;
    matchState["UrlMatches"] = argIcon.uri == characterIcon.uri;

    return matchState["HeightMatches"] &&
            matchState["WidthMatches"] &&
            matchState["UrlMatches"];
  }

  @override
  Description describeMismatch(item, Description mismatchDescription, Map matchState, bool verbose) {
    final argIcon = item as CharacterIcon;
    if(!matchState["HeightMatches"]) {
      mismatchDescription
          .add('expected ${characterIcon.height} but received ${argIcon.height}}\n');
    }
    if(!matchState["WidthMatches"]) {
      mismatchDescription
          .add('expected ${characterIcon.width} but received ${argIcon.width}}\n');
    }
    if(!matchState["UrlMatches"]) {
      mismatchDescription
          .add('expected ${characterIcon.uri} but received ${argIcon.uri}}\n');
    }
    
    return mismatchDescription;
  }
}