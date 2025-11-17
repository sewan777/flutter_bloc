import 'package:get_it/get_it.dart';
import '../database/app_database.dart';
import '../repositories/todo_repository.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../services/notification_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Register Database as Singleton
  getIt.registerSingleton<AppDatabase>(AppDatabase());

  // Register Repository with database dependency
  getIt.registerLazySingleton<TodoRepository>(
        () => TodoRepository(getIt<AppDatabase>()),
  );

  // Register NotificationService as Singleton
  getIt.registerSingleton<NotificationService>(NotificationService());

  // Register BLoC factories (new instance each time)
  getIt.registerFactory<TodoBloc>(
        () => TodoBloc(getIt<TodoRepository>()),
  );

  getIt.registerFactory<ThemeBloc>(
        () => ThemeBloc(),
  );

  getIt.registerFactory<NotificationBloc>(
        () => NotificationBloc(),
  );
}

// Cleanup method for testing or app disposal
Future<void> resetDependencies() async {
  await getIt<AppDatabase>().close();
  getIt<NotificationService>().dispose();
  await getIt.reset();
}