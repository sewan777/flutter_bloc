import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../models/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  ApiService apiService = ApiService();

  // Start with initial state
  TodoBloc() : super(TodoInitialState()) {

    // Handle LoadTodosEvent
    on<LoadTodosEvent>((event, emit) async {
      // Show loading
      emit(TodoLoadingState());

      try {
        // Get todos from API
        List<Todo> todos = await apiService.getAllTodos();

        // Show todos
        emit(TodoLoadedState(todos));

      } catch (e) {
        // Show error
        emit(TodoErrorState('Cannot load todos'));
      }
    });

    // Handle AddTodoEvent
    on<AddTodoEvent>((event, emit) async {
      // Only add if we have todos loaded
      if (state is TodoLoadedState) {
        try {
          // Get current todos
          List<Todo> currentTodos = (state as TodoLoadedState).todos;

          // Add new todo via API
          Todo newTodo = await apiService.addNewTodo(event.title);

          // Add new todo to the beginning of list
          List<Todo> updatedTodos = [newTodo, ...currentTodos];

          // Show updated list
          emit(TodoLoadedState(updatedTodos));

        } catch (e) {
          // Show error
          emit(TodoErrorState('Cannot add todo'));
        }
      }
    });

    // Handle DeleteTodoEvent
    on<DeleteTodoEvent>((event, emit) async {
      // Only delete if we have todos loaded
      if (state is TodoLoadedState) {
        try {
          // Get current todos
          List<Todo> currentTodos = (state as TodoLoadedState).todos;

          // Delete from API
          await apiService.removeTodo(event.id);

          // Remove from list
          List<Todo> updatedTodos = [];
          for (Todo todo in currentTodos) {
            if (todo.id != event.id) {
              updatedTodos.add(todo);
            }
          }

          // Show updated list
          emit(TodoLoadedState(updatedTodos));

        } catch (e) {
          // Show error
          emit(TodoErrorState('Cannot delete todo'));
        }
      }
    });


  }
}