import 'package:flutter/material.dart';
import 'package:flutter_todos/models/todoList.dart';
import 'package:flutter_todos/pages/edit_task_page.dart';
import 'package:flutter_todos/pages/tasks_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoList(),
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
