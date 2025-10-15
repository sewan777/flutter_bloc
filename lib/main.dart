import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'repositories/todo_repository.dart';
import 'services/api_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create ApiService
    ApiService apiService = ApiService();

    // Create Repository with ApiService
    TodoRepository todoRepository = TodoRepository(apiService);

    return MaterialApp(
      title: 'TODO App',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        // Pass Repository to BLoC
        create: (context) => TodoBloc(todoRepository)..add(LoadTodosEvent()),
        child: HomeScreen(),
      ),
    );
  }
}
