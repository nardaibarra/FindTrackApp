import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../bloc/songs_bloc.dart';

// ignore: must_be_immutable
class FoundSong extends StatelessWidget {
  FoundSong({Key? key}) : super(key: key);
  bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    List<dynamic> params =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    Map<String, String> info = params[0];
    this._isFavorite = params[1];

    return BlocConsumer<SongsBloc, SongsState>(listener: (context, state) {
      if (state is AddedToFavoritesState) {
        this._isFavorite = true;
        print('status emitted');
      }
      if (state is RemovedFromFavoritesState) {
        this._isFavorite = false;
        print('status emitted');
      }
    }, builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Here you go..'),
            actions: [
              IconButton(
                onPressed: () {
                  if (this._isFavorite) {
                    removeAlertDialog(context, info);
                  } else {
                    addAlertDialog(context, info);
                  }
                },
                icon: Icon(Icons.favorite),
                color: this._isFavorite
                    ? Colors.red
                    : Color.fromARGB(255, 255, 255, 255),
              )
            ],
          ),
          body: Container(
              child: Column(children: [
            FadeInImage(
              image: NetworkImage(
                "${info['image']}",
              ),
              placeholder: AssetImage("assets/images/placeholder.png"),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/notAvailable.png',
                    fit: BoxFit.fitWidth);
              },
              fit: BoxFit.fitWidth,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${info['title']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text('${info['album']}'),
                    Text('${info['artist']}'),
                    Text('${info['release_date']}'),
                  ]),
            ),
            Container(
                margin: EdgeInsets.only(top: 15),
                child: Column(children: [
                  Text('Open with:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          tooltip: "Open with Apple Music",
                          icon: FaIcon(FontAwesomeIcons.apple),
                          onPressed: () =>
                              {_launchUrl('${info['apple_music']}')}),
                      IconButton(
                        tooltip: "Open with Spotify",
                        icon: FaIcon(FontAwesomeIcons.spotify),
                        onPressed: () => {_launchUrl('${info['spotify']}')},
                      )
                    ],
                  )
                ]))
          ])));
    });
  }

  _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launcher.launchUrl(_url)) throw "Could not launch $url";
  }

  addAlertDialog(BuildContext context, info) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Add"),
      onPressed: () {
        BlocProvider.of<SongsBloc>(context).add(AddToFavoritesEvent(info));
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Add to favorites"),
      content: Text("Would you like to add to favorites?"),
      actions: [
        cancelButton,
        continueButton,
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

  removeAlertDialog(BuildContext context, info) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Remove from favorites"),
      onPressed: () {
        BlocProvider.of<SongsBloc>(context)
            .add(RemoveFromFavoritesEvent(info['title']));
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Remove from favorites"),
      content: Text("Are you sure you want to remove it from favorites?"),
      actions: [
        cancelButton,
        continueButton,
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
