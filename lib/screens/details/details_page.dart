import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpsons_demo/screens/details/details_bloc.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<DetailsBloc>(context);
    final character = bloc.simpsonsModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: (character.icon?.uri == null)
                  ? Text("No Image")
                  : Image.network(character.icon!.uri.toString()),
            ),
            Text(character.description),
            TextButton(
              onPressed: () {
                bloc.showMoreInfo();
              },
              child: Text("View More"),
            )
          ],
        ),
      ),
    );
  }
}
