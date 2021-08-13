import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Todo {
  String id;
  String title;
  bool isComplete;

  Todo({
    required this.id,
    required this.title,
    required this.isComplete,
  });
}

class TodoList extends ChangeNotifier {
  List<Todo> items = [];

  void addTodo(String title) {
    final todo = Todo(
      id: Uuid().v4(),
      title: title,
      isComplete: false,
    );
    items.add(todo);
    notifyListeners();
  }

  void removeTodo(String todoId) {
    items.removeWhere((todo) => todo.id == todoId);
    notifyListeners();
  }

  void updateTodo(String todoId, bool isComplete) {
    Todo todo = items.firstWhere((todo) => todo.id == todoId);
    todo.isComplete = isComplete;
    notifyListeners();
  }
}
