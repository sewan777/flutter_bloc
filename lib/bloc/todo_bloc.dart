import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../models/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;

  TodoBloc(this.todoRepository) : super(TodoInitialState()) {
    // Handle LoadTodosEvent
    on<LoadTodosEvent>((event, emit) async {
      emit(TodoLoadingState());

      try {
        // Repository handles all the logic
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

          // Repository handles creation
          Todo newTodo = await todoRepository.createNewTodo(event.title);

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

          // Repository handles deletion
          await todoRepository.deleteTodoById(event.id);

          List<Todo> updatedTodos = [];
          for (Todo todo in currentTodos) {
            if (todo.id != event.id) {
              updatedTodos.add(todo);
            }
          }

          emit(TodoLoadedState(updatedTodos));
        } catch (e) {
          emit(TodoErrorState('Cannot delete todo'));
        }
      }
    });
  }
}
