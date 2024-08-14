// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:travel_app/core/error/exceptions.dart';
import 'package:travel_app/core/error/failures.dart';
import 'package:travel_app/core/platform/network_info.dart';
import 'package:travel_app/features/destination/data/datasource/destination_local_data_source.dart';
import 'package:travel_app/features/destination/data/datasource/destination_remote_data_source.dart';
import 'package:travel_app/features/destination/domain/entities/destination_entity.dart';
import 'package:travel_app/features/destination/domain/repositories/destination_repositories.dart';

class DestinationRepositoriesImpl extends DestinationRepository {
  final NetworkInfo networkInfo;
  final DestinationLocalDataSource localDataSource;
  final DestinationRemoteDataSource remoteDataSource;
  
  DestinationRepositoriesImpl({
    required this.networkInfo,
    required this.localDataSource,
    required this.remoteDataSource,
  });


  @override
  Future<Either<Failures, List<DestinationEntity>>> all() async {
    bool online = await networkInfo.isConnected();
    if (online) {
      try {
        final results = await remoteDataSource.all();
        await localDataSource.cacheAll(results);
        return Right(results.map((e) => e.toEntity).toList());
      } on TimeoutException {
        return Left(TimeoutFailure(message: 'Timeout. No Response'));
      } on NotFoundException {
        return Left(NotFoundFailure(message: 'Data Not Found'));
      } on ServerException {
        return Left(ServerFailure(message: 'Server Failure'));
      }
    } else {
      try {
        final results = await localDataSource.getAll();
        return Right(results.map((e) => e.toEntity).toList());
      } on CachedException {
        return Left(CacheFailure(message: 'Data is not present'));
      }
    }
  }

  @override
  Future<Either<Failures, List<DestinationEntity>>> search(String query) async {
    try {
      final results = await remoteDataSource.search(query);
      return Right(results.map((e) => e.toEntity).toList());
    } on TimeoutException {
      return Left(TimeoutFailure(message: 'Timeout. No Response'));
    } on NotFoundException {
      return Left(NotFoundFailure(message: 'Data Not Found'));
    } on ServerException {
      return Left(ServerFailure(message: 'Server Failure'));
    } on SocketException {
      return Left(ConnectionFailure(message: 'Failed connect to the network'));
    }
  }

  @override
  Future<Either<Failures, List<DestinationEntity>>> top() async {
    try {
      final results = await remoteDataSource.top();
      return Right(results.map((e) => e.toEntity).toList());
    } on TimeoutException {
      return Left(TimeoutFailure(message: 'Timeout. No Response'));
    } on NotFoundException {
      return Left(NotFoundFailure(message: 'Data Not Found'));
    } on ServerException {
      return Left(ServerFailure(message: 'Server Failure'));
    } on SocketException {
      return Left(ConnectionFailure(message: 'Failed connect to the network'));
    }
  }
}
