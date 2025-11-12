import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../database/app_database.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;

  TodoBloc(this.todoRepository) : super(TodoInitialState()) {
    // Handle LoadTodosEvent
    on<LoadTodosEvent>((event, emit) async {
      emit(TodoLoadingState());

      try {
        List<Todo> todos = await todoRepository.fetchAllTodos();
        emit(TodoLoadedState(todos));
      } catch (e) {
        emit(TodoErrorState('Cannot load todos'));
      }
    });

    // Handle AddTodoEvent
    on<AddTodoEvent>((event, emit) async {
      if (state is TodoLoadedState) {
        try {
          List<Todo> currentTodos = (state as TodoLoadedState).todos;

          // Create new todo in database
          Todo newTodo = await todoRepository.createNewTodo(event.title);

          // Add to top of list
          List<Todo> updatedTodos = [newTodo, ...currentTodos];

          emit(TodoLoadedState(updatedTodos));
        } catch (e) {
          emit(TodoErrorState('Cannot add todo'));
        }
      }
    });

    // Handle DeleteTodoEvent
    on<DeleteTodoEvent>((event, emit) async {
      if (state is TodoLoadedState) {
        try {
          List<Todo> currentTodos = (state as TodoLoadedState).todos;

          // Delete from database
          await todoRepository.deleteTodoById(event.id);

          // Remove from list
          List<Todo> updatedTodos = currentTodos
              .where((todo) => todo.id != event.id)
              .toList();

          emit(TodoLoadedState(updatedTodos));
        } catch (e) {
          emit(TodoErrorState('Cannot delete todo'));
        }
      }
    });

    // Handle ToggleTodoEvent
    on<ToggleTodoEvent>((event, emit) async {
      if (state is TodoLoadedState) {
        try {
          List<Todo> currentTodos = (state as TodoLoadedState).todos;

          // Toggle in database
          await todoRepository.toggleTodoCompletion(event.id);

          // Update local list
          List<Todo> updatedTodos = currentTodos.map((todo) {
            if (todo.id == event.id) {
              return todo.copyWith(completed: !todo.completed);
            }
            return todo;
          }).toList();

          emit(TodoLoadedState(updatedTodos));
        } catch (e) {
          emit(TodoErrorState('Cannot update todo'));
        }
      }
    });
  }
}