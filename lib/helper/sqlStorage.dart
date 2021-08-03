import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class SqlStore {
  static Future<sql.Database> database(String chatId) async {
    final sqlPath = await sql.getDatabasesPath();
    print('sqlPathIsAt : $sqlPath');
    return await sql.openDatabase(path.join(sqlPath, 'chats.db'),
        onCreate: (db, verion) {
          print('table creating');
          return db.execute(
              'CREATE TABLE $chatId(messageId TEXT PRIMARY KEY,messageText TEXT);');
        },
        version: 1,
        onOpen: (db) {
          print('onOpen Called');
          return db.execute(
              'CREATE TABLE IF NOT EXISTS $chatId(messageId TEXT PRIMARY KEY,messageText TEXT);');
        });
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await SqlStore.database(table);
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    print('row inserted $data');
  }

  static Future<void> deleteTable(String tableId) async {
    //drops the frickin table
    final db = await SqlStore.database(tableId);
    try {
      db.execute('drop table $tableId;');
    } catch (errorrrrrrrrr) {
      print(errorrrrrrrrr);
    }
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
    final db = await SqlStore.database(table);
    await db.delete(
      table,
      where: 'messageId = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await SqlStore.database(table);
    return db.query(table);
  }
}
