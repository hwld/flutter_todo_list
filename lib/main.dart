import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todoList.dart';
import 'package:flutter_todo_list/pages/edit_task_page.dart';
import 'package:flutter_todo_list/pages/tasks_page.dart';
import 'package:flutter_todo_list/repositories/todo_repository.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbPath = await getDatabasesPath();

  runApp(TodoApp(
    dbPath: dbPath,
  ));
}

class TodoApp extends StatelessWidget {
  const TodoApp({
    Key? key,
    required this.dbPath,
  }) : super(key: key);

  final String dbPath;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoList>(
      create: (context) {
        return TodoList(
          todoRepository: TodoRepository(dbPath: dbPath),
        )..loadTodos();
      },
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const TasksPage(),
          '/edit': (context) => const EditTaskPage(),
        },
      ),
    );
  }
}
