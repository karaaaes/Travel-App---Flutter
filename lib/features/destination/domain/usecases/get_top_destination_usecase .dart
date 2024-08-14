import 'package:dartz/dartz.dart';
import 'package:travel_app/core/error/failures.dart';
import 'package:travel_app/features/destination/domain/entities/destination_entity.dart';
import 'package:travel_app/features/destination/domain/repositories/destination_repositories.dart';

class GetTopDestinationUsecase {
  final DestinationRepository _repository;

  GetTopDestinationUsecase(this._repository);

  Future<Either<Failures, List<DestinationEntity>>> call() {
    return _repository.top();
  }
}
