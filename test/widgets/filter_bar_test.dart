import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simpsons_demo/widgets/filter_bar.dart';

import '../helper.dart';

class TestItem {
  final int index;

  TestItem(this.index);

  String get label => "Item $index";
}

final testItem1 = TestItem(1);
final testItem2 = TestItem(2);

final filterCriteria1 = FilterCriteria<TestItem>(
  filter: (item) => item.index.isOdd, 
  label: "Even",
);
final filterCriteria2 = FilterCriteria<TestItem>(
  filter: (item) => item.index.isEven, 
  label: "Odd",
);

final sortCriteria1 = SortCriteria<TestItem>(
  sort: (item1, item2) => item1.index.compareTo(item2.index), 
  label: "Ascending", 
  icon: Icons.arrow_upward,
);
final sortCriteria2 = SortCriteria<TestItem>(
  sort: (item1, item2) => item2.index.compareTo(item1.index), 
  label: "Descending", 
  icon: Icons.arrow_downward,
);

class FilterActionDelegate {
  final appliedFilters = <List<FilterCriteria<TestItem>>>[];
  final appliedSort = <SortCriteria<TestItem>?>[];
  final appliedText = <String>[];

  void applyFilter( 
    List<FilterCriteria<TestItem>> selectedFilters, 
    SortCriteria<TestItem>? sortCriteria, 
    String filterText,  
  ) { 
    appliedFilters.add(selectedFilters);
    appliedSort.add(sortCriteria);
    appliedText.add(filterText);
  }
}
void main() {
  Future<void> _build(
    WidgetTester tester, 
    List<FilterCriteria<TestItem>> filters,
    List<SortCriteria<TestItem>> sortItems,
    OnFilterBarAction<TestItem> onFilterAction,
  ) async {
    await tester.pumpWidget(
      TestRig(
        FilterBar<TestItem>(
          filters: filters,
          sort: sortItems,
          filterDelegate: onFilterAction,
        )
      )
    );
  }

  testWidgets("text field changes trigger the callback", (widgetTester) async {
    final applyDelegate = FilterActionDelegate();

    await _build(
      widgetTester, 
      [  ],
      [  ],
      applyDelegate.applyFilter
    );

    final textFind = find.byType(TextField);
    await widgetTester.enterText(textFind, "Some Search String");

    final iconFind = find.byIcon(Icons.clear);
    await widgetTester.tap(iconFind);

    expect(applyDelegate.appliedFilters, [[], []]);
    expect(applyDelegate.appliedSort, [null, null]);
    expect(applyDelegate.appliedText, ["Some Search String", ""]);
  });

  testWidgets('Filter button reflects the filter criteria', (widgetTester) async {
    final applyDelegate = FilterActionDelegate();

    await _build(
      widgetTester, 
      [ filterCriteria1, filterCriteria2 ],
      [  ],
      applyDelegate.applyFilter
    );

    final filterFind = find.byWidgetPredicate((widget) => widget is PopupMenuButton<FilterCriteria<TestItem>>);
    await widgetTester.tap(filterFind).then((_) => widgetTester.pumpAndSettle(const Duration(seconds: 1)));
    expect(filterFind, findsOneWidget);

    final menuItemFind = find.byType(PopupMenuItem<FilterCriteria<TestItem>>);
    expect(menuItemFind, findsNWidgets(2));

    expect(find.descendant(of: menuItemFind, matching: find.text(filterCriteria1.label)), findsOneWidget);
    expect(find.descendant(of: menuItemFind, matching: find.text(filterCriteria2.label)), findsOneWidget);
    expect(find.descendant(of: menuItemFind, matching: find.byType(Checkbox)), findsNWidgets(2));
  });

  testWidgets('Filter items reflect the selected state', (widgetTester) async {
    final applyDelegate = FilterActionDelegate();

    await _build(
      widgetTester, 
      [ filterCriteria1, filterCriteria2 ],
      [  ],
      applyDelegate.applyFilter
    );

    final filterFind = find.byWidgetPredicate((widget) => widget is PopupMenuButton<FilterCriteria<TestItem>>);
    await widgetTester.tap(filterFind).then((_) => widgetTester.pumpAndSettle(const Duration(seconds: 1)));

    final menuItemFind = find.byType(PopupMenuItem<FilterCriteria<TestItem>>);
    final checkboxFind = find.descendant(of: menuItemFind, matching: find.byType(Checkbox));

    await widgetTester.tap(checkboxFind.at(1));
    await widgetTester.tap(checkboxFind.at(0));
    await widgetTester.tap(checkboxFind.at(1));

    expect(applyDelegate.appliedFilters, [ 
      [ filterCriteria2 ], 
      [ filterCriteria2, filterCriteria1 ], 
      [ filterCriteria1 ]]
    );
    expect(applyDelegate.appliedSort, [null, null, null]);
    expect(applyDelegate.appliedText, ["", "", ""]);
  });

  testWidgets('Sort button reflects the sort criteria', (widgetTester) async {
    final applyDelegate = FilterActionDelegate();

    await _build(
      widgetTester, 
      [  ],
      [ sortCriteria1, sortCriteria2 ],
      applyDelegate.applyFilter
    );

    final filterFind = find.byWidgetPredicate((widget) => widget is PopupMenuButton<SortCriteria<TestItem>>);
    await widgetTester.tap(filterFind).then((_) => widgetTester.pumpAndSettle(const Duration(seconds: 1)));
    expect(filterFind, findsOneWidget);

    final menuItemFind = find.byType(PopupMenuItem<SortCriteria<TestItem>>);
    expect(menuItemFind, findsNWidgets(2));

    expect(find.descendant(of: menuItemFind, matching: find.text(sortCriteria1.label)), findsOneWidget);
    expect(find.descendant(of: menuItemFind, matching: find.text(sortCriteria2.label)), findsOneWidget);
    expect(find.descendant(of: menuItemFind, matching: find.byIcon(sortCriteria1.icon)), findsOneWidget);
    expect(find.descendant(of: menuItemFind, matching: find.byIcon(sortCriteria2.icon)), findsOneWidget);
  });

  testWidgets('Sort items reflect the selected state', (widgetTester) async {
    final applyDelegate = FilterActionDelegate();

    await _build(
      widgetTester, 
      [  ],
      [ sortCriteria1, sortCriteria2 ],
      applyDelegate.applyFilter
    );

    final filterFind = find.byWidgetPredicate((widget) => widget is PopupMenuButton<SortCriteria<TestItem>>);

    final sorts = [ sortCriteria1, sortCriteria2 ];

    await Future.forEach(sorts.indexed, (element) async {
      await widgetTester.tap(filterFind).then((_) => widgetTester.pumpAndSettle(const Duration(seconds: 1)));
      var menuItemFind = find.byType(PopupMenuItem<SortCriteria<TestItem>>);
      var iconFind = find.descendant(of: menuItemFind, matching: find.byType(Icon));

      await widgetTester.tap(iconFind.at(element.$1)).then((_) => widgetTester.pumpAndSettle(const Duration(seconds: 1)));
    });

    expect(applyDelegate.appliedFilters, [ [  ], [  ], ]);
    expect(applyDelegate.appliedSort,sorts);
    expect(applyDelegate.appliedText, ["", "",]);
  });
}