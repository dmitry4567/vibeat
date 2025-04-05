import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vibeat/core/usercases/usecase.dart';
import 'package:vibeat/features/anketa/domain/entities/anketa_entity.dart';
import 'package:vibeat/features/anketa/domain/usecases/get_anketa.dart';
import 'package:vibeat/features/anketa/domain/usecases/send_anketa_response.dart';

part 'anketa_event.dart';
part 'anketa_state.dart';

class AnketaBloc extends Bloc<AnketaEvent, AnketaState> {
  final GetAnketa getAnketa;
  final SendAnketaResponse sendAnketaResponse;

  AnketaBloc({
    required this.getAnketa,
    required this.sendAnketaResponse,
  }) : super(const AnketaState()) {
    on<GetAnketaEvent>(_onGetAnketa);
    on<SendAnketaResponseEvent>(_onSendAnketaResponse);
    on<AddGenreEvent>(_onAddGenre);
  }

  Future<void> _onGetAnketa(
      GetAnketaEvent event, Emitter<AnketaState> emit) async {
    emit(state.copyWith(status: AnketaStatus.loading));

    final result = await getAnketa(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: AnketaStatus.error,
        errorMessage: failure.message,
      )),
      (anketa) => emit(state.copyWith(
        status: AnketaStatus.success,
        anketa: anketa,
      )),
    );
  }

  Future<void> _onSendAnketaResponse(
    SendAnketaResponseEvent event,
    Emitter<AnketaState> emit,
  ) async {
    if (state.selectedGenres!.length < 3) {
      emit(state.copyWith(
        status: AnketaStatus.error,
        errorMessage: 'Please select at least three genres',
      ));
      return;
    }
    if (state.selectedGenres!.length > 5) {
      emit(state.copyWith(
        status: AnketaStatus.error,
        errorMessage: 'Please select no more than five genres',
      ));
      return;
    }

    final data = state.selectedGenres?.map((e) => e.text).toList().join(',');
    final result = await sendAnketaResponse(data!);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AnketaStatus.error,
        errorMessage: failure.message,
        isResponseSuccess: false,
      )),
      (data) => emit(state.copyWith(
        status: AnketaStatus.success,
        isResponseSuccess: true,
      )),
    );
  }

  Future<void> _onAddGenre(
    AddGenreEvent event,
    Emitter<AnketaState> emit,
  ) async {
    emit(state.copyWith(status: AnketaStatus.initial));
    final selectedGenres = List<AnketaEntity>.from(state.selectedGenres ?? []);

    if (selectedGenres.contains(event.genre)) {
      selectedGenres.remove(event.genre);
    } else {
      selectedGenres.add(event.genre);
    }

    emit(state.copyWith(selectedGenres: selectedGenres));
  }
}
