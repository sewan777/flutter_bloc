import 'package:dio/dio.dart';
import '../models/todo.dart';

class ApiService {
  Dio dio = Dio();
  String url = 'https://jsonplaceholder.typicode.com';

  // GET - Get all todos from API
  Future<List<Todo>> getAllTodos() async {
    try {
      Response response = await dio.get('$url/todos');

      // Convert JSON list to Todo list
      List<Todo> todos = [];
      for (var json in response.data) {
        todos.add(Todo.fromJson(json));
      }

      // Return only first 10 todos
      return todos.take(10).toList();

    } catch (e) {
      throw Exception('Failed to get todos');
    }
  }

  // POST - Create a new todo
  Future<Todo> addNewTodo(String title) async {
    try {
      Response response = await dio.post(
        '$url/todos',
        data: {
          'title': title,
          'completed': false,
          'userId': 1,
        },
      );

      return Todo.fromJson(response.data);

    } catch (e) {
      throw Exception('Failed to add todo');
    }
  }

  // DELETE - Delete a todo
  Future<void> removeTodo(int id) async {
    try {
      await dio.delete('$url/todos/$id');
    } catch (e) {
      throw Exception('Failed to delete todo');
    }
  }

}

