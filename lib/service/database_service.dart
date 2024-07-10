import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DataBaseService {
  static final DataBaseService _instance = DataBaseService._internal();
  static Database? _database;

  factory DataBaseService() {
    return _instance;
  }

  DataBaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'product_databse.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
      ean TEXT PRIMARY KEY, 
      description TEXT,
      complement TEXT,
      brand TEXT
      )
      ''');
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('products');
  }
}
