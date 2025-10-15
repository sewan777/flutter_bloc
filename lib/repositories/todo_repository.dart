import '../services/api_service.dart';
import '../models/todo.dart';

class TodoRepository {
  final ApiService apiService;

  TodoRepository(this.apiService);

  // BLoC calls this instead of calling ApiService directly
  Future<List<Todo>> fetchAllTodos() async {
    try {
      return await apiService.getAllTodos();
    } catch (e) {
      throw Exception('Repository: Failed to fetch todos');
    }
  }

  Future<Todo> createNewTodo(String title) async {
    try {
      return await apiService.addNewTodo(title);
    } catch (e) {
      throw Exception('Repository: Failed to create todo');
    }
  }

  Future<void> deleteTodoById(int id) async {
    try {
      return await apiService.removeTodo(id);
    } catch (e) {
      throw Exception('Repository: Failed to delete todo');
    }
  }
}
