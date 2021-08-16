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

  String _searchText = "";
  bool _isSearching = false;
  TextEditingController _controller = TextEditingController();

  void _changeSortOrder(TodoSortOrder order) {
    setState(() {
      _todoSortOrder = order;
    });
  }

  void _changeTodoFilter(TodoFilter filter) {
    setState(() {
      _todoFilter = filter;
    });
  }

  void _changeIsSearching(bool isSearching) {
    setState(() {
      _isSearching = isSearching;
    });
  }

  void _changeSearchText(String text) {
    setState(() {
      _searchText = text;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _backButton = IconButton(
      onPressed: () {
        _changeIsSearching(false);
      },
      icon: const Icon(Icons.arrow_back),
    );

    final _searchButton = IconButton(
      onPressed: () {
        _changeIsSearching(true);
      },
      icon: const Icon(Icons.search),
    );

    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? null : const Text('Tasks'),
        actions: [
          if (_isSearching) ...[
            _backButton,
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: _SearchBar(
                  searchText: _searchText,
                  onChangeSearchText: _changeSearchText,
                  textEditingController: _controller,
                ),
              ),
            )
          ],
          if (!_isSearching) _searchButton,
          _SortButton(
            currentOrder: _todoSortOrder,
            onChangeSortOrder: _changeSortOrder,
          ),
          _FilterButton(
            currentFilter: _todoFilter,
            onChangeTodoFilter: _changeTodoFilter,
          ),
        ],
      ),
      body: _TaskList(
        sortOrder: _todoSortOrder,
        filter: _todoFilter,
        searchText: _searchText,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _changeSearchText('');
          _controller.clear();
          _changeIsSearching(false);
          await Navigator.pushNamed(context, '/edit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.onChangeSearchText,
    required this.searchText,
    required this.textEditingController,
    Key? key,
  }) : super(key: key);

  final String searchText;
  final void Function(String text) onChangeSearchText;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      onChanged: (value) {
        onChangeSearchText(value);
      },
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
      ),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        filled: true,
        fillColor: Colors.blue[400],
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        hintText: 'Search...',
        hintStyle: const TextStyle(color: Colors.white70),
        suffixIcon: searchText == ''
            ? null
            : Material(
                type: MaterialType.transparency,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(25),
                child: IconButton(
                  onPressed: () {
                    onChangeSearchText('');
                    textEditingController.clear();
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  _SortButton({
    required this.currentOrder,
    required this.onChangeSortOrder,
    Key? key,
  }) : super(key: key);

  final TodoSortOrder currentOrder;
  final void Function(TodoSortOrder order) onChangeSortOrder;

  @override
  Widget build(BuildContext context) {
    const checkIcon = const Icon(
      Icons.check,
      color: Colors.black,
    );

    return PopupMenuButton(
      tooltip: '並び順',
      icon: const Icon(Icons.sort),
      onSelected: (TodoSortOrder order) {
        onChangeSortOrder(order);
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TodoSortOrder.ascByName,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('名前順'),
                if (currentOrder == TodoSortOrder.ascByName) checkIcon
              ],
            ),
          ),
          PopupMenuItem(
            value: TodoSortOrder.ascByDate,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('作成順'),
                if (currentOrder == TodoSortOrder.ascByDate) checkIcon
              ],
            ),
          )
        ];
      },
    );
  }
}

class _FilterButton extends StatelessWidget {
  _FilterButton({
    required this.currentFilter,
    required this.onChangeTodoFilter,
    Key? key,
  }) : super(key: key);

  final TodoFilter currentFilter;
  final void Function(TodoFilter filter) onChangeTodoFilter;

  @override
  Widget build(BuildContext context) {
    const checkIcon = const Icon(
      Icons.check,
      color: Colors.black,
    );

    return PopupMenuButton(
        tooltip: '絞り込み',
        icon: const Icon(Icons.filter_alt),
        onSelected: (TodoFilter filter) {
          onChangeTodoFilter(filter);
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: TodoFilter.all,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('全て'),
                  if (currentFilter == TodoFilter.all) checkIcon
                ],
              ),
            ),
            PopupMenuItem(
              value: TodoFilter.active,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('未完了'),
                  if (currentFilter == TodoFilter.active) checkIcon
                ],
              ),
            ),
            PopupMenuItem(
              value: TodoFilter.completed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('完了'),
                  if (currentFilter == TodoFilter.completed) checkIcon
                ],
              ),
            ),
          ];
        });
  }
}

class _TaskList extends StatelessWidget {
  _TaskList({
    required this.sortOrder,
    required this.filter,
    required this.searchText,
    Key? key,
  }) : super(key: key);

  final TodoSortOrder sortOrder;
  final TodoFilter filter;
  final String searchText;

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoList>().items.where((todo) {
      if (filter == TodoFilter.active) {
        return todo.isComplete == false;
      } else if (filter == TodoFilter.completed) {
        return todo.isComplete == true;
      }
      return true;
    }).where((todo) {
      return todo.title.contains(searchText);
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
