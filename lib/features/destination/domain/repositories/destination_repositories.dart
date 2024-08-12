// Ini untuk handle return dari json
import 'package:dartz/dartz.dart';
import 'package:travel_app/core/error/failures.dart';
import 'package:travel_app/features/destination/domain/entities/destination_entity.dart';

abstract class DestinationRepository {
  Future<Either<Failures, List<DestinationEntity>>> all();
  Future<Either<Failures, List<DestinationEntity>>> top();
  Future<Either<Failures, List<DestinationEntity>>> search(String query);
}
