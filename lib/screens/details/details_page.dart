import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpsons_demo/screens/details/details_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<DetailsBloc>(context);
    final character = bloc.simpsonsModel;
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final targetWidth = min(constraints.maxWidth, 256.0);

                    return SizedBox(
                      width: targetWidth,
                      child: (character.icon?.uri == null)
                          ? Text(localization.detailsMissingImageLabel)
                          : Image.network(
                              character.icon!.uri.toString(),
                              fit: BoxFit.fitWidth,
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                character.description,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                onPressed: () {
                  bloc.showMoreInfo();
                },
                child: Text(localization.detailsMissingViewMore),
              )
            ],
          ),
        ),
      ),
    );
  }
}
