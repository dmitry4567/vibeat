import 'package:dartz/dartz.dart';
import 'package:vibeat/core/errors/exceptions.dart';
import 'package:vibeat/core/errors/failure.dart';
import 'package:vibeat/core/utils/typedef.dart';
import 'package:vibeat/features/favorite/data/datasources/favorite_local_data_source.dart';
import 'package:vibeat/features/favorite/data/datasources/favorite_remote_data_source.dart';
import 'package:vibeat/features/favorite/data/models/beat_model.dart';
import 'package:vibeat/features/favorite/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  const FavoriteRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final FavoriteRemoteDataSource remoteDataSource;
  final FavoriteLocalDataSource localDataSource;

  @override
  ResultVoid syncRemoteLocalFavoriteBeats() async {
    try {
      final result = await remoteDataSource.getFavoriteBeats();

      Set<String> beatsIds = {};

      for (BeatModel beat in result) {
        beatsIds.add(beat.id);
      }

      await localDataSource.initLocalData(beatIds: beatsIds);

      return const Right(null);
    } on APIException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<BeatModel>> getFavoriteBeats() async {
    try {
      final result = await remoteDataSource.getFavoriteBeats();

      return Right(result);
    } on APIException catch (e) {
      return Left(ApiFailure.fromException(e));
    } on NoInternetException catch (_) {
      return const Left(NoInternetFailure());
    }
  }

  @override
  ResultVoid addToFavorite({required String beatId}) async {
    try {
      final result = await remoteDataSource.addToFavorite(beatId: beatId);

      final result2 = await localDataSource.addToFavorite(beatId: beatId);

      return const Right(null);
    } on APIException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultVoid removeFromFavorite({required String beatId}) async {
    try {
      final result = await remoteDataSource.removeFromFavorite(beatId: beatId);

      final result2 = await localDataSource.removeFromFavorite(beatId: beatId);

      return const Right(null);
    } on APIException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  Either<Failure, bool> isFavorite({required String beatId}) {
    return Right(localDataSource.isFavorite(beatId));
  }
}
