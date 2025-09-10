import 'package:equatable/equatable.dart';
import 'package:vibeat/core/errors/failure.dart';

class ServerException extends Equatable implements Failure {
  const ServerException({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class APIException extends ServerException {
  const APIException({required super.message, required super.statusCode});
}
