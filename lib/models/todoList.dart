import 'package:flutter/material.dart';
import 'package:flutter_todos/repositories/todo_repository.dart';
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isComplete': isComplete,
    };
  }

  String toStrign() {
    return 'Todo{id: $id, title: $title, isComplete: $isComplete}';
  }
}

class TodoList extends ChangeNotifier {
  TodoList({
    required this.todoRepository,
  });

  List<Todo> _items = [];
  final TodoRepository todoRepository;

  Future<List<Todo>> get items async {
    if (_items.length == 0) {
      _items = await todoRepository.todos();
      print(_items);
    }
    return _items;
  }

  Future<void> addTodo(String title) async {
    final todo = Todo(
      id: Uuid().v4(),
      title: title,
      isComplete: false,
    );

    _items.add(todo);
    await todoRepository.insertTodo(todo);

    notifyListeners();
  }

  Future<void> removeTodo(String todoId) async {
    _items.removeWhere((todo) => todo.id == todoId);
    await todoRepository.deleteTodo(todoId);

    notifyListeners();
  }

  Future<void> updateTodo(String todoId, bool isComplete) async {
    Todo todo = _items.firstWhere((todo) => todo.id == todoId);

    todo.isComplete = isComplete;
    await todoRepository.updateTodo(todo);

    notifyListeners();
  }
}
