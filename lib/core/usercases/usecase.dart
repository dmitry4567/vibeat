import 'package:vibeat/core/utils/typedef.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}


abstract class UseCaseWithParams<Type, Params> {
  const UseCaseWithParams();

  ResultFuture<Type> call(Params params);
}

abstract class UseCaseWithoutParams<Type> {
  const UseCaseWithoutParams();

  ResultFuture<Type> call();
}