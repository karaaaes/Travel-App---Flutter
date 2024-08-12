import 'dart:convert';

import 'package:travel_app/core/error/exceptions.dart';
import 'package:travel_app/features/destination/data/models/destination_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cacheAllDestination = 'all_destination';

abstract class DestinationLocalDataSource {
  Future<List<DestinationModel>> getAll();
  Future<bool> cacheAll(List<DestinationModel> list);
}

class DestinationLocalDataSourceImpl extends DestinationLocalDataSource {
  final SharedPreferences pref;

  DestinationLocalDataSourceImpl({required this.pref});

  @override
  Future<bool> cacheAll(List<DestinationModel> list) async {
    List<Map<String, dynamic>> listMap = list.map((e) => e.toJson()).toList();
    String allDestination = jsonEncode(listMap);
    return pref.setString(cacheAllDestination, allDestination);
  }

  @override
  Future<List<DestinationModel>> getAll() async {
    String? allDestination = pref.getString(cacheAllDestination);
    if (allDestination != null) {
      List<Map<String, dynamic>> listMap =
          List<Map<String, dynamic>>.from(jsonDecode(allDestination));
      List<DestinationModel> list =
          listMap.map((e) => DestinationModel.fromJson(e)).toList();
      return list;
    }

    throw CachedException();
  }
}
