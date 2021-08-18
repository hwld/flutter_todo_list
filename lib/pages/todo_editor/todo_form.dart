import 'package:flutter/material.dart';

class TodoForm extends StatelessWidget {
  const TodoForm({
    required this.titleController,
    Key? key,
  }) : super(key: key);

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Todo'),
        ),
      ],
    );
  }
}
