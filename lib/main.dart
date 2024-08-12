import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/destination/presentation/cubit/dashboard_cubit.dart';
import 'package:travel_app/features/destination/presentation/pages/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DashboardCubit())
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Hello World'),
          ),
        )
      ),
    );
  }
}