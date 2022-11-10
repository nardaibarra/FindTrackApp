import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_track_app/repositories/audD_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:record/record.dart';
import 'dart:convert' as convert;

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  List<dynamic> favoriteSongs = [];
  SongsBloc() : super(SongsInitial()) {
    on<IdentifySongEvent>(_identifySong);
    on<AddToFavoritesEvent>(_addToFavorites);
    on<RemoveFromFavoritesEvent>(_removeFromFavorites);
    on<ShowFavoritesEvent>(_goToFavorites);
  }

  FutureOr<void> _identifySong(
      IdentifySongEvent event, Emitter<SongsState> emit) async {
    Directory _tempDir = await getTemporaryDirectory();
    final String _fileName = 'recordingSample.mp3';
    final String _recordingPath = _tempDir.path;
    final _record = Record();
    String? _sampleFilePath = '';
    var file;
    var _sampleFile = '';
    bool isFavorite;
    var audd = AudD_API();

    //chek if mic has permissions
    if (!await _record.hasPermission()) {
      emit(MicrophoneAceesDeniedState());
      emit(SongsInitial());
      return null;
    }
    //glow icon
    emit(SongListeingState());

    //try to record sample
    try {
      _sampleFilePath = await recordSample(_record, _fileName, _recordingPath);
      file = File('${_sampleFilePath}');
      _sampleFile = await file_to_bits(file);
    } catch (e) {
      emit(SongErrorState(error: 'App could not record sample'));
      emit(SongsInitial());
      return null;
    }

    //post request api
    try {
      Response response = await audd.postRequestAudD(_sampleFile);
      print(response);
      var info = convert.jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (info['result'] != null) {
          print(this.favoriteSongs);
          isFavorite = this
              .favoriteSongs
              .any((element) => element['title'] == (info['result']['title']));
          print(info['title']);
          Map<String, String> finalinfo = sendinfo(info);
          print(isFavorite);
          emit(SongFoundState(finalinfo, isFavorite));
          print(finalinfo);
        } else {
          emit(SongNotFoundState());
        }
      }
    } catch (e) {
      print(e);
      emit(SongErrorState(error: 'App could not reach server'));
      return null;
    }

    //stop icon glow
    emit(SongsInitial());
  }

//aux functions
  Future<String?> recordSample(
      Record record, String fileName, String recordingPath) async {
    await record.start(
      path: '${recordingPath}/${fileName}',
      encoder: AudioEncoder.aacLc, // by default
      bitRate: 128000, // by default
      samplingRate: 44100, // by default
    );
    await Future.delayed(Duration(seconds: 6));
    return await record.stop(); //returns where file is
  }

  Future<String> file_to_bits(File sampleFile) async {
    List<int> fileBytes = await sampleFile.readAsBytes();
    String base64String = base64Encode(fileBytes);
    return '$base64String';
  }

  Map<String, String> sendinfo(info) {
    Map<String, String> finalInfo = {};
    finalInfo['title'] = info['result']?['title'] ?? 'No Title';
    finalInfo['artist'] = info['result']?['artist'] ?? 'No Title';
    finalInfo['album'] = info['result']?['album'] ?? 'No Album';
    finalInfo['release_date'] =
        info['result']?['release_date'] ?? 'No Realease Date';
    finalInfo['apple_music'] = info['result']?['apple_music']?['url'] ?? '#';
    finalInfo['spotify'] =
        info['result']?['spotify']?['external_urls']?['spotify'] ?? '#';
    finalInfo['image'] = info['result']?['spotify']?['album']?['images']?[0]
            ?['url'] ??
        'https://images.unsplash.com/photo-1617994452722-4145e196248b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80';
    finalInfo['where_to_listen'] = info['result']?['song_link'] ?? '#';
    return finalInfo;
  }

  FutureOr<void> _addToFavorites(
      AddToFavoritesEvent event, Emitter<SongsState> emit) async {
    await FirebaseFirestore.instance.collection('songs').add({
      'title': event.songInfo['title'],
      'artist': event.songInfo['artist'],
      'album': event.songInfo['album'],
      'release_date': event.songInfo['release_date'],
      'apple_music': event.songInfo['apple_music'],
      'spotify': event.songInfo['spotify'],
      'image': event.songInfo['image'],
      'where_to_listen': event.songInfo['where_to_listen'],
      'id': FirebaseAuth.instance.currentUser?.uid
    });

    this.favoriteSongs.add(event.songInfo);
    emit(AddedToFavoritesState());
    emit(IdleFavoritesState());
  }

  FutureOr<void> _removeFromFavorites(
      RemoveFromFavoritesEvent event, Emitter<SongsState> emit) async {
    var removedSong = await FirebaseFirestore.instance
        .collection('songs')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('title', isEqualTo: event.songTitle)
        .get()
        .then((querySnapshot) => querySnapshot);

    for (var doc in removedSong.docs) {
      await doc.reference.delete();
    }

    emit(RemovedFromFavoritesState());
    this
        .favoriteSongs
        .removeWhere((element) => element["title"] == event.songTitle);
    print(this.favoriteSongs);
    emit(IdleFavoritesState());
    emit(SongsInitial());
  }

  Future<FutureOr<void>> _goToFavorites(
      ShowFavoritesEvent event, Emitter<SongsState> emit) async {
    favoriteSongs = await getFavorites();
    emit(ShowingFavoritesState(this.favoriteSongs));
    emit(IdleFavoritesState());
  }

  FutureOr<List<dynamic>> getFavorites() async {
    var favoriteSongs = await FirebaseFirestore.instance
        .collection("songs")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    var mySongs = favoriteSongs.docs
        .map((doc) => doc.data().cast<String, String>())
        .toList();
    print(mySongs);
    return mySongs;
  }
}
