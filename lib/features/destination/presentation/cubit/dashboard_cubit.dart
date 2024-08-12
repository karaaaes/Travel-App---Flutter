import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_app/features/destination/presentation/pages/home_page.dart';

class DashboardCubit extends Cubit<int> {
  DashboardCubit() : super(0);

  change(int i) => emit(i);

  final List menuDashboard = [
    ['Home', Icons.home, HomePage()],
    ['Near', Icons.near_me, Center(child: Text('This is near'),)],
    ['Favorite', Icons.favorite, Center(child: Text('This is Favorite'),)],
    ['Profile', Icons.person, Center(child: Text('This is Profile'),)],
  ];

  Widget get getPage => menuDashboard[state][2];
}
