import 'package:find_track_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/songs_bloc.dart';

void main() {
  runApp(
    BlocProvider(create: (context) => SongsBloc(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.dark(),
            brightness: Brightness.dark,
            primaryColor: Color.fromARGB(255, 116, 119, 117),
            primarySwatch: Colors.purple),
        title: 'Find Track App',
        home: Home());
  }
}
