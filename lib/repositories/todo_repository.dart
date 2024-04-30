import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/todo.dart';

class TodoRepository {
  late SharedPreferences sharedPreferences;

  TodoRepository() {
    SharedPreferences.getInstance().then((sharedPreferences) => this.sharedPreferences = sharedPreferences);
  }

  Future<void> start() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void save(List<Todo> todos) async {
    await sharedPreferences.setString('todos', json.encode(todos));
  }

  List<Todo> getAll() {
    String savedTodos = sharedPreferences.getString('todos') ?? '[]';
    List decodedTodos = json.decode(savedTodos) as List;

    return decodedTodos.map((todo) => Todo.fromJson(todo)).toList();
  }
}
