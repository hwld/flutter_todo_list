import 'package:flutter/material.dart';
import 'package:flutter_todos/models/todoList.dart';
import 'package:flutter_todos/pages/edit_task_page.dart';
import 'package:flutter_todos/pages/tasks_page.dart';
import 'package:flutter_todos/repositories/todo_repository.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbPath = await getDatabasesPath();
  print(dbPath);

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
    return ChangeNotifierProvider(
      create: (context) => TodoList(
        todoRepository: TodoRepository(dbPath: dbPath),
      ),
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
