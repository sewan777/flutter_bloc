import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//load
class LoadTodosEvent extends TodoEvent {}

//new
class AddTodoEvent extends TodoEvent {
  String title;

  AddTodoEvent(this.title);

  @override
  List<Object> get props => [title];
}
//delete
class DeleteTodoEvent extends TodoEvent {
  int id;

  DeleteTodoEvent(this.id);

  @override
  List<Object> get props => [id];
}


