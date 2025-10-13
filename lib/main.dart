import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO App',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => TodoBloc()..add(LoadTodosEvent()),
        child: HomeScreen(),
      ),
    );
  }
}