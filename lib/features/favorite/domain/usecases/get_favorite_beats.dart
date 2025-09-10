import 'package:vibeat/core/usercases/usecase.dart';
import 'package:vibeat/core/utils/typedef.dart';
import 'package:vibeat/features/favorite/data/models/beat_model.dart';
import 'package:vibeat/features/favorite/domain/entities/beat.dart';
import 'package:vibeat/features/favorite/domain/repositories/favorite_repository.dart';

class GetFavoriteBeats extends UseCaseWithoutParams<List<Beat>> {
  const GetFavoriteBeats(this._repository);

  final FavoriteRepository _repository;

  @override
  ResultFuture<List<BeatModel>> call() async => _repository.getFavoriteBeats();
}
