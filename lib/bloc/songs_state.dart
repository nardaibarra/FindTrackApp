part of 'songs_bloc.dart';

abstract class SongsState extends Equatable {
  const SongsState();
  @override
  List<Object> get props => [];
}

class SongsInitial extends SongsState {}

class SongListeingState extends SongsState {}

class SongFoundState extends SongsState {
  final Map<String, String> info;
  final bool isFavorite;
  SongFoundState(this.info, this.isFavorite);
  @override
  List<Object> get props => [info, isFavorite];
}

class SongNotFoundState extends SongsState {}

class SongErrorState extends SongsState {
  final String error;
  SongErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

class MicrophoneAceesDeniedState extends SongsState {}

///favorites
class AddedToFavoritesState extends SongsState {}

class RemovedFromFavoritesState extends SongsState {}

class ShowingFavoritesState extends SongsState {
  final List<Map<String, String>> favoriteList;
  ShowingFavoritesState(this.favoriteList);
  @override
  List<Object> get props => [favoriteList];
}

class IdleFavoritesState extends SongsState {}
