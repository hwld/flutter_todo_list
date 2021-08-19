import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todo_list_model.dart';
import 'package:flutter_todo_list/models/todo_model.dart';
import 'package:flutter_todo_list/pages/todo_list/todo_list_page.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    required this.sortOrder,
    required this.filter,
    required this.searchText,
    Key? key,
  }) : super(key: key);

  final TodoSortOrder sortOrder;
  final TodoFilter filter;
  final String searchText;

  @override
  Widget build(BuildContext context) {
    final listModel = context.watch<TodoListModel>();

    final todos = listModel.items.where((todo) {
      if (filter == TodoFilter.active) {
        return todo.isComplete == false;
      } else if (filter == TodoFilter.completed) {
        return todo.isComplete == true;
      }
      return true;
    }).where((todo) {
      return todo.title.contains(searchText);
    }).toList();

    todos.sort((a, b) {
      if (sortOrder == TodoSortOrder.ascByDate) {
        return 0;
      } else if (sortOrder == TodoSortOrder.ascByName) {
        return a.title.compareTo(b.title);
      }
      return 0;
    });

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 20,
        right: 20,
        left: 20,
        bottom: 80,
      ),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return _TodoItem(todo: todos[index]);
      },
    );
  }
}

class _TodoItem extends StatelessWidget {
  const _TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final TodoModel todo;

  Future<void> _handleUpdateTodo(BuildContext context, bool? isComplete) async {
    if (isComplete == null) {
      return;
    }
    try {
      await context.read<TodoListModel>().updateTodo(todo.id, isComplete);
    } on DatabaseException {
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('データベースエラー'),
          content: const Text('データベースでエラーが発生しました。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _handleRemoveTodo(BuildContext context, String id) async {
    try {
      await context.read<TodoListModel>().removeTodo(todo.id);
    } on DatabaseException {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('データベースエラー'),
          content: const Text('データベースでエラーが発生しました。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<TodoModel>(todo),
      child: Card(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 30,
          ),
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Row(
              children: [
                Checkbox(
                  value: todo.isComplete,
                  onChanged: (value) => _handleUpdateTodo(context, value),
                ),
                Expanded(
                  child: Text(
                    todo.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: todo.isComplete
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      confirmDismiss: (_) async {
        final status = await ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: const Text('Todoを削除しました'),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'もとに戻す',
                  onPressed: () {},
                ),
              ),
            )
            .closed;
        if (status == SnackBarClosedReason.action) {
          return false;
        }
        return true;
      },
      onDismissed: (_) {
        _handleRemoveTodo(context, todo.id);
      },
    );
  }
}
