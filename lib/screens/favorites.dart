import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/songs_bloc.dart';
import '../widgets/favorite_card.dart';

// ignore: must_be_immutable
class Favorites extends StatelessWidget {
  Favorites({super.key});

  List<Map<String, String>> _favorites = [];

  @override
  Widget build(BuildContext context) {
    List<dynamic> params =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    this._favorites = params[0];

    return BlocConsumer<SongsBloc, SongsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text("Your Favorite Songs")),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _favorites.length,
                itemBuilder: (BuildContext context, index) {
                  return GestureDetector(
                    child: FavoriteCard(song: _favorites[index]),
                  );
                },
              ),
            ),
          );
        });
  }
}
