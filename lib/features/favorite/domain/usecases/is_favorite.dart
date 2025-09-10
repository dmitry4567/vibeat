import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:vibeat/core/errors/failure.dart';
import 'package:vibeat/features/favorite/domain/repositories/favorite_repository.dart';

class IsFavorite {
  const IsFavorite(this._repository);

  final FavoriteRepository _repository;

  Either<Failure, bool> call(IsFavoriteParam params) =>
      _repository.isFavorite(beatId: params.beatId);
}

class IsFavoriteParam extends Equatable {
  final String beatId;

  const IsFavoriteParam({required this.beatId});

  @override
  List<Object?> get props => [beatId];
}
