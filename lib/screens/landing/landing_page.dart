import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpsons_demo/model/character_model.dart';
import 'package:simpsons_demo/screens/character_list/character_bloc.dart';
import 'package:simpsons_demo/screens/character_list/character_page.dart';
import 'package:simpsons_demo/screens/details/details_bloc.dart';
import 'package:simpsons_demo/screens/details/details_page.dart';
import 'package:simpsons_demo/util/duck_duck_go_api_client.dart';
import 'package:simpsons_demo/widgets/master_details_page.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<StatefulWidget> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage>
    implements CharacterListNavigator, DetailsBlocNavigator {
  final _masterDetailController = MasterDetailController();

  @override
  Widget build(BuildContext context) {
    return MasterDetailPage(
      maxMasterSize: 300,
      minDetailSize: 460,
      masterPage: Provider(
        create: (context) {
          final apiClient =
              Provider.of<DuckDuckGoApiClient>(context, listen: false);
          return CharacterListBloc(apiClient, this);
        },
        dispose: (context, value) {
          value.dispose();
        },
        child: const CharacterListPage(),
      ),
      controller: _masterDetailController,
    );
  }

  // CharacterListNavigator
  @override
  void showCharacterDetials(CharacterModel simpsonsModel) {
    _masterDetailController.showDetails(Provider(
      create: (context) {
        return DetailsBloc(simpsonsModel, this);
      },
      child: const DetailsPage(),
    ));
  }

  // DetailsBlocNavigator
  @override
  void showDetails(CharacterModel model) {
    launchUrl(model.firstUrl);
  }
}
