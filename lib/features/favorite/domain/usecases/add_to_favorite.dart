import 'package:equatable/equatable.dart';
import 'package:vibeat/core/usercases/usecase.dart';
import 'package:vibeat/core/utils/typedef.dart';
import 'package:vibeat/features/favorite/domain/repositories/favorite_repository.dart';

class AddToFavorite extends UseCaseWithParams<void, AddToFavoriteParam> {
  const AddToFavorite(this._repository);

  final FavoriteRepository _repository;

  @override
  ResultVoid call(AddToFavoriteParam params) async =>
      _repository.addToFavorite(beatId: params.beatId);
}

class AddToFavoriteParam extends Equatable {
  final String beatId;

  const AddToFavoriteParam({required this.beatId});

  @override
  List<Object?> get props => [beatId];
}
