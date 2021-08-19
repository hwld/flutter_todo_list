import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todo_model.dart';
import 'package:flutter_todo_list/repositories/todo_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class TodoListModel extends ChangeNotifier {
  TodoListModel({
    required this.todoRepository,
  });

  final TodoRepository todoRepository;
  final List<TodoModel> _items = [];
  bool isLoading = false;
  bool isLoadingError = false;

  UnmodifiableListView<TodoModel> get items => UnmodifiableListView(_items);

  Future<void> loadTodos() async {
    List<TodoModel> list;
    isLoading = true;
    isLoadingError = false;
    notifyListeners();

    try {
      list = await todoRepository.todos();
    } on DatabaseException {
      isLoadingError = true;
      notifyListeners();
      return;
    } finally {
      isLoading = false;
    }

    _items.addAll(list);
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    final todo = TodoModel(
      id: const Uuid().v4(),
      title: title,
      isComplete: false,
    );

    await todoRepository.insertTodo(todo);
    _items.add(todo);
    notifyListeners();
  }

  Future<void> removeTodo(String todoId) async {
    final todo = _items.firstWhere((todo) => todo.id == todoId);
    _items.remove(todo);
    try {
      await todoRepository.deleteTodo(todoId);
    } on DatabaseException {
      // _itemsから削除したデータをもとに戻す。
      // Dismissbleを使用することを想定し、削除したデータと同じデータと判定されないように新しいデータを作成する
      // Dismissbleでは、TodoModelをkeyに設定する。
      _items.add(TodoModel.copy(todo));
      notifyListeners();
      rethrow;
    }

    notifyListeners();
  }

  Future<void> updateTodo(String todoId, bool isComplete) async {
    TodoModel todo = _items.firstWhere((todo) => todo.id == todoId);

    await todoRepository.updateTodo(todo);
    todo.isComplete = isComplete;

    notifyListeners();
  }
}
