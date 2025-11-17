import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/injection.dart';
import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'bloc/theme_bloc.dart';
import 'bloc/theme_state.dart';
import 'bloc/notification_bloc.dart';
import 'bloc/notification_event.dart';
import 'services/notification_service.dart';
import 'screens/page1.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Setup dependency injection
  await setupDependencies();

  // Initialize notification service
  final notificationService = getIt<NotificationService>();
  await notificationService.initialize();

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
        // Provide NotificationBloc
        BlocProvider<NotificationBloc>(
          create: (context) {
            final bloc = getIt<NotificationBloc>();

            // Listen to notification service
            getIt<NotificationService>().onNotificationReceived = (notification) {
              bloc.add(AddNotificationEvent(notification));
            };

            return bloc;
          },
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