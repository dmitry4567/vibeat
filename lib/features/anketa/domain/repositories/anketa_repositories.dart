import 'package:dartz/dartz.dart';
import '../entities/anketa_entity.dart';
import '../../../../core/errors/failure.dart';

abstract class AnketaRepository {
  Future<Either<Failure, List<AnketaEntity>>> getAnketa();
  Future<Either<Failure, String>> sendAnketaResponse(String genres);
}
