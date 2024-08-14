import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/core/platform/network_info.dart';
import 'package:travel_app/features/destination/data/datasource/destination_local_data_source.dart';
import 'package:travel_app/features/destination/data/datasource/destination_remote_data_source.dart';
import 'package:travel_app/features/destination/data/repositories/destination_repositories.dart';
import 'package:travel_app/features/destination/domain/repositories/destination_repositories.dart';
import 'package:travel_app/features/destination/domain/usecases/get_all_destination_usecase.dart';
import 'package:travel_app/features/destination/domain/usecases/get_top_destination_usecase%20.dart';
import 'package:travel_app/features/destination/domain/usecases/search_destination_usecase%20.dart';
import 'package:travel_app/features/destination/presentation/bloc/all_destination/all_destination_bloc.dart';
import 'package:travel_app/features/destination/presentation/bloc/search_destination/search_destination_bloc.dart';
import 'package:travel_app/features/destination/presentation/bloc/top_destination/top_destination_bloc.dart';

import 'package:http/http.dart' as http;

final locator = GetIt.instance; // Akan otomatis mencari semua turunannya

Future<void> initLocator() async{
  // Bloc
  locator.registerFactory(() => AllDestinationBloc(locator()));
  locator.registerFactory(() => TopDestinationBloc(locator()));
  locator.registerFactory(() => SearchDestinationBloc(locator()));

  // Repository
  locator.registerLazySingleton<DestinationRepository>(() => DestinationRepositoriesImpl(
    networkInfo: locator(), 
    localDataSource: locator(), 
    remoteDataSource: locator(),
  ));

  // UseCase
  locator.registerLazySingleton(() => GetAllDestinationUsecase(locator<DestinationRepository>()));
  locator.registerLazySingleton(() => GetTopDestinationUsecase(locator<DestinationRepository>()));
  locator.registerLazySingleton(() => SearchDestinationUsecase(locator<DestinationRepository>()));

  // Data Source
  locator.registerLazySingleton<DestinationLocalDataSource>(() => DestinationLocalDataSourceImpl(locator()));
  locator.registerLazySingleton<DestinationRemoteDataSource>(() => DestinationRemoteDataSourceImpl(locator()));

  // Platform
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator<Connectivity>()));

  // Eksternal
  final pref = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => pref);
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => Connectivity());
}