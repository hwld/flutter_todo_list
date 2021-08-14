class Todo {
  String id;
  String title;
  bool isComplete;

  Todo({
    required this.id,
    required this.title,
    required this.isComplete,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isComplete': isComplete,
    };
  }

  String toStrign() {
    return 'Todo{id: $id, title: $title, isComplete: $isComplete}';
  }
}
