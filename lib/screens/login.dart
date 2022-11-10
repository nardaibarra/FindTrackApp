// ignore_for_file: must_be_immutable

import 'package:find_track_app/bloc/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.gif'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 90, bottom: 80),
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset('assets/images/music.png'),
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Color.fromARGB(205, 255, 255, 255),
                      ),
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: OutlinedButton(
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(GoogleLoginEvent());
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image:
                                  AssetImage("assets/images/google_logo.png"),
                              height: 30.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Sign in with Google',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                        // style: OutlinedButton.styleFrom(
                        //   shape: const RoundedRectangleBorder(
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(30))),
                        //   primary: Colors.grey.shade900,
                        //   side: BorderSide(color: Colors.grey.shade500, width: 1),
                        // )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'By logging in, you are agreeing to the Terms of Service.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey.shade600, fontWeight: FontWeight.bold),
            ),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

class InputText extends StatelessWidget {
  InputText({
    Key? key,
    required inputController,
    required hintText,
  })  : _inputController = inputController,
        _hintText = hintText,
        super(key: key);

  var _inputController;
  var _hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        cursorColor: Colors.grey.shade800,
        controller: _inputController,
        style: TextStyle(
            color: Colors.grey.shade800, decoration: TextDecoration.none),
        decoration: InputDecoration(
          filled: true,
          hintText: _hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          fillColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(0, 0, 187, 212)),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(0, 0, 187, 212)),
          ),
        ),
      ),
    );
  }
}
