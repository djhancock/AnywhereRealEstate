import 'package:simpsons_demo/model/character_model.dart';

abstract class DetailsBlocNavigator {
  void showDetails(CharacterModel model);
}

class DetailsBloc {
  final CharacterModel simpsonsModel;
  final DetailsBlocNavigator _blocNavigator;

  DetailsBloc(this.simpsonsModel, this._blocNavigator);

  void showMoreInfo() {
    _blocNavigator.showDetails(simpsonsModel);
  }
}