import 'package:flutter/material.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(30),
          child: _TodoForm(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.check,
        ),
      ),
    );
  }
}

class _TodoForm extends StatefulWidget {
  const _TodoForm({Key? key}) : super(key: key);

  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<_TodoForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(hintText: 'Todo'),
          ),
        ],
      ),
    );
  }
}
