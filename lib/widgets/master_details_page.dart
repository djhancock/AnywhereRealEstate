import 'package:flutter/material.dart';

class _ForcePoppableMaterialRoute<X> extends MaterialPageRoute<X> {
  _ForcePoppableMaterialRoute({required super.builder});

  @override
  bool get canPop => true;

  @override
  Future<RoutePopDisposition> willPop() async => RoutePopDisposition.pop;
}

class MasterDetailController {
  void Function(Widget widget)? onDetailsChanged;

  void showDetails(Widget widget) {
    onDetailsChanged?.call(widget);
  }
}

class MasterDetailPage 
  extends StatefulWidget {
  final double minDetailSize;
  final double maxMasterSize;
  final Widget masterPage;
  final MasterDetailController controller;

  const MasterDetailPage({
    super.key,
    required this.maxMasterSize,
    required this.minDetailSize,
    required this.masterPage,
    required this.controller,
  });
  @override
  createState() => MasterDetailPageState();
}

class MasterDetailPageState
  extends State<MasterDetailPage> {

  final _detailKey = GlobalKey<NavigatorState>();
  final _detailRoute = ValueNotifier<Route<dynamic>?>(null);

  @override
  void didUpdateWidget(covariant MasterDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.controller.onDetailsChanged = null;

    widget.controller.onDetailsChanged = _onWidgetChanged;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.onDetailsChanged = _onWidgetChanged;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final showSideBySide = mediaQuery.size.width > widget.minDetailSize;

    final detailWidget = ValueListenableBuilder(
      valueListenable: _detailRoute,
      builder: (context, value, child) {
        if(value == null) {
          return Container();
        } else {
          return Navigator(
            key: _detailKey,
            onGenerateInitialRoutes: (navigator, initialRoute) => [
              value
            ],
          );
        }
      },
    );

     Navigator(
      key: _detailKey,
      onGenerateInitialRoutes: (navigator, initialRoute) => [
        MaterialPageRoute(
          settings: const RouteSettings(
            name: "DetailRoot",
          ),
          builder: (context) => Container()
        )
      ],
    );

    if(!showSideBySide) {
      return Stack(
        children: [
          widget.masterPage,
          detailWidget
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: widget.maxMasterSize,
            child: widget.masterPage,
          ),
          Expanded(
            child: detailWidget
          )
        ],
      );
    }
  }
  
  void _onWidgetChanged(Widget widget) {
    final newRoute = _ForcePoppableMaterialRoute(builder: (context) => widget,);
    newRoute.popped.whenComplete(() => _detailRoute.value = null);
    _detailKey.currentState?.pushAndRemoveUntil(newRoute, (route) => route.settings.name == "DetailRoot");
    _detailRoute.value = newRoute;
  }
}