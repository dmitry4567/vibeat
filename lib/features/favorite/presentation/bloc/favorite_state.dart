part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteStateInitial extends FavoriteState {}

class GettingFavoritesBeats extends FavoriteState {}

class FavoriteBeatsLoaded extends FavoriteState {
  final List<BeatModel> favoriteBeats;

  const FavoriteBeatsLoaded(this.favoriteBeats);

  @override
  List<Object> get props => [favoriteBeats];
}

class FavoriteBeatsError extends FavoriteState {
  final String message;

  const FavoriteBeatsError(this.message);

  @override
  List<Object> get props => [message];
}

class FavoriteBeatsNoInternetError extends FavoriteState {}