import 'package:find_track_app/bloc/bloc/auth_bloc.dart';
import 'package:find_track_app/screens/home.dart';
import 'package:find_track_app/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/songs_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(VerifyAuthenticationEvent()),
        ),
        BlocProvider(
          create: (context) => SongsBloc(),
        )
      ],
      child: MyApp(),
    ),
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
        home: BlocConsumer<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthenticatedState || state is SuccessLoginState) {
              print(state);
              return Home();
            } else if (state is UnauthenticatedState ||
                state is SuccessLogoutState) {
              print(state);
              return Login();
            } else {
              print(state);
              return Login();
            }
          },
          listener: (context, state) {},
        ));
  }
}
