import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection.dart';
import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'bloc/theme_bloc.dart';
import 'bloc/theme_state.dart';
import 'screens/page1.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependency injection
  await setupDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide ThemeBloc
        BlocProvider<ThemeBloc>(
          create: (context) => getIt<ThemeBloc>(),
        ),
        // Provide TodoBloc
        BlocProvider<TodoBloc>(
          create: (context) => getIt<TodoBloc>()..add(LoadTodosEvent()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'TODO App',
            theme: themeState.themeData,
            home: FirstPage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}