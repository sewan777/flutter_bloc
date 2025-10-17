import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'bloc/theme_bloc.dart';
import 'repositories/todo_repository.dart';
import 'services/api_service.dart';
import 'screens/page1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create instances BEFORE MultiBlocProvider
    final ApiService apiService = ApiService();
    final TodoRepository todoRepository = TodoRepository(apiService);
    final ThemeBloc themeBloc = ThemeBloc();
    final TodoBloc todoBloc = TodoBloc(todoRepository)..add(LoadTodosEvent());

    return MultiBlocProvider(
      providers: [
        
        BlocProvider<ThemeBloc>(create: (context) => themeBloc),
        BlocProvider<TodoBloc>(create: (context) => todoBloc),
      ],
      child: BlocBuilder<ThemeBloc, dynamic>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'TODO App',
            debugShowCheckedModeBanner: false,
            theme: themeState.themeData,
            home: const FirstPage(),
          );
        },
      ),
    );
  }
}
