part of 'favorite_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteStateInitial extends FavoriteState {
  const FavoriteStateInitial();
}

class GettingFavoritesBeats extends FavoriteState {
  const GettingFavoritesBeats();
}

class FavoriteBeatsLoaded extends FavoriteState {
  const FavoriteBeatsLoaded(this.favoriteBeats);

  final List<BeatModel> favoriteBeats;

  @override
  List<Object?> get props => favoriteBeats.map((beat) => beat.id).toList();
}

class FavoriteBeatsError extends FavoriteState {
  const FavoriteBeatsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class FavoriteBeatsNoInternetError extends FavoriteState {
  const FavoriteBeatsNoInternetError();
}
