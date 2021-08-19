import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todo_list_model.dart';
import 'package:flutter_todo_list/pages/todo_editor/todo_editor_page.dart';
import 'package:flutter_todo_list/pages/todo_list/search_bar.dart';
import 'package:flutter_todo_list/pages/todo_list/sort_button.dart';
import 'package:flutter_todo_list/pages/todo_list/todo_list.dart';
import 'package:provider/provider.dart';

import 'filter_button.dart';

enum TodoSortOrder { ascByName, ascByDate }
enum TodoFilter { all, active, completed }

class TodoListPage extends StatefulWidget {
  const TodoListPage({
    Key? key,
  }) : super(key: key);

  static const route = '/';

  @override
  State<StatefulWidget> createState() {
    return _TodoListPageState();
  }
}

class _TodoListPageState extends State<TodoListPage> {
  TodoSortOrder _todoSortOrder = TodoSortOrder.ascByDate;
  TodoFilter _todoFilter = TodoFilter.all;
  String _searchText = "";
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

  void _enterSearchMode() {
    setState(() {
      _isSearching = true;
    });
  }

  void _leaveSearchMode() {
    setState(() {
      _isSearching = false;
      _searchText = '';
      _controller.clear();
    });
  }

  void _changeSearchText(String text) {
    setState(() {
      _searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _isSearching ? null : const Text('TodoList'),
          actions: [
            if (_isSearching) ...[
              IconButton(
                key: UniqueKey(),
                onPressed: () {
                  _leaveSearchMode();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                // ここにkeyを指定しないと入力されて再ビルドが起こる度にフォーカスが外れる？
                // SearchBarが再ビルドの度に別のWidgetだと判断されてる？
                key: const ValueKey('searchBar'),
                child: Align(
                  alignment: Alignment.center,
                  child: SearchBar(
                    searchText: _searchText,
                    onChangeSearchText: _changeSearchText,
                    textEditingController: _controller,
                  ),
                ),
              )
            ],
            if (!_isSearching)
              IconButton(
                onPressed: () {
                  _enterSearchMode();
                },
                icon: const Icon(Icons.search),
              ),
            SortButton(
              key: UniqueKey(),
              currentOrder: _todoSortOrder,
              onChangeSortOrder: _changeSortOrder,
            ),
            FilterButton(
              currentFilter: _todoFilter,
              onChangeTodoFilter: _changeTodoFilter,
            ),
          ],
        ),
        body: _PageBody(
          todoSortOrder: _todoSortOrder,
          todoFilter: _todoFilter,
          searchText: _searchText,
        ),
        floatingActionButton: _AddTodoButton(
          leaveSearchMode: _leaveSearchMode,
        ));
  }
}

class _PageBody extends StatelessWidget {
  const _PageBody({
    required this.todoSortOrder,
    required this.todoFilter,
    required this.searchText,
    Key? key,
  }) : super(key: key);

  final TodoSortOrder todoSortOrder;
  final TodoFilter todoFilter;
  final String searchText;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TodoListModel>();

    if (model.isLoading) {
      return const Center(
        child: Text('読込中...'),
      );
    } else if (model.isLoadingError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('読込中にエラーが発生しました。'),
            ElevatedButton(
              onPressed: () {
                //再読み込みボタン
                model.loadTodos();
              },
              child: const Text('再読み込み'),
            ),
          ],
        ),
      );
    }

    return TodoList(
      sortOrder: todoSortOrder,
      filter: todoFilter,
      searchText: searchText,
    );
  }
}

class _AddTodoButton extends StatelessWidget {
  const _AddTodoButton({
    required this.leaveSearchMode,
    Key? key,
  }) : super(key: key);

  final void Function() leaveSearchMode;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TodoListModel>();
    final disabled = model.isLoadingError || model.isLoading;

    return FloatingActionButton(
      backgroundColor: disabled ? Colors.grey : null,
      onPressed: disabled
          ? null
          : () async {
              leaveSearchMode();
              await Navigator.pushNamed(context, TodoEditorPage.route);
            },
      child: const Icon(Icons.add),
    );
  }
}
