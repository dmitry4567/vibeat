import 'package:dartz/dartz.dart';
import 'package:vibeat/core/errors/failure.dart';
import 'package:vibeat/core/network/network_info.dart';
import 'package:vibeat/features/anketa/data/datasource/anketa_remote_data_sourse.dart';
import 'package:vibeat/features/anketa/domain/entities/anketa_entity.dart';
import 'package:vibeat/features/anketa/domain/repositories/anketa_repositories.dart';

class AnketaRepositoryImpl implements AnketaRepository {
  final AnketaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AnketaRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AnketaEntity>>> getAnketa() async {
    if (await networkInfo.isConnected) {
      try {
        final genres = await remoteDataSource.getAnketa();

        return Right(genres.map((e) => AnketaEntity(text: e.text)).toList());
      } on Failure catch (e) {
        return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return const Left(ApiFailure(message: "Server Error", statusCode: 500));
    }
  }

  @override
  Future<Either<ApiFailure, String>> sendAnketaResponse(String genres) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.sendAnketaResponse(genres);

        return Right(data);
      } on Failure catch (e) {
        return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return const Left(ApiFailure(message: "Server Error", statusCode: 500));
    }
  }
}
