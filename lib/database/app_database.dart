import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Define the Todos table structure
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  IntColumn get userId => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Database class with DAO
@DriftDatabase(tables: [Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // CRUD Operations

  // Get all todos
  Future<List<Todo>> getAllTodos() async {
    return await select(todos).get();
  }

  // Get single todo by id
  Future<Todo?> getTodoById(int id) async {
    return await (select(todos)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Insert new todo
  Future<int> insertTodo(TodosCompanion todo) async {
    return await into(todos).insert(todo);
  }

  // Update todo
  Future<bool> updateTodo(Todo todo) async {
    return await update(todos).replace(todo);
  }

  // Delete todo
  Future<int> deleteTodo(int id) async {
    return await (delete(todos)..where((t) => t.id.equals(id))).go();
  }

  // Toggle completion status
  Future<void> toggleTodoCompletion(int id) async {
    final todo = await getTodoById(id);
    if (todo != null) {
      await (update(todos)..where((t) => t.id.equals(id)))
          .write(TodosCompanion(completed: Value(!todo.completed)));
    }
  }

  // Delete all todos (useful for testing)
  Future<int> deleteAllTodos() async {
    return await delete(todos).go();
  }
}

// Database connection with proper path
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'todos_db.sqlite'));
    return NativeDatabase(file);
  });
}