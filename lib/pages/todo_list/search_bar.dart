import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
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
