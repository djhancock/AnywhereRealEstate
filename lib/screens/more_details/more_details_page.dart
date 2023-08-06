// import 'package:flutter/material.dart';
// import 'package:simpsons_demo/model/simpson_model.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class MoreDetailsPage extends StatefulWidget {
//   final SimpsonsModel simpsonsModel;

//   const MoreDetailsPage({
//     required this.simpsonsModel,
//     super.key,
//   });

//   @override
//   State<StatefulWidget> createState() => MoreDetailsPageState();
// }

// class MoreDetailsPageState extends State<MoreDetailsPage> {
//   final WebViewController _controller = WebViewController();

//   @override
//   void initState() {
//     super.initState();
//     _controller.loadRequest(widget.simpsonsModel.firstUrl);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Details ${widget.simpsonsModel.name}"),
//       ),
//       body: WebViewWidget(
//         controller: _controller,
//       ),
//     );
//   }
// }