import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class ShopDetailsDBHelper {
  static Future<sql.Database> database() async {
    final dbpath = await getExternalStorageDirectory();

    ///final String dbpath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbpath.path, 'shopDetails.db'),
        onCreate: (db, version) {
      db.execute('''CREATE TABLE stock(
             id TEXT PRIMARY KEY,
             title TEXT,
             package TEXT,
             company TEXT,
             batch TEXT,
             mrp REAL,
             ptr REAL,
             rate REAL,
             quantity INTEGER,
             gstPercentage double,
             hsn TEXT,
             barcode TEXT,
             exp TEXT,
             imageUrl TEXT,
             rack TEXT
             )''');
      db.execute('''CREATE TABLE shopdetails(
             title TEXT,
             address TEXT,
             contact TEXT,
             email TEXT,
             gstin TEXT,
             logo TEXT,
             website TEXT,
             dlNo TEXT,
             fYear TEXT)''');
      db.execute('''CREATE TABLE supplier(
            id TEXT PRIMARY KEY,
             title TEXT,
             address TEXT,
             gstin TEXT
             )''');
      db.execute('''CREATE TABLE customer(
            id TEXT PRIMARY KEY,
             title TEXT,
             address TEXT,
             contact TEXT,
             email TEXT,
             gstin TEXT,
             dlno TEXT
             )''');
      db.execute('''CREATE TABLE doctor(
            id TEXT PRIMARY KEY,
             title TEXT
             
             )''');
    }, version: 1);
  }

  static Future<void> insertShop({Map<String, Object> data}) async {
    final db = await ShopDetailsDBHelper.database();
    db.rawQuery('DELETE FROM shopdetails');
    db.insert('shopdetails', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> insertData(
      {String table, Map<String, Object> data}) async {
    final db = await ShopDetailsDBHelper.database();
    print(data.values.toList());
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await ShopDetailsDBHelper.database();
    //print(db.rawQuery('SELECT * FROM shopdetails'));
    return db.rawQuery('SELECT * FROM $table');
    //print(data.values.toList());
  }

  static Future<String> getFYear() async {
    final db = await ShopDetailsDBHelper.database();
    var output = await db.rawQuery('SELECT fYear FROM shopdetails');
    print(output[0]['fYear']);
    return output[0]['fYear'];
  }

  static Future<void> deleteData(String id, String table) async {
    final db = await ShopDetailsDBHelper.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
    //await db.rawQuery('DELETE FROM stock WHERE id = $productId');
  }

  static Future<List<Map<String, dynamic>>> search(
      {String table = 'stock', String cat, String searchKey}) async {
    final db = await ShopDetailsDBHelper.database();
    var len = searchKey.length;
    //print('SEARCHDATA');
    if (len != 0) {
      return db.rawQuery('SELECT * FROM $table WHERE $cat LIKE "$searchKey%"');
    }
    return db.rawQuery('SELECT * FROM $table  ORDER BY $cat');
  }

  static Future<List<Map<String, dynamic>>> searchDataByBarcode(
      String barcode) async {
    final db = await ShopDetailsDBHelper.database();
    //print('SEARCHDATA');
    return db.rawQuery('SELECT * FROM stock WHERE barcode = $barcode');
  }

  static Future<void> updateData(
      {String table, String id, Map<String, Object> data}) async {
    final db = await ShopDetailsDBHelper.database();
    db.update(table, data, where: 'id = ?', whereArgs: [id]);
    //print('UPDATEDATA');
  }

  static Future<void> updateQuantity(
      {String id, int quantity, String event}) async {
    final db = await ShopDetailsDBHelper.database();
    if (event == 'purchase')
      db.rawUpdate(
          'UPDATE stock SET quantity=quantity+$quantity WHERE id = ?', ['$id']);
    if (event == 'sale')
      db.rawUpdate(
          'UPDATE stock SET quantity=quantity-$quantity WHERE id = ?', ['$id']);
  }
}

class DBHelper {
  static String fYear = '${ShopDetailsDBHelper.getFYear()}.db';

  static Future<sql.Database> database() async {
    //final dbpath = await sql.getDatabasesPath();
    final dbpath = await getExternalStorageDirectory();
    return await sql.openDatabase(path.join(dbpath.path, fYear),
        onCreate: (db, version) {
      db.execute('''CREATE TABLE purchasebrief(
             id TEXT,
             supplierId TEXT,
             supplierTitle TEXT,
             invoiceNo TEXT,
             invoiceDate TEXT,
             gstType TEXT,
             date TEXT,
             subtotal REAL,
             taxable REAL,
             discountOverall REAL,
             grandtotal REAL,
             gstValue REAL,
             sgst REAL,
             cgst REAL,
             igst REAL,
             mode TEXT
             )''');
      db.execute('''CREATE TABLE purchasedetails(
             supplierId TEXT,
             supplierTitle TEXT,
             discountOverall REAL,
             mode TEXT,
             invoiceNo TEXT,
             invoiceDate TEXT,
             date TEXT,
             productId TEXT,
             package TEXT,
             title TEXT,
             quantity INEGER,
             mrp REAL,
             ptr REAL,
             rate REAL,
             free INTEGER,
             batch TEXT,
             exp TEXT,
             gstPercentage REAL,
             gstType TEXT,
             cgst REAL,
             sgst REAL,
             igst REAL,
             gstValue REAL,
             taxable REAL,
             total REAL,
             discountSolo REAL,
             company TEXT,
             barcode TEXT,
             hsn TEXT,
             imageUrl TEXT)''');
      db.execute('''CREATE TABLE salebrief(
             invNo INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
             date TEXT,
             doctor TEXT,
             invoice TEXT,
             customerId TEXT,
             customer TEXT,
             address TEXT,
             email TEXT,
             contact TEXT,
             mode TEXT,
             amount REAL,
             discount REAL,
             grandTotal REAL,
             gstValue REAL,
             gstMode TEXT,
             sgst REAL,
             cgst REAL,
             igst REAL,
             gstin TEXT,
             taxable REAL,
             dlno TEXT,
             discountAmount REAL
             )''');
      db.execute('''CREATE TABLE saledetail(
             invNo INTEGER,
             customer TEXT,
             customerId TEXT,
             contact TEXT,
             email TEXT,
             date TEXT,
             productId TEXT,
             saleQuantity INTEGER,
             free INTEGER,
             package TEXT,
             title TEXT,
             mrp REAL,
             ptr REAL,
             rate REAL,
             batch TEXT,
             exp TEXT,
             gstPercentage REAL,
             barcode TEXT,
             company TEXT,
             hsn TEXT,
             amount REAL,
             discountSolo REAL,
             taxable REAL,
             gstValue REAL,
             imageUrl TEXT,
             rack TEXT,
             csgt REAL,
             sgst REAL,
             igst REAL,
             gstMode TEXT
             )''');
    }, version: 1);
  }

  static Future<void> insertData(
      {String table, Map<String, Object> data}) async {
    final db = await DBHelper.database();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

  }

  static Future<List<Map<String, dynamic>>> advanceSearch(
      {String table,
      String mode,
      String to,
      String from,
      String supplier}) async {
    final db = await DBHelper.database();
    if (mode.length != 0) {
      if (supplier.length != 0)
        return db.rawQuery(
            'SELECT * FROM $table WHERE date BETWEEN "$from" AND "$to" AND WHERE mode="$mode" AND supplierTitle="$supplier"');
      return db.rawQuery(
          'SELECT * FROM $table WHERE date BETWEEN "$from" AND "$to"  AND WHERE mode="$mode"');
    }
    if (supplier.length != 0)
      return db.rawQuery(
          'SELECT * FROM $table WHERE date BETWEEN "$from" AND "$to" AND supplierTitle="$supplier"');
    return db
        .rawQuery('SELECT * FROM $table WHERE date BETWEEN "$from" AND "$to" ');

  }

  static Future<List<Map<String, dynamic>>> getData(
      {String table, String key, String col}) async {
    final db = await DBHelper.database();
    //print('READDATA');
    if (key.length == 0) return db.rawQuery('SELECT * FROM $table');
    return db.rawQuery('SELECT * FROM $table WHERE $col LIKE "$key%"');
  }

  static Future<void> deleteData(
      {String table, String id, String searchBy}) async {
    final db = await DBHelper.database();
    db.delete(table, where: '$searchBy = ?', whereArgs: [id]);

  }
}
