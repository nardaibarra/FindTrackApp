part of 'songs_bloc.dart';

abstract class SongsEvent extends Equatable {
  const SongsEvent();

  @override
  List<Object> get props => [];
}

class IdentifySongEvent extends SongsEvent {}

class AddToFavoritesEvent extends SongsEvent {
  final Map<String, String> songInfo;
  AddToFavoritesEvent(this.songInfo);
  @override
  List<Object> get props => [songInfo];
}

class RemoveFromFavoritesEvent extends SongsEvent {
  final String songTitle;
  RemoveFromFavoritesEvent(this.songTitle);
  @override
  List<Object> get props => [songTitle];
}

class ShowFavoritesEvent extends SongsEvent {}
