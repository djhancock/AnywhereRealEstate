import 'dart:async';

import 'package:simpsons_demo/model/character_model.dart';
import 'package:simpsons_demo/util/duck_duck_go_api_client.dart';

class LandingBlocState {
  final bool isLoading;
  final List<CharacterModel> simpsons;

  const LandingBlocState._({
    required this.isLoading,
    required this.simpsons,
  });
}

class LandingBloc {
  final DuckDuckGoApiClient _apiClient;
  final _streamController = StreamController<LandingBlocState>();

  LandingBloc(this._apiClient);

  Stream<LandingBlocState> get stream => _streamController.stream;

  Future<void> dispose() {
    return _streamController.close();
  }

  Future<void> load() async {
    _streamController.add(const LandingBlocState._(isLoading: true, simpsons: []));
    
    List<CharacterModel>? simpsons;

    try {
      simpsons = await _apiClient.loadCharacters();
    }
    catch(e) {
      print("Loading error ${e.toString()}");
      rethrow;
    }
    finally {
    _streamController.add(LandingBlocState._(isLoading: false, simpsons: simpsons ?? []));
    }
  }
} 