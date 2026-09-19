import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maple_tales_task/bloc/nav_cubit/nav_cubit.dart';
import 'package:maple_tales_task/screens/home_screen.dart';

void main() => runApp(const MapleTalesApp());

class MapleTalesApp extends StatelessWidget {
  const MapleTalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maple Tales · Group Modes',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF2E7D32),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<NavCubit>(create: (context) => NavCubit()),
        ],
        child: HomeScreen(),
      ),
    );
  }
}
