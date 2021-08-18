import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todo_list_model.dart';
import 'package:flutter_todo_list/pages/todo_editor/todo_form.dart';
import 'package:provider/provider.dart';

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
        onPressed: () {
          context.read<TodoListModel>().addTodo(titleController.text);
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.check,
        ),
      ),
    );
  }
}
