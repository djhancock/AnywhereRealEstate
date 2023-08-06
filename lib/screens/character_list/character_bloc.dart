import 'dart:async';

import 'package:simpsons_demo/flavor.dart';
import 'package:simpsons_demo/model/character_model.dart';
import 'package:simpsons_demo/util/duck_duck_go_api_client.dart';
import 'package:simpsons_demo/widgets/filter_bar.dart';

class CharacterListState {
  final bool isLoading;
  final List<CharacterModel> simpsons;

  const CharacterListState._({
    required this.isLoading,
    required this.simpsons,
  });
}

abstract class CharacterListNavigator {
  void showCharacterDetials(CharacterModel simpsonsModel);
}

class CharacterListBloc {
  final DuckDuckGoApiClient _apiClient;
  final CharacterListNavigator _navigator;
  final _unfilteredList = <CharacterModel>[];

  final _streamController = StreamController<CharacterListState>();

  List<FilterCriteria<CharacterModel>> selectedFilters = [];
  SortCriteria<CharacterModel>? sortCriteria ; 
  String filterText = "";

  CharacterListBloc(this._apiClient, this._navigator);

  Stream<CharacterListState> get stream => _streamController.stream;

  Future<void> dispose() {
    return _streamController.close();
  }

  Future<void> load() async {
    final filteredCharacters = _doFilter();
    _streamController.add(CharacterListState._(isLoading: true, simpsons: filteredCharacters));
    
    List<CharacterModel>? simpsons;

    try {
      simpsons = await _apiClient.loadCharacters();
    }
    catch(e) {
      rethrow;
    }
    finally {
      simpsons ??= [];
      _unfilteredList.clear();
      _unfilteredList.addAll(simpsons);

      final filteredCharacters = _doFilter();
      _streamController.add(CharacterListState._(isLoading: false, simpsons: filteredCharacters));
    }
  }

  void itemSelected(CharacterModel simpsonsModel) {
    _navigator.showCharacterDetials(simpsonsModel);
  }

  void applyFilter(
    List<FilterCriteria<CharacterModel>> selectedFilters, 
    SortCriteria<CharacterModel>? sortCriteria, 
    String filterText,
  ) {
    this.selectedFilters = selectedFilters;
    this.sortCriteria = sortCriteria;
    this.filterText = filterText;

    final filteredCharacters = _doFilter();
    _streamController.add(CharacterListState._(isLoading: false, simpsons: filteredCharacters));
  }

  List<CharacterModel> _doFilter() {
    return _unfilteredList
            .where((item) => selectedFilters.every((element) => element.filter(item)))
            .where((item) {
              final lowerSearch = filterText.toLowerCase();
              return item.name.toLowerCase().contains(lowerSearch) ||
                      item.description.toLowerCase().contains(lowerSearch);
            })
            .toList()
            ..sort((a, b) => sortCriteria?.sort(a,b) ?? 0);
  
  }
} 