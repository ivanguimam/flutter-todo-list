class Todo {
  String title;
  DateTime dateTime;

  Todo({required this.title, required this.dateTime});

  Todo.fromJson(Map<String, dynamic> jsonTodo):
    dateTime = DateTime.parse(jsonTodo['dateTime']),
    title = jsonTodo['title'];

  @override
  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'title': title,
    };
  }
}
