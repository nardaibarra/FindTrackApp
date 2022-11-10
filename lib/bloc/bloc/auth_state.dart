part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthenticatedState extends AuthState {
  @override
  List<Object> get props => [];
}

class UnauthenticatedState extends AuthState {
  @override
  List<Object> get props => [];
}

class SuccessLoginState extends AuthState {
  @override
  List<Object> get props => [];
}

class ErrorLoginState extends AuthState {
  @override
  List<Object> get props => [];
}

class SuccessLogoutState extends AuthState {
  @override
  List<Object> get props => [];
}

class ErrorLogoutState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoadingLogoutState extends AuthState {
  @override
  List<Object> get props => [];
}
