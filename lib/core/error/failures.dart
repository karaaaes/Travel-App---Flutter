// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  final String message;

  const Failures({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failures {
  ServerFailure({required super.message});
}

class ConnectionFailure extends Failures {
  ConnectionFailure({required super.message});
}

class TimeoutFailure extends Failures {
  TimeoutFailure({required super.message});
}

class CacheFailure extends Failures {
  CacheFailure({required super.message});
}

class NotFoundFailure extends Failures {
  NotFoundFailure({required super.message});
}
