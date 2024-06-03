import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseLog {
  static final DatabaseLog _instance = DatabaseLog._internal();
  static Database? _database;

  factory DatabaseLog() {
    return _instance;
  }

  DatabaseLog._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'projek1.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('users', row);
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<Map<String, String>?> getFirstUserInfo() async {
    Database db = await database;
    final List<Map<String, dynamic>> result = await db.query('users');
    if (result.isNotEmpty) {
      return {
        'username': result.first['username'],
        'password': result.first['password']
      };
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllUserInfo() async {
    Database db = await database;
    return await db.query('users');
  }
}