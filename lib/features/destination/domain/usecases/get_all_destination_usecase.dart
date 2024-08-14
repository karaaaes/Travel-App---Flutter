import 'package:dartz/dartz.dart';
import 'package:travel_app/core/error/failures.dart';
import 'package:travel_app/features/destination/domain/entities/destination_entity.dart';
import 'package:travel_app/features/destination/domain/repositories/destination_repositories.dart';

class GetAllDestinationUsecase {
  final DestinationRepository _repository;

  GetAllDestinationUsecase(this._repository);

  Future<Either<Failures, List<DestinationEntity>>> call() {
    return _repository.all();
  }
}
