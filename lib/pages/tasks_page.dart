import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todo.dart';
import 'package:flutter_todo_list/models/todoList.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          Container(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
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
      body: Consumer<TodoList>(
        builder: (context, todos, child) {
          return FutureBuilder<List<Todo>>(
            future: todos.items,
            builder: (context, snapshot) {
              List<Widget> children = [];

              if (snapshot.hasData) {
                children =
                    snapshot.data!.map((todo) => _Task(todo: todo)).toList();
              } else if (snapshot.hasError) {
                children = [
                  const Text('データを読み込むことができませんでした。'),
                ];
              }

              return ListView(
                padding: EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                  bottom: 80,
                ),
                children: children,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/edit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Task extends StatelessWidget {
  const _Task({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

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
                value: todo.isComplete,
                onChanged: (value) async {
                  await context
                      .read<TodoList>()
                      .updateTodo(todo.id, value ?? false);
                },
              ),
              Expanded(
                child: Text(
                  '${todo.title}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: todo.isComplete
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await context.read<TodoList>().removeTodo(todo.id);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.black54,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
