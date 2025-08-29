import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vibeat/filter/result.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:http/http.dart' as http;

part 'all_beats_of_beatmaker_event.dart';
part 'all_beats_of_beatmaker_state.dart';

class AllBeatsOfBeatmakerBloc
    extends Bloc<AllBeatsOfBeatmakerEvent, AllBeatsOfBeatmakerState> {
  final PlayerBloc playerBloc;
  late final StreamSubscription _playerSubscription;
  String? currentBeatId;

  AllBeatsOfBeatmakerBloc({required this.playerBloc})
      : super(const AllBeatsOfBeatmakerState()) {
    _playerSubscription = playerBloc.stream.listen((playerState) {
      print(playerState.currentTrackBeatId);
      currentBeatId = playerState.currentTrackBeatId;

      add(ToggleListened(playerState.currentTrackBeatId));
    });

    on<GetBeats>(_onLoadBeats);
    on<ToggleListened>(_onToggleListened);
  }

  void _onLoadBeats(
      GetBeats event, Emitter<AllBeatsOfBeatmakerState> emit) async {
    emit(state.copyWith(isLoading: true));

    final response = await http.get(
      Uri.parse(
          "http://192.168.0.135:7771/api/beat/byBeatmakerId/${event.beatmakerId}"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      log(currentBeatId.toString());

      final List<BeatEntity> listBeats =
          data.map((beat) => BeatEntity.fromJson(beat, currentBeatId)).toList();

      emit(
        state.copyWith(
          beats: listBeats,
          isLoading: false,
        ),
      );
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onToggleListened(
      ToggleListened event, Emitter<AllBeatsOfBeatmakerState> emit) {
    final updatedBeats = state.beats.map((beat) {
      if (beat.isCurrentPlaying) return beat.copyWith(isCurrentPlaying: false);

      if (beat.id == event.beatId) {
        return beat.copyWith(isCurrentPlaying: true);
      }
      
      return beat;
    }).toList();

    emit(state.copyWith(beats: updatedBeats));
  }

  @override
  Future<void> close() {
    _playerSubscription.cancel();
    return super.close();
  }
}
