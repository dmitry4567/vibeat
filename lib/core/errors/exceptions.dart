import 'package:equatable/equatable.dart';
import 'package:vibeat/core/errors/failure.dart';

class ServerException extends Equatable implements Failure {
  const ServerException({required this.message, required this.statusCode});

  @override
  final String message;
  @override
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class APIException extends ServerException {
  const APIException({required super.message, required super.statusCode});
}

class NoInternetException extends ServerException {
  const NoInternetException()
      : super(
          message: 'No internet connection',
          statusCode: 503,
        );
}
