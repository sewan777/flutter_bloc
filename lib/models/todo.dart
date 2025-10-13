
class Todo {
  int id;
  String title;
  bool completed;


  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });


  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  // This converts Todo object to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}