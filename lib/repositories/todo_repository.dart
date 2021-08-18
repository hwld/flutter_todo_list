import 'package:flutter_todo_list/models/todo_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoRepository {
  TodoRepository({required String dbPath}) {
    _database = openDatabase(
      join(dbPath, 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE todos(id TEXT PRIMARY KEY, title TEXT, isComplete BOOLEAN)',
        );
      },
      version: 1,
    );
  }

  late Future<Database> _database;

  // todoMapをDB用のmapに変換する
  Map<String, Object> _convertToDBTodoMap(Map<String, Object?> todoMap) {
    return todoMap.map((key, value) {
      if (value == null) {
        throw Exception();
      }

      if (key == 'isComplete') {
        if (value == true) {
          return MapEntry(key, 1);
        } else if (value == false) {
          return MapEntry(key, 0);
        } else {
          throw Exception();
        }
      }

      return MapEntry(key, value);
    });
  }

  Map<String, Object> _convertToTodoMap(Map<String, Object?> todoMap) {
    return todoMap.map((key, value) {
      if (value == null) {
        throw Exception();
      }

      if (key == 'isComplete') {
        if (value == 1) {
          return MapEntry(key, true);
        } else if (value == 0) {
          return MapEntry(key, false);
        } else {
          throw Exception();
        }
      }

      return MapEntry(key, value);
    });
  }

  Future<void> insertTodo(TodoModel todo) async {
    final db = await _database;
    final todoMap = _convertToDBTodoMap(todo.toMap());

    await db.insert(
      'todos',
      todoMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // TODO
  // エラーハンドリング
  Future<List<TodoModel>> todos() async {
    final db = await _database;

    final maps = await db.query('todos___________');

    return List.generate(maps.length, (i) {
      final dbTodoMap = _convertToTodoMap(maps[i]);

      final dbId = dbTodoMap['id'];
      final dbTitle = dbTodoMap['title'];
      final dbIsComplete = dbTodoMap['isComplete'];

      if (dbId is! String || dbTitle is! String || dbIsComplete is! bool) {
        throw Exception();
      }

      return TodoModel(
        id: dbId,
        title: dbTitle,
        isComplete: dbIsComplete,
      );
    });
  }

  Future<void> updateTodo(TodoModel todo) async {
    final db = await _database;
    final todoMap = _convertToDBTodoMap(todo.toMap());

    await db.update(
      'todos',
      todoMap,
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(String id) async {
    final db = await _database;

    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
