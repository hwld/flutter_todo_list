import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todo_list_model.dart';
import 'package:flutter_todo_list/pages/todo_editor/todo_form.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class TodoEditorPage extends StatefulWidget {
  const TodoEditorPage({Key? key}) : super(key: key);

  static const route = '/editor';

  @override
  State<StatefulWidget> createState() {
    return _TodoEditorPageState();
  }
}

class _TodoEditorPageState extends State<TodoEditorPage> {
  final titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<void> _handleAddTodo(BuildContext context) async {
    try {
      await context.read<TodoListModel>().addTodo(titleController.text);
    } on DatabaseException {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('エラー'),
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
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: TodoForm(
            titleController: titleController,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleAddTodo(context),
        child: const Icon(
          Icons.check,
        ),
      ),
    );
  }
}
