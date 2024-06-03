import '/models/book.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('books.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE books ( 
  id $idType, 
  thumbnail $textType,
  title $textType,
  authors $textType,
  description $textType,
  rating $doubleType,
  pageCount $intType,
  language $textType,
  previewLink $textType,
  accessViewStatus $textType
  )
''');
  }

  Future<void> create(Book book) async {
    final db = await instance.database;
    await db.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Book>> readAllBooks() async {
    final db = await instance.database;

    final orderBy = 'id ASC';
    final result = await db.query('books', orderBy: orderBy);

    return result.map((json) => Book.fromMap(json)).toList();
  }

  Future<int> delete(String id) async {
    final db = await instance.database;

    return await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
