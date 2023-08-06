import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpsons_demo/app.dart';
import 'package:simpsons_demo/flavor.dart';
import 'package:simpsons_demo/util/duck_duck_go_api_client.dart';
import 'package:simpsons_demo/util/rest_client.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  final restfulClient = HttpClient();
  final flavor = await getAppFlavor();

  final apiClient = clientFromFlavor(flavor, restfulClient, );

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: apiClient,),
        Provider.value(value: flavor)
      ],
      child: const App(),
    )    
  );
}

DuckDuckGoApiClient clientFromFlavor(Flavor flavor, HttpClient client) {
  switch(flavor) {
    case Flavor.simpsons: return DuckDuckGoSimpsonsClient(client);
    case Flavor.theWire: return DuckDuckGoTheWireClient(client);
  }
}

Future<Flavor> getAppFlavor() async {  
  WidgetsFlutterBinding.ensureInitialized();

  final packageInfo = await PackageInfo.fromPlatform();
  final packageName = packageInfo.packageName.replaceFirst("com.jhancock.sample.", "");

  switch(packageName) {
    case "simpsonsviewer": return Flavor.simpsons;
    case "wireviewer": return Flavor.theWire;
    default:
      throw Exception("Unsupported package name '$packageName'");
  }
}