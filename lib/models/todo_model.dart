class TodoModel {
  String id;
  String title;
  bool isComplete;

  TodoModel({
    required this.id,
    required this.title,
    required this.isComplete,
  });

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
