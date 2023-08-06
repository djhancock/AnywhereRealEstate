import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:simpsons_demo/flavor.dart';
import 'package:simpsons_demo/screens/landing/landing_bloc.dart';
import 'package:simpsons_demo/screens/landing/landing_page.dart';
import 'package:simpsons_demo/theme.dart';
import 'package:simpsons_demo/util/duck_duck_go_api_client.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final flavor = Provider.of<Flavor>(context);

    return MaterialApp(
      theme: appTheme(context),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), 
      ],
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle(flavor.name),
      home: Provider<LandingBloc>(
        create: (context) {
          final apiClient = Provider.of<DuckDuckGoApiClient>(context, listen: false);
          return LandingBloc(apiClient)..load();
        },
        dispose: (context, value) {
          value.dispose();
        },
        child: LandingPage()
      ),
    );
  }
}