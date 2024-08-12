import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/destination/presentation/cubit/dashboard_cubit.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: context.watch<DashboardCubit>().getPage,
      // body: BlocBuilder<DashboardCubit, int>(
      //   builder: (context, state){
      //     return context.watch<DashboardCubit>().getPage;
      //   }
      // ),
      bottomNavigationBar: Material(
        elevation: 10,
        child: BlocBuilder<DashboardCubit, int>(
          builder: (context, state) {
            return Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: NavigationBar(
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                  backgroundColor: Colors.white,
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  selectedIndex: state,
                  onDestinationSelected: (value) {
                    context.read<DashboardCubit>().change(value); // Memanggil fungsi change index.
                  },
                  destinations: context.read<DashboardCubit>().menuDashboard.map((e) =>
                    NavigationDestination(
                      icon: Icon(e[1], color: Colors.grey[500]),
                      label: e[0],
                      tooltip: e[0],
                      selectedIcon: Icon(
                        e[1],
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ).toList(),
                ),
            );
          },
        ),
      ),
    );
  }
}