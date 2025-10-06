part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class GetFavoriteBeatsEvent extends FavoriteEvent {}

class AddFavoriteEvent extends FavoriteEvent {
  const AddFavoriteEvent({required this.beatId});

  final String beatId;

  @override
  List<Object?> get props => [beatId];
}

class DeleteFavoriteEvent extends FavoriteEvent {
  const DeleteFavoriteEvent({required this.beatId});

  final String beatId;

  @override
  List<Object?> get props => [beatId];
}
