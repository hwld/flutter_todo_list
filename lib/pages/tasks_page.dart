import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todo.dart';
import 'package:flutter_todo_list/models/todoList.dart';
import 'package:provider/provider.dart';

enum TodoSortOrder { ascByName, ascByDate }
enum TodoFilter { all, active, completed }

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
  TodoSortOrder _todoSortOrder = TodoSortOrder.ascByDate;
  TodoFilter _todoFilter = TodoFilter.all;

  void changeSortOrder(TodoSortOrder order) {
    setState(() {
      _todoSortOrder = order;
    });
  }

  void changeTodoFilter(TodoFilter filter) {
    setState(() {
      _todoFilter = filter;
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
            tooltip: '並び順',
            icon: const Icon(Icons.sort),
            onSelected: (TodoSortOrder order) {
              changeSortOrder(order);
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: TodoSortOrder.ascByName,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('名前順'),
                      if (_todoSortOrder == TodoSortOrder.ascByName)
                        const Icon(
                          Icons.check,
                          color: Colors.black,
                        ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: TodoSortOrder.ascByDate,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('作成順'),
                      if (_todoSortOrder == TodoSortOrder.ascByDate)
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
          PopupMenuButton(
              tooltip: '絞り込み',
              icon: const Icon(Icons.filter_alt),
              onSelected: (TodoFilter filter) {
                changeTodoFilter(filter);
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: TodoFilter.all,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('全て'),
                        if (_todoFilter == TodoFilter.all)
                          const Icon(
                            Icons.check,
                            color: Colors.black,
                          ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: TodoFilter.active,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('未完了'),
                        if (_todoFilter == TodoFilter.active)
                          const Icon(
                            Icons.check,
                            color: Colors.black,
                          ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: TodoFilter.completed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('完了'),
                        if (_todoFilter == TodoFilter.completed)
                          const Icon(
                            Icons.check,
                            color: Colors.black,
                          ),
                      ],
                    ),
                  ),
                ];
              }),
        ],
      ),
      body: _TaskList(
        sortOrder: _todoSortOrder,
        filter: _todoFilter,
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
    required this.filter,
    Key? key,
  }) : super(key: key);

  final TodoSortOrder sortOrder;
  final TodoFilter filter;

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoList>().items.where((todo) {
      if (filter == TodoFilter.active) {
        return todo.isComplete == false;
      } else if (filter == TodoFilter.completed) {
        return todo.isComplete == true;
      }
      return true;
    }).toList();

    todos.sort((a, b) {
      if (sortOrder == TodoSortOrder.ascByDate) {
        return 0;
      } else if (sortOrder == TodoSortOrder.ascByName) {
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
    return Dismissible(
      key: ValueKey<String>(todo.id),
      child: Card(
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
                  onChanged: (value) {
                    context
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
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        context.read<TodoList>().removeTodo(todo.id);
      },
    );
  }
}
