import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_track_app/repositories/user_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<VerifyAuthenticationEvent>(verifyAuth);
    on<LogoutEvent>(logout);
    on<GoogleLoginEvent>(googleLogin);
    on<AnonymousLoginEvent>(anonymousLogin);
  }
  UserAuth auth = UserAuth();

  void verifyAuth(event, emit) {
    if (auth.isSignedIn()) {
      emit(AuthenticatedState());
    } else {
      emit(UnauthenticatedState());
    }
  }

  FutureOr<void> logout(event, emit) async {
    if (auth.isAnonymous()) {
      try {
        await auth.signOutFirebaseUser();
      } catch (e) {
        emit(ErrorLogoutState());
        print('error logout');
        return;
      }
    } else {
      try {
        await auth.signOutGoogleUser();
        await auth.signOutFirebaseUser();
        emit(LoadingLogoutState());
      } catch (e) {
        emit(ErrorLogoutState());
        print('error logout');
        return;
      }
    }

    emit(SuccessLogoutState());
  }

  FutureOr<void> googleLogin(event, emit) async {
    try {
      await auth.signInWithGoogle();
      emit(SuccessLoginState());
      print('login');
    } catch (e) {
      emit(ErrorLoginState());
      print('error login');
    }
  }

  FutureOr<void> anonymousLogin(event, emit) async {
    try {
      await auth.anonymousSignIn();
      emit(SuccessLoginState());
      print('anonymous login');
    } catch (e) {
      emit(ErrorLoginState());
      print('error login');
    }
  }
}
