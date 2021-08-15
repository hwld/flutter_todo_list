import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todo.dart';
import 'package:flutter_todo_list/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

class TodoList extends ChangeNotifier {
  TodoList({
    required this.todoRepository,
  });

  final TodoRepository todoRepository;

  List<Todo> _items = [];

  UnmodifiableListView<Todo> get items => UnmodifiableListView(_items);

  Future loadTodos() async {
    _items.addAll(await todoRepository.todos());
    notifyListeners();
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
