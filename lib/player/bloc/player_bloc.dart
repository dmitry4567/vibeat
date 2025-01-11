import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:vibeat/player/model/model_track.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  static String host = "172.20.10.2";

  final AudioPlayer player = AudioPlayer();
  late ConcatenatingAudioSource playlist;

  PlayerBloc()
      : super(const PlayerState(
          isPlaying: false,
          isRepeat: false,
          currentTrackIndex: 0,
          currentTime: 0,
          endTime: 0,
          trackList: [],
        )) {
    on<GetRecommendEvent>(
      (event, emit) async {
        try {
          final response =
              await http.get(Uri.parse("http://$host:3000/music/rec/rec"));

          if (response.statusCode == 200) {
            final trackData = jsonDecode(response.body);

            List<Track> trackList = [];

            for (var t in trackData) {
              final track = Track(
                id: t["id"],
                name: t["name"],
                bitmaker: t["bitmaker"],
                trackUrl: t["trackUrl"],
                photoUrl: t["photoUrl"],
              );

              trackList.add(track);
            }

            List<AudioSource> audioSources = trackList
                .map((track) => AudioSource.uri(Uri.parse(track.trackUrl)))
                .toList();

            playlist = ConcatenatingAudioSource(
              useLazyPreparation: true,
              shuffleOrder: DefaultShuffleOrder(),
              children: audioSources,
            );

            await player.setAudioSource(playlist,
                initialIndex: 0, initialPosition: Duration.zero);

            emit(state.copyWith(
                trackList: trackList, currentTrackIndex: player.currentIndex!));
          } else {
            throw Exception("Failed to load new track");
          }
        } catch (e) {
          print(e);
        }
      },
    );

    on<PlayAudioEvent>((event, emit) {
      player.play();
      emit(state.copyWith(isPlaying: true));
    });

    on<PauseAudioEvent>((event, emit) {
      player.pause();
      emit(state.copyWith(isPlaying: false));
    });

    on<StopAudioEvent>((event, emit) {
      emit(state.copyWith(isPlaying: false, currentTime: 0));
    });

    on<NextTrackEvent>((event, emit) async {
      // final nextIndex = state.currentTrackIndex + 1;

      // Если следующий индекс выходит за пределы списка, загружаем новый трек
      // if (nextIndex >= state.trackList.length) {

      // final newTrackUrl = "http://$host:3000/music/3.wav"; // Пример API

      // add(LoadNextTrackEvent(newTrackUrl));

      await player.seekToNext();
      await player.play();

      if (player.currentIndex! + 2 == state.trackList.length) {
        final newTrack = Track(
            id: "2",
            name: "name",
            bitmaker: "bitmaker",
            trackUrl: "http://$host:3000/music/2.wav",
            photoUrl: "http://$host:3000/photo/2.png");

        final updatedTrackList = List<Track>.from(state.trackList)
          ..add(newTrack);

        final newChild1 = AudioSource.uri(Uri.parse(newTrack.trackUrl));

        await playlist.add(newChild1);

        emit(state.copyWith(
            trackList: updatedTrackList,
            currentTrackIndex: player.currentIndex!));
      }

      emit(state.copyWith(currentTrackIndex: player.currentIndex));
    });

    on<PreviousTrackEvent>((event, emit) async {
      if (state.currentTrackIndex > 0) {
        await player.seekToPrevious();
        await player.play();

        final prevIndex = state.currentTrackIndex - 1;

        emit(state.copyWith(currentTrackIndex: prevIndex));
      }
    });

    on<ToggleRepeatEvent>((event, emit) {
      emit(state.copyWith(isRepeat: !state.isRepeat));
    });

    on<UpdateCurrentTime>((event, emit) {
      emit(state.copyWith(currentTime: event.currentTime));
    });

    on<LoadNextTrackEvent>((event, emit) async {
      try {
        // final response = await http.get(Uri.parse(event.trackUrl));
        // if (response.statusCode == 200) {
        //   final trackData = jsonDecode(response.body);
        //   final newTrackUrl = trackData["url"];

        //   final updatedTrackList = List<String>.from(state.trackList)
        //     ..add(newTrackUrl);

        //   emit(state.copyWith(
        //     trackList: updatedTrackList,
        //     currentTrackIndex: state.currentTrackIndex + 1,
        //   ));
        // } else {
        //   throw Exception("Failed to load new track");
        // }

        final newTrack = Track(
            id: "2",
            name: "name",
            bitmaker: "bitmaker",
            trackUrl: "http://$host:3000/music/2.wav",
            photoUrl: "http://$host:3000/photo/2.png");

        final updatedTrackList = List<Track>.from(state.trackList)
          ..add(newTrack);

        emit(state.copyWith(
          trackList: updatedTrackList,
          currentTrackIndex: state.currentTrackIndex + 1,
        ));
      } catch (e) {
        print("Error loading track: $e");
      }
    });
  }
}
