import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'photo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('photos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE photos ( 
      id $idType, 
      path $textType
    )
    ''');
  }

  Future<Photo> create(Photo photo) async {
    final db = await instance.database;

    final id = await db.insert('photos', photo.toMap());
    return photo.copy(id: id);
  }

  Future<Photo> readPhoto(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'photos',
      columns: ['id', 'path'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Photo.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Photo>> readAllPhotos() async {
    final db = await instance.database;

    final result = await db.query('photos');

    return result.map((json) => Photo.fromMap(json)).toList();
  }

  Future<int> update(Photo photo) async {
    final db = await instance.database;

    return db.update(
      'photos',
      photo.toMap(),
      where: 'id = ?',
      whereArgs: [photo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'photos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
