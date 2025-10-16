import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import 'page1.dart';
import '../models/todo.dart';

class HomeScreen extends StatelessWidget {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My TODO App'),
        backgroundColor: Colors.blue,
        actions: [
          // Refresh button
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<TodoBloc>().add(LoadTodosEvent());
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // Input box to add new todo
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Text field
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Type your todo here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                SizedBox(width: 10),

                // Add button
                ElevatedButton(
                  onPressed: () {
                    String text = textController.text;
                    if (text.isNotEmpty) {
                      context.read<TodoBloc>().add(AddTodoEvent(text));
                      textController.clear();
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),

          // Todo list
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                // Show loading spinner
                if (state is TodoLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                // Show error message
                else if (state is TodoErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 60, color: Colors.red),
                        SizedBox(height: 10),
                        Text(
                          state.errorMessage,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TodoBloc>().add(LoadTodosEvent());
                          },
                          child: Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }
                // Show todo list
                else if (state is TodoLoadedState) {
                  List<Todo> todos = state.todos;

                  if (todos.isEmpty) {
                    return Center(
                      child: Text(
                        'No todos yet!',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      Todo todo = todos[index];

                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                        child: ListTile(
                          // Icon based on completion
                          leading: Icon(
                            todo.completed
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: todo.completed ? Colors.green : Colors.grey,
                          ),

                          // Todo title
                          title: Text(
                            todo.title,
                            style: TextStyle(fontSize: 16),
                          ),

                          // Todo ID
                          subtitle: Text('ID: ${todo.id}'),

                          // Delete button
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              context.read<TodoBloc>().add(
                                DeleteTodoEvent(todo.id),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
                // Default state
                else {
                  return Center(child: Text('Welcome'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
