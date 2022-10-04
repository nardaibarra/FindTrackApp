import 'package:find_track_app/bloc/songs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class FavoriteCard extends StatelessWidget {
  final Map<String, String> song;
  FavoriteCard({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: NetworkImage("${song['image']}"),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            onPressed: () {
                              removeAlertDialog(context, "${song['title']}");
                            },
                            icon: Icon(Icons.favorite),
                            color: Colors.red)),
                    GestureDetector(
                      onTap: () {
                        {
                          _launchUrl('${song['where_to_listen']}');
                        }
                        ;
                      },
                      child: Container(
                          height: 65,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(110, 34, 34, 34),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15))),
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Column(children: [
                                Text('${song['title']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Text('${song['album']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10)),
                                Text('${song['artist']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10)),
                              ]))),
                    ),
                  ],
                ))));
  }

  removeAlertDialog(BuildContext context, String songTitle) {
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
            .add(RemoveFromFavoritesEvent(songTitle));
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

  _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launcher.launchUrl(_url)) throw "Could not launch $url";
  }
}
