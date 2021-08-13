import 'package:flutter_todos/models/todoList.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoRepository {
  TodoRepository({required String dbPath}) {
    this.database = openDatabase(
      join(dbPath, 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE todos(id TEXT PRIMARY KEY, title TEXT, isComplete BOOLEAN)',
        );
      },
      version: 1,
    );
  }

  late Future<Database> database;

  Future<void> insertTodo(Todo todo) async {
    final db = await database;

    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Todo>> todos() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('todos');

    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        isComplete: maps[i]['isComplete'] == 1 ? true : false,
      );
    });
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;

    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(String id) async {
    final db = await database;

    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
