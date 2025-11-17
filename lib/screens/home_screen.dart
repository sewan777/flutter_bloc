import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_state.dart';
import '../widgets/custom_button.dart';
import '../database/app_database.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          appBar: AppBar(
            title: Text('My TODO App'),
            backgroundColor: themeState.buttonColor,
            actions: [
              // Notification Icon with Badge
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, notificationState) {
                  return Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                      ),
                      if (notificationState.unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${notificationState.unreadCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              // Theme Toggle
              IconButton(
                icon: Icon(
                  themeState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleDarkModeEvent());
                },
              ),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Add button using CustomButton
                    CustomButton(
                      text: 'Add',
                      onPressed: () {
                        String text = textController.text;
                        if (text.isNotEmpty) {
                          context.read<TodoBloc>().add(AddTodoEvent(text));
                          textController.clear();
                        }
                      },
                      icon: Icons.add,
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
                            CustomButton(
                              text: 'Try Again',
                              onPressed: () {
                                context.read<TodoBloc>().add(LoadTodosEvent());
                              },
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
                              // Tap to toggle completion
                              onTap: () {
                                context.read<TodoBloc>().add(
                                  ToggleTodoEvent(todo.id),
                                );
                              },

                              // Icon based on completion
                              leading: Icon(
                                todo.completed
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: todo.completed
                                    ? themeState.buttonColor
                                    : Colors.grey,
                              ),

                              // Todo title with strikethrough if completed
                              title: Text(
                                todo.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: todo.completed
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
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
      },
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}