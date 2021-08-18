import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todo_list_model.dart';
import 'package:flutter_todo_list/pages/todo_editor/todo_editor_page.dart';
import 'package:flutter_todo_list/pages/todo_list/todo_list_page.dart';
import 'package:flutter_todo_list/repositories/todo_repository.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
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
    return ChangeNotifierProvider<TodoListModel>(
      create: (context) {
        return TodoListModel(
          todoRepository: TodoRepository(dbPath: dbPath),
        )..loadTodos();
      },
      child: MaterialApp(
        initialRoute: TodoListPage.route,
        routes: {
          TodoListPage.route: (context) => const TodoListPage(),
          TodoEditorPage.route: (context) => const TodoEditorPage(),
        },
      ),
    );
  }
}
