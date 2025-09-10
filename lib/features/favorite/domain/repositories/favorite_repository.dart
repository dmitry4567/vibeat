import 'package:dartz/dartz.dart';
import 'package:vibeat/core/errors/failure.dart';
import 'package:vibeat/core/utils/typedef.dart';
import 'package:vibeat/features/favorite/data/models/beat_model.dart';

abstract class FavoriteRepository {
  ResultFuture<List<BeatModel>> getFavoriteBeats();
  ResultVoid addToFavorite({required String beatId});
  ResultVoid removeFromFavorite({required String beatId});
  Either<Failure, bool> isFavorite({required String beatId});
}
