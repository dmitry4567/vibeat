import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vibeat/features/favorite/data/models/beat_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'all_beats_of_beatmaker_event.dart';
part 'all_beats_of_beatmaker_state.dart';

class AllBeatsOfBeatmakerBloc
    extends Bloc<AllBeatsOfBeatmakerEvent, AllBeatsOfBeatmakerState> {
  AllBeatsOfBeatmakerBloc() : super(const AllBeatsOfBeatmakerState()) {
    on<GetBeats>(_onLoadBeats);
  }

  void _onLoadBeats(
      GetBeats event, Emitter<AllBeatsOfBeatmakerState> emit) async {
    emit(state.copyWith(isLoading: true));

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ip = sharedPreferences.getString("ip");

    final response = await http.get(
      Uri.parse("http://$ip:7771/api/beat/byBeatmakerId/${event.beatmakerId}"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      final List<BeatModel> listBeats =
          data.map((beat) => BeatModel.fromJson(beat)).toList();

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
}
