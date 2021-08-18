import 'package:flutter/material.dart';
import 'package:flutter_todo_list/pages/todo_editor/todo_editor_page.dart';
import 'package:flutter_todo_list/pages/todo_list/search_bar.dart';
import 'package:flutter_todo_list/pages/todo_list/sort_button.dart';
import 'package:flutter_todo_list/pages/todo_list/todo_list.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? null : const Text('TodoList'),
        actions: [
          if (_isSearching) ...[
            IconButton(
              key: UniqueKey(),
              onPressed: () {
                _changeIsSearching(false);
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
                _changeIsSearching(true);
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
      body: TodoList(
        sortOrder: _todoSortOrder,
        filter: _todoFilter,
        searchText: _searchText,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _changeSearchText('');
          _controller.clear();
          _changeIsSearching(false);
          await Navigator.pushNamed(context, TodoEditorPage.route);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
