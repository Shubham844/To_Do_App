import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Task {
  int? id;
  String title;
  bool isCompleted;

  Task({this.id, required this.title, this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'isCompleted': isCompleted ? 1 : 0};
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}

class TaskProvider with ChangeNotifier {
  late Database _database;
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    _initializeDB();
  }

  Future<void> _initializeDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            isCompleted INTEGER
          )
        ''');
      },
    );

    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final List<Map<String, dynamic>> maps = await _database.query('tasks');
    _tasks = List.generate(
      maps.length,
          (i) => Task.fromMap(maps[i]),
    );
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final taskId = await _database.insert('tasks', task.toMap());
    task.id = taskId;
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await _database.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    _loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadTasks();
  }
}
