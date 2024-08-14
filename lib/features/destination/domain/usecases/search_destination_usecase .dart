import 'package:dartz/dartz.dart';
import 'package:travel_app/core/error/failures.dart';
import 'package:travel_app/features/destination/domain/entities/destination_entity.dart';
import 'package:travel_app/features/destination/domain/repositories/destination_repositories.dart';

class SearchDestinationUsecase {
  final DestinationRepository _repository;

  SearchDestinationUsecase(this._repository);

  Future<Either<Failures, List<DestinationEntity>>> call({required String query}) {
    return _repository.search(query);
  }
}
