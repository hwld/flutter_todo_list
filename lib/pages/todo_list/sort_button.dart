import 'package:flutter/material.dart';
import 'package:flutter_todo_list/pages/todo_list/todo_list_page.dart';

class SortButton extends StatelessWidget {
  SortButton({
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
