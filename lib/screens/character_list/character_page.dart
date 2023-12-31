import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:simpsons_demo/flavor.dart';
import 'package:simpsons_demo/model/character_model.dart';
import 'package:simpsons_demo/screens/character_list/character_bloc.dart';
import 'package:simpsons_demo/widgets/filter_bar.dart';

class CharacterCell extends StatelessWidget {
  final CharacterModel character;

  const CharacterCell(this.character, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: Text(character.name),
    );
  }
}

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({
    super.key,
  });

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  late Future<void> loadSimpsonsFuture;

  @override
  void initState() {
    super.initState();
    _doLoad();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final landingBloc = Provider.of<CharacterListBloc>(context);
    final flavor = Provider.of<Flavor>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.landingPageTitle(flavor.name)),
        bottom: PreferredSize(
          preferredSize: Size(0, 25),
          child: FilterBar<CharacterModel>(
            filters: [
              FilterCriteria<CharacterModel>(
                filter: (item) => item.icon != null,
                label: localization.characterPageFilterByImage,
              ),
            ],
            sort: [
              SortCriteria(
                sort: (item1, item2) => item1.name.compareTo(item2.name),
                icon: Icons.arrow_downward,
                label: localization.characterPageSortAlphabetical,
              ),
              SortCriteria(
                sort: (item1, item2) => item2.name.compareTo(item1.name),
                icon: Icons.arrow_upward,
                label: localization.characterPageSortAlphabetical,
              )
            ],
            filterDelegate: landingBloc.applyFilter,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: landingBloc.stream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state == null) {
            return Container();
          } else {
            if (state.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    Text(localization.pleaseWaitLabel),
                    Text(localization.landingPageLoading(flavor.name)),
                  ],
                ),
              );
            } else {
              final characters = state.simpsons;
              return RefreshIndicator(
                onRefresh: () => _doLoad(),
                child: ListView.separated(
                  itemCount: characters.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final character = characters[index];

                    return InkWell(
                      child: CharacterCell(
                        character,
                        key: ValueKey(character.firstUrl),
                      ),
                      onTap: () {
                        landingBloc.itemSelected(character);
                      },
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _doLoad() async {
    final landingBloc = Provider.of<CharacterListBloc>(context, listen: false);
    return landingBloc.load().catchError((err) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (context) {
              final errorMessage =
                  err.toString().replaceFirst(RegExp("^[^:]+:"), "");
              final localization = AppLocalizations.of(context)!;
              return AlertDialog(
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(localization.okLabel),
                  )
                ],
                title: Text(localization.errorLabel),
                content: Text(errorMessage),
              );
            });
      });
    });
  }
}
