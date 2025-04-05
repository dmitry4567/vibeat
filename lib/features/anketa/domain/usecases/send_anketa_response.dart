import 'package:dartz/dartz.dart';
import 'package:vibeat/core/error/failures.dart';
import 'package:vibeat/features/anketa/domain/repositories/anketa_repositories.dart';

class SendAnketaResponse {
  final AnketaRepository repository;

  SendAnketaResponse(this.repository);

  Future<Either<Failure, String>> call(String genres) async {
    return await repository.sendAnketaResponse(genres);
  }
}