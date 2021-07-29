import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class SqlStore {
  static Future<sql.Database> database() async {
    final sqlPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(sqlPath, 'chats.db'),
        onCreate: (db, verion) {
      return db.execute(
          'CREATE TABLE user_main_page(id TEXT PRIMARY KEY, title TEXT, text TEXT);');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await SqlStore.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  // static Future<void> update(String table, Note note) async {
  //   final db = await SqlStore.database();
  //   await db.update(
  //     table,
  //     note.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [note.id],
  //   );
  // }

  static Future<void> delete(String table, String id) async {
    final db = await SqlStore.database();
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await SqlStore.database();
    return db.query(table);
  }
}
