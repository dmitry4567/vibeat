import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
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
        super(const FavoriteStateInitial()) {
    on<GetFavoriteBeatsEvent>((event, emit) async {
      emit(const GettingFavoritesBeats());

      final result = await _getFavoriteBeats();

      result.fold(
        (failure) => emit(FavoriteBeatsError(failure.message)),
        (result) => emit(FavoriteBeatsLoaded(result)),
      );
    });

    on<AddFavoriteEvent>((event, emit) async {
      final result =
          await _addToFavorite(AddToFavoriteParam(beatId: event.beatId));

      result.fold(
        (failure) => emit(FavoriteBeatsError(failure.message)),
        (_) {
          add(GetFavoriteBeatsEvent());
        },
      );
    });

    on<DeleteFavoriteEvent>((event, emit) async {
      emit(const GettingFavoritesBeats());

      final result = await _removeFromFavorite(
          RemoveFromFavoriteParam(beatId: event.beatId));

      result.fold(
        (failure) => emit(FavoriteBeatsError(failure.message)),
        (_) {
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
