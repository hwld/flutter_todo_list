import 'package:flutter/material.dart';
import 'package:flutter_todos/pages/edit_task_page.dart';
import 'package:flutter_todos/pages/tasks_page.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const TasksPage(),
        '/edit': (context) => const EditTaskPage(),
      },
    );
  }
}
