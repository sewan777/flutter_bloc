import 'package:equatable/equatable.dart';
import '../database/app_database.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object> get props => [];
}

// State 1: Initial state when app starts
class TodoInitialState extends TodoState {}

// State 2: Loading state when fetching data
class TodoLoadingState extends TodoState {}

// State 3: Success state with todo list
class TodoLoadedState extends TodoState {
  final List<Todo> todos;

  TodoLoadedState(this.todos);

  @override
  List<Object> get props => [todos];
}

// State 4: Error state when something fails
class TodoErrorState extends TodoState {
  final String errorMessage;

  TodoErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}