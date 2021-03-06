import 'package:flutter/material.dart';
import 'package:flutter_todo_list/pages/todo_list/todo_list_page.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    required this.currentFilter,
    required this.onChangeTodoFilter,
    Key? key,
  }) : super(key: key);

  final TodoFilter currentFilter;
  final void Function(TodoFilter filter) onChangeTodoFilter;

  @override
  Widget build(BuildContext context) {
    const checkIcon = Icon(
      Icons.check,
    );

    return PopupMenuButton(
        tooltip: '絞り込み',
        icon: const Icon(Icons.filter_alt),
        onSelected: (filter) {
          if (filter is TodoFilter) {
            onChangeTodoFilter(filter);
          }
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: TodoFilter.all,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('全て'),
                  if (currentFilter == TodoFilter.all) checkIcon
                ],
              ),
            ),
            PopupMenuItem(
              value: TodoFilter.active,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('未完了'),
                  if (currentFilter == TodoFilter.active) checkIcon
                ],
              ),
            ),
            PopupMenuItem(
              value: TodoFilter.completed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('完了'),
                  if (currentFilter == TodoFilter.completed) checkIcon
                ],
              ),
            ),
          ];
        });
  }
}
