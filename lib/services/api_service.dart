import 'package:dio/dio.dart';
import '../models/todo.dart';

class ApiService {
  late Dio dio;

  ApiService() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      sendTimeout: Duration(seconds: 30),
      contentType: 'application/json',
    ));
  }

  Future<List<Todo>> getAllTodos() async {
    try {
      final response = await dio.get('/todos');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Todo> todos = [];

        for (int i = 0; i < data.length && i < 10; i++) {
          todos.add(Todo.fromJson(data[i] as Map<String, dynamic>));
        }

        return todos;
      }

      throw Exception('HTTP ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to get todos: $e');
    }
  }

  Future<Todo> addNewTodo(String title) async {
    try {
      final response = await dio.post(
        '/todos',
        data: {
          'title': title,
          'completed': false,
          'userId': 1,
        },
      );

      if (response.statusCode == 201) {
        return Todo.fromJson(response.data as Map<String, dynamic>);
      }

      throw Exception('HTTP ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to add todo: $e');
    }
  }

  Future<void> removeTodo(int id) async {
    try {
      await dio.delete('/todos/$id');
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }
}