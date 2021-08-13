import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sort),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
          bottom: 80,
        ),
        children: [
          _Task(),
          _Task(),
          _Task(),
          _Task(),
          _Task(),
          _Task(),
          _Task(),
          _Task(),
          _Task(),
          _Task(),
          _Task(),
          _Task(),
          _Task(),
          _Task(),
          _Task(),
          _Task(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/edit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Task extends StatelessWidget {
  const _Task({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 30,
        ),
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (value) {},
              ),
              Expanded(
                child: const Text(
                  'Todoリストを作る',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
