part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class VerifyAuthenticationEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LogoutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class GoogleLoginEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AnonymousLoginEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}
