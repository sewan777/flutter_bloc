import 'package:equatable/equatable.dart';

// Base event class
abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Event 1: Load all todos
class LoadTodosEvent extends TodoEvent {}

// Event 2: Add a new todo
class AddTodoEvent extends TodoEvent {
  String title;

  AddTodoEvent(this.title);

  @override
  List<Object> get props => [title];
}

// Event 3: Delete a todo
class DeleteTodoEvent extends TodoEvent {
  int id;

  DeleteTodoEvent(this.id);

  @override
  List<Object> get props => [id];
}


