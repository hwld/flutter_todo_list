import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todo.dart';
import 'package:flutter_todo_list/models/todoList.dart';
import 'package:provider/provider.dart';

enum SortOrder { ascByName, ascByDate }

class TasksPage extends StatefulWidget {
  const TasksPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TasksPageState();
  }
}

class _TasksPageState extends State<TasksPage> {
  SortOrder sortOrder = SortOrder.ascByDate;

  void changeSortOrder(SortOrder order) {
    setState(() {
      sortOrder = order;
    });
  }

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
          PopupMenuButton(
            icon: const Icon(Icons.sort),
            onSelected: (SortOrder order) {
              changeSortOrder(order);
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: SortOrder.ascByName,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('名前順'),
                      if (sortOrder == SortOrder.ascByName)
                        const Icon(
                          Icons.check,
                          color: Colors.black,
                        ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: SortOrder.ascByDate,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('作成順'),
                      if (sortOrder == SortOrder.ascByDate)
                        const Icon(
                          Icons.check,
                          color: Colors.black,
                        ),
                    ],
                  ),
                )
              ];
            },
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: _TaskList(
        sortOrder: sortOrder,
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

class _TaskList extends StatelessWidget {
  _TaskList({
    required this.sortOrder,
    Key? key,
  }) : super(key: key);

  final SortOrder sortOrder;

  @override
  Widget build(BuildContext context) {
    final todos = [...context.watch<TodoList>().items];
    todos.sort((a, b) {
      if (sortOrder == SortOrder.ascByDate) {
        return 0;
      } else if (sortOrder == SortOrder.ascByName) {
        return a.title.compareTo(b.title);
      }
      return 0;
    });

    return ListView.builder(
      padding: EdgeInsets.only(
        top: 20,
        right: 20,
        left: 20,
        bottom: 80,
      ),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return _Task(todo: todos[index]);
      },
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
