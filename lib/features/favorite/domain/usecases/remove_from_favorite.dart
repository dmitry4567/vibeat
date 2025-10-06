import 'package:equatable/equatable.dart';
import 'package:vibeat/core/usercases/usecase.dart';
import 'package:vibeat/core/utils/typedef.dart';
import 'package:vibeat/features/favorite/domain/repositories/favorite_repository.dart';

class RemoveFromFavorite extends UseCaseWithParams<void, RemoveFromFavoriteParam> {
  const RemoveFromFavorite(this._repository);

  final FavoriteRepository _repository;

  @override
  ResultVoid call(RemoveFromFavoriteParam params) async =>
      _repository.removeFromFavorite(beatId: params.beatId);
}

class RemoveFromFavoriteParam extends Equatable {
  final String beatId;

  const RemoveFromFavoriteParam({required this.beatId});

  @override
  List<Object?> get props => [beatId];
}
