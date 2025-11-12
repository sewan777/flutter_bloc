import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Load all todos
class LoadTodosEvent extends TodoEvent {}

// Add new todo
class AddTodoEvent extends TodoEvent {
  final String title;

  AddTodoEvent(this.title);

  @override
  List<Object> get props => [title];
}

// Delete todo
class DeleteTodoEvent extends TodoEvent {
  final int id;

  DeleteTodoEvent(this.id);

  @override
  List<Object> get props => [id];
}

// Toggle todo completion status
class ToggleTodoEvent extends TodoEvent {
  final int id;

  ToggleTodoEvent(this.id);

  @override
  List<Object> get props => [id];
}