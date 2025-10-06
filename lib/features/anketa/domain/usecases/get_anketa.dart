import 'package:dartz/dartz.dart';
import 'package:vibeat/core/errors/failure.dart';
import 'package:vibeat/core/usercases/usecase.dart';
import 'package:vibeat/features/anketa/domain/entities/anketa_entity.dart';
import 'package:vibeat/features/anketa/domain/repositories/anketa_repositories.dart';

class GetAnketa {
  final AnketaRepository repository;

  GetAnketa(this.repository);

  Future<Either<Failure, List<AnketaEntity>>> call(NoParams params) async {
    return await repository.getAnketa();
  }
}
