class TodoModel {
  String id;
  String title;
  bool isComplete;

  TodoModel({
    required this.id,
    required this.title,
    required this.isComplete,
  });

  TodoModel.copy(TodoModel other)
      : id = other.id,
        title = other.title,
        isComplete = other.isComplete;

  Map<String, Object> toMap() {
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
