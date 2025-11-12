import 'package:drift/drift.dart';
import '../database/app_database.dart';

class TodoRepository {
  final AppDatabase database;

  TodoRepository(this.database);

  // Fetch all todos from local database
  Future<List<Todo>> fetchAllTodos() async {
    try {
      return await database.getAllTodos();
    } catch (e) {
      print('Repository Error: $e');
      throw Exception('Failed to fetch todos');
    }
  }

  // Create new todo in local database
  Future<Todo> createNewTodo(String title) async {
    try {
      final todoId = await database.insertTodo(
        TodosCompanion.insert(
          title: title,
          completed: const Value(false),
          userId: const Value(1),
        ),
      );

      // Return the newly created todo
      final newTodo = await database.getTodoById(todoId);
      if (newTodo == null) {
        throw Exception('Failed to retrieve created todo');
      }
      return newTodo;
    } catch (e) {
      print('Repository Error: $e');
      throw Exception('Failed to create todo');
    }
  }

  // Delete todo from local database
  Future<void> deleteTodoById(int id) async {
    try {
      await database.deleteTodo(id);
    } catch (e) {
      print('Repository Error: $e');
      throw Exception('Failed to delete todo');
    }
  }

  // Get single todo by id
  Future<Todo?> getTodoById(int id) async {
    try {
      return await database.getTodoById(id);
    } catch (e) {
      print('Repository Error: $e');
      throw Exception('Failed to get todo');
    }
  }

  // Toggle todo completion status
  Future<void> toggleTodoCompletion(int id) async {
    try {
      await database.toggleTodoCompletion(id);
    } catch (e) {
      print('Repository Error: $e');
      throw Exception('Failed to toggle todo');
    }
  }

  // Clear all todos (optional - for testing)
  Future<void> clearAllTodos() async {
    try {
      await database.deleteAllTodos();
    } catch (e) {
      print('Repository Error: $e');
      throw Exception('Failed to clear todos');
    }
  }
}