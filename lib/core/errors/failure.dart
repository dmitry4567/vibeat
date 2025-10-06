import 'package:equatable/equatable.dart';
import 'package:vibeat/core/errors/exceptions.dart';

class Failure extends Equatable {
  const Failure({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class ApiFailure extends Failure {
  const ApiFailure({required super.message, required super.statusCode});

  ApiFailure.fromException(APIException exception)
      : this(message: exception.message, statusCode: exception.statusCode);
}

class NoInternetFailure extends Failure {
  const NoInternetFailure()
      : super(
          message: 'No internet connection',
          statusCode: 503,
        );
}
