import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todo_list_model.dart';
import 'package:flutter_todo_list/models/todo_model.dart';
import 'package:flutter_todo_list/pages/todo_list/todo_list_page.dart';
import 'package:provider/provider.dart';

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
    final todos = context.watch<TodoListModel>().items.where((todo) {
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

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<String>(todo.id),
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
                  onChanged: (value) {
                    context
                        .read<TodoListModel>()
                        .updateTodo(todo.id, value ?? false);
                  },
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
      onDismissed: (direction) {
        context.read<TodoListModel>().removeTodo(todo.id);
      },
    );
  }
}
