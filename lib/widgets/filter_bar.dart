import 'package:flutter/material.dart';

class FilterCriteria<X> {
  final String label;
  final bool Function(X item) filter;

  FilterCriteria({
    required this.filter,
    required this.label
  });

  @override
  int get hashCode => Object.hash(filter, label);
  
  @override
  bool operator ==(Object other) {
    return other is FilterCriteria<X> &&
            other.label == label;
  }
}

class SortCriteria<X> {
  final IconData icon;
  final String label;
  final int Function(X item1, X item2) sort;

  SortCriteria({
    required this.sort,
    required this.label,
    required this.icon
  });

  @override
  int get hashCode => Object.hash(icon, label);
  
  @override
  bool operator ==(Object other) {
    return other is SortCriteria<X> &&
            other.label == label &&
            other.icon == icon;
  }
}

typedef OnFilterBarAction<X> = Function(
    List<FilterCriteria<X>> selectedFilters, 
    SortCriteria<X>? sortCriteria, 
    String filterText,  
);

class FilterBar<X> extends StatefulWidget {
  final List<FilterCriteria<X>> filters;
  final List<SortCriteria<X>> sort;
  final OnFilterBarAction<X> filterDelegate;

  const FilterBar({
    super.key,
    required this.filters,
    required this.sort,
    required this.filterDelegate,
  });

  @override
  State<FilterBar<X>> createState() => FilterBartState<X>();
}

class FilterBartState<X> extends State<FilterBar<X>> {
  final _selectedFilters = <FilterCriteria<X>>[];
  final _searchTestController = TextEditingController();
  SortCriteria<X>? _selectedSort;

  @override
  void dispose() {
    _searchTestController.removeListener(_applyFilter);
    _searchTestController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(covariant FilterBar<X> oldWidget) {
    super.didUpdateWidget(oldWidget);
  
    // remove filters that are no longer in the new list
    _selectedFilters.removeWhere((filter) => !widget.filters.contains(filter));
    if(_selectedSort != null && !widget.sort.contains(_selectedSort)) {
      _selectedSort = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                _applyFilter();
              },
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isDense: true,
                isCollapsed: true,
                contentPadding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(
                    color: Colors.red,
                  )
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchTestController.clear();
                    _applyFilter();
                  },
                )
              ),
              controller: _searchTestController,
              enableSuggestions: false,
            ),
          ),
          
          PopupMenuButton<FilterCriteria<X>>(
            icon: const Icon(Icons.filter_alt,),
            itemBuilder: (context) => widget.filters.map((filter) {
              return PopupMenuItem<FilterCriteria<X>>(
                value: filter,
                child: Row(
                  children: [
                    StatefulBuilder(
                      builder: (context, setState) => Checkbox(
                        value: _selectedFilters.contains(filter), 
                        onChanged: (value) {
                          if(value == null) {
                            return;
                          }

                          if(_selectedFilters.contains(filter)) {
                            _selectedFilters.remove(filter);
                          } else {
                            _selectedFilters.add(filter);
                          }
                          
                          _applyFilter();
                      },),
                    ),                          
                    Text(filter.label)
                  ],
                )
              );
            }).toList(),
          ),
          PopupMenuButton<SortCriteria<X>>(
            icon: const Icon(Icons.sort,),
            itemBuilder: (context) {
              return widget.sort.map((sort) {
              return PopupMenuItem(
                value: sort,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(sort.icon),
                    Text(sort.label),
                  ],
                )
              );
            }).toList();
            },
            onSelected: (value) {
              _selectedSort = value;
              _applyFilter();
            },
          )
        ],
      ),
    );
  }

  void _applyFilter() {
    if(!mounted) {
      return;
    }
    
    widget.filterDelegate(
      List.from(_selectedFilters),
      _selectedSort,
      _searchTestController.text,
    );
  }
}