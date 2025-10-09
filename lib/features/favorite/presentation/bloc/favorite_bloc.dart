import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vibeat/core/errors/failure.dart';
import 'package:vibeat/features/favorite/data/models/beat_model.dart';
import 'package:vibeat/features/favorite/domain/usecases/add_to_favorite.dart';
import 'package:vibeat/features/favorite/domain/usecases/get_favorite_beats.dart';
import 'package:vibeat/features/favorite/domain/usecases/is_favorite.dart';
import 'package:vibeat/features/favorite/domain/usecases/remove_from_favorite.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc({
    required GetFavoriteBeats getFavoriteBeats,
    required IsFavorite isFavorite,
    required AddToFavorite addToFavorite,
    required RemoveFromFavorite removeFromFavorite,
  })  : _getFavoriteBeats = getFavoriteBeats,
        _isFavorite = isFavorite,
        _addToFavorite = addToFavorite,
        _removeFromFavorite = removeFromFavorite,
        super( FavoriteStateInitial()) {
    on<GetFavoriteBeatsEvent>((event, emit) async {
      // Сохраняем текущие данные если они есть
      final currentBeats = state is FavoriteBeatsLoaded 
          ? (state as FavoriteBeatsLoaded).favoriteBeats 
          : [];

      // Показываем loading только если данных еще нет
      if (currentBeats.isEmpty) {
        emit( GettingFavoritesBeats());
      }

      final result = await _getFavoriteBeats();

      result.fold(
        (failure) {
          switch (failure.runtimeType) {
            case NoInternetFailure:
              emit( FavoriteBeatsNoInternetError());
            case ApiFailure:
              emit(FavoriteBeatsError(failure.message));
          }
        },
        (result) => emit(FavoriteBeatsLoaded(result)),
      );
    });

    on<AddFavoriteEvent>((event, emit) async {
      // Оптимистичное обновление - сразу удаляем из списка
      if (state is FavoriteBeatsLoaded) {
        final currentState = state as FavoriteBeatsLoaded;
        // Создаем копию списка без удаленного элемента
        final updatedBeats = List<BeatModel>.from(currentState.favoriteBeats);
        emit(FavoriteBeatsLoaded(updatedBeats));
      }

      final result = await _addToFavorite(AddToFavoriteParam(beatId: event.beatId));

      result.fold(
        (failure) {
          // Если ошибка - возвращаем предыдущее состояние
          if (state is FavoriteBeatsLoaded) {
            final currentState = state as FavoriteBeatsLoaded;
            emit(FavoriteBeatsLoaded(currentState.favoriteBeats));
          }
          // Можно показать ошибку, но не сбрасывать состояние
        },
        (_) {
          // Обновляем данные с сервера
          add(GetFavoriteBeatsEvent());
        },
      );
    });

    on<DeleteFavoriteEvent>((event, emit) async {
      // Оптимистичное обновление - сразу удаляем из списка
      if (state is FavoriteBeatsLoaded) {
        final currentState = state as FavoriteBeatsLoaded;
        // Создаем копию списка без удаленного элемента
        final updatedBeats = currentState.favoriteBeats
            .where((beat) => beat.id != event.beatId)
            .toList();
        emit(FavoriteBeatsLoaded(updatedBeats));
      }

      final result = await _removeFromFavorite(
          RemoveFromFavoriteParam(beatId: event.beatId));

      result.fold(
        (failure) {
          // Если ошибка - возвращаем предыдущее состояние
          if (state is FavoriteBeatsLoaded) {
            final currentState = state as FavoriteBeatsLoaded;
            emit(FavoriteBeatsLoaded(currentState.favoriteBeats));
          }
          // Можно показать ошибку, но не сбрасывать состояние
        },
        (_) {
          // Обновляем данные с сервера для синхронизации
          add(GetFavoriteBeatsEvent());
        },
      );
    });
  }

  final GetFavoriteBeats _getFavoriteBeats;
  final AddToFavorite _addToFavorite;
  final RemoveFromFavorite _removeFromFavorite;
  final IsFavorite _isFavorite;

  Either<Failure, bool> isFavoriteBeat(String beatId) =>
      _isFavorite(IsFavoriteParam(beatId: beatId));
}