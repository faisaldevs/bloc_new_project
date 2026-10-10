import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final int? code;
  final String message;

  const Failure({this.code, required this.message});

  @override
  List<Object?> get props => [code, message];
}

class ConnectionTimeoutFailure extends Failure {
  const ConnectionTimeoutFailure({super.message = "Connection timed out. Try again."});
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({super.message = "No internet connection."});
}

class BadResponseFailure extends Failure {
  const BadResponseFailure({required super.message, required super.code});
}

class CancelFailure extends Failure {
  const CancelFailure({super.message = "Request cancelled."});
}

class BadCertificateFailure extends Failure {
  const BadCertificateFailure({super.message = "Bad certificate."});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = "Something went wrong."});
}
