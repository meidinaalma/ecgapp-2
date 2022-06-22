import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haloecg/cubit/jantung_cubit.dart';
import 'package:haloecg/pages/Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: ((context) => JantungCubit()),
        ),
      ],
      child: MaterialApp(
        home: Login(),
      ),
    );
  }
}
