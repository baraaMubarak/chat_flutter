import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

abstract class Failure extends Equatable {}

class OfflineFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final String message;

  ServerFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class EmptyCacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmailIsNotVerifiedFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class NoUserFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class UnexpectedFailure extends Failure {
  @override
  List<Object?> get props => [];

  UnexpectedFailure({required Object error}) {
    Logger().e(error);
  }
}
