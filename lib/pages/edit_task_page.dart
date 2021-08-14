import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todoList.dart';
import 'package:provider/provider.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditTaskPageState();
  }
}

class _EditTaskPageState extends State<EditTaskPage> {
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
        title: Text('Edit Task'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(30),
          child: _TodoForm(
            titleController: titleController,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.read<TodoList>().addTodo(titleController.text);
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.check,
        ),
      ),
    );
  }
}

class _TodoForm extends StatelessWidget {
  const _TodoForm({
    required this.titleController,
    Key? key,
  }) : super(key: key);
  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Todo'),
            onFieldSubmitted: (value) async {
              await context.read<TodoList>().addTodo(value);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
