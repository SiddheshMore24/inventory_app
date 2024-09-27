import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'product.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();

  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('product.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const String textType = 'TEXT NOT NULL';
    const String doubleType = 'REAL NOT NULL';
    const String integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE product (
  id $idType,
  productName $textType,
  sku $textType,
  price $doubleType,
  quantity $integerType
  )
''');
  }

  Future<int> createProduct(Product product) async {
    final db = await instance.database;
    return await db.insert('product', product.toMap());
  }

  Future<List<Product>> readAllProducts() async {
    final db = await instance.database;
    final result = await db.query('product');

    return result.map((json) => Product.fromMap(json)).toList();
  }

  Future<int> updateProduct(Product product) async {
    final db = await instance.database;

    try {
      return await db.update(
        'product',
        product.toMap(),
        where: 'sku = ?',
        whereArgs: [product.sku],
      );
    } catch (e) {
      print('Error updating product: $e');
      return 0; // Optionally return 0 or handle error accordingly
    }
  }


  Future<int> deleteProduct(String sku) async {
    final db = await instance.database;

    return db.delete(
      'product',
      where: 'sku = ?',
      whereArgs: [sku],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
