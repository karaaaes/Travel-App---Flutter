import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/common/app_route.dart';
import 'package:travel_app/features/destination/presentation/bloc/all_destination/all_destination_bloc.dart';
import 'package:travel_app/features/destination/presentation/bloc/search_destination/search_destination_bloc.dart';
import 'package:travel_app/features/destination/presentation/bloc/top_destination/top_destination_bloc.dart';
import 'package:travel_app/features/destination/presentation/cubit/dashboard_cubit.dart';
import 'package:travel_app/features/destination/presentation/pages/dashboard.dart';
import 'package:travel_app/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Digunakan untuk melindungi plugin yang ada di init locator
  await initLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DashboardCubit()), // Pendaftaran Menu Bar Bawah
        BlocProvider(create: (_) => locator<AllDestinationBloc>()),
        BlocProvider(create: (_) => locator<TopDestinationBloc>()),
        BlocProvider(create: (_) => locator<SearchDestinationBloc>()), // Pendaftaran Provider yang ada di Injection
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(),
          scaffoldBackgroundColor: Colors.white
        ),
        initialRoute: AppRoute.dashboard,
        onGenerateRoute: AppRoute.onGenerateRoute,
        home: const Dashboard()
      ),
    );
  }
}