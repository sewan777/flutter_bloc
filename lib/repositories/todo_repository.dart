import '../services/api_service.dart';
import '../models/todo.dart';

class TodoRepository {
  final ApiService apiService;

  TodoRepository(this.apiService);

  Future<List<Todo>> fetchAllTodos() async {
    try {
      return await apiService.getAllTodos();
    } catch (e) {
      print('Repository Error: $e');
      throw Exception('Failed to fetch todos');
    }
  }

  Future<Todo> createNewTodo(String title) async {
    try {
      return await apiService.addNewTodo(title);
    } catch (e) {
      print('Repository Error: $e');
      throw Exception('Failed to create todo');
    }
  }

  Future<void> deleteTodoById(int id) async {
    try {
      await apiService.removeTodo(id);
    } catch (e) {
      print('Repository Error: $e');
      throw Exception('Failed to delete todo');
    }
  }
}