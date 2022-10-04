import 'package:find_track_app/screens/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:find_track_app/bloc/songs_bloc.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'found_song.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  bool _animate = false;
  String _status = "Tap to listen";
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SongsBloc, SongsState>(listener: (context, state) {
        if (state is SongListeingState) {
          this._animate = true;
          this._status = "Listening...";
        } else if (state is SongFoundState) {
          this._animate = false;
          this._status = "Tap to listen";
          navigateToSongPage(context, state);
        } else if (state is SongNotFoundState) {
          this._animate = false;
          this._status = "Tap to listen";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Song was not found")),
          );
        } else if (state is SongErrorState) {
          this._animate = false;
          this._status = "Tap to listen";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is MicrophoneAceesDeniedState) {
          this._animate = false;
          this._status = "Tap to listen";
          showAlertDialog(context);
        } else if (state is ShowingFavoritesState) {
          this._animate = false;
          this._status = "Tap to listen";
          print('navigate');
          navigateToFavoritesPage(context, state);
        } else if (state is SongsInitial) {
          this._animate = false;
          this._status = "Tap to listen";
        }
      }, builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(top: 150),
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text('${_status}'),
              ),
              AvatarGlow(
                  glowColor: Color.fromARGB(255, 29, 12, 212),
                  endRadius: 140.0,
                  duration: Duration(milliseconds: 2000),
                  animate: _animate,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: IconButton(
                    onPressed: () {
                      BlocProvider.of<SongsBloc>(context)
                          .add(IdentifySongEvent());
                    },
                    iconSize: 150,
                    icon: CircleAvatar(
                      child: Image.asset(
                        'assets/images/music.png',
                        height: 300,
                      ),
                      radius: 90.0,
                      backgroundColor: Color.fromARGB(2, 0, 0, 0),
                    ),
                  )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 100, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 223, 223, 223),
                        child: IconButton(
                            color: Color.fromARGB(183, 4, 4, 4),
                            icon: Icon(Icons.favorite),
                            onPressed: (() {
                              BlocProvider.of<SongsBloc>(context)
                                  .add(ShowFavoritesEvent());
                              ;
                            }))),
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 223, 223, 223),
                      child: IconButton(
                          color: Color.fromARGB(183, 4, 4, 4),
                          icon: Icon(Icons.power_settings_new_rounded),
                          onPressed: () {}),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  navigateToFavoritesPage(BuildContext context, state) {
    print('navigating');
    Navigator.of(context).push(MaterialPageRoute(
        builder: (nextContext) => BlocProvider.value(
            value: BlocProvider.of<SongsBloc>(context), child: Favorites()),
        settings: RouteSettings(arguments: [state.favoriteList])));
  }

  navigateToSongPage(BuildContext context, state) {
    print('navigating');
    Navigator.of(context).push(MaterialPageRoute(
        builder: (nextContext) => BlocProvider.value(
            value: BlocProvider.of<SongsBloc>(context), child: FoundSong()),
        settings: RouteSettings(arguments: [state.info, state.isFavorite])));
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Microphone permission required"),
      content: Text(
          "FindTrack App can´t access your microphone to record the song. To give access, go to your settings."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
