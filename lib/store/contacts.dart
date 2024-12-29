import 'package:contactsproject/Models/contacts.dart';
import 'package:contactsproject/utils/utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'contacts_database.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts
        (id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        numbers TEXT NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        email TEXT,
        avatar TEXT);
    ''');
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await instance.db;

    final existingContacts = await db.query(
      'contacts',
      where: 'id = ?',
      whereArgs: [contact.id],
    );

    if (existingContacts.isNotEmpty) {
      return await db.update(
        'contacts',
        contact.toMap(),
        where: 'id = ?',
        whereArgs: [contact.id],
      );
    } else {
      return await db.insert('contacts', contact.toMap());
    }
  }

  Future<List<Map<String, dynamic>>> queryAllContacts() async {
    Database db = await instance.db;
    return await db.query('contacts');
  }

  Future<List<Map<String, dynamic>>> queryAllFavContacts() async {
    Database db = await instance.db;
    return await db.query('contacts', where: 'is_favorite = ?', whereArgs: [1]);
  }

  Future<List<Map<String, dynamic>>> queryContact(int id) async {
    Database db = await instance.db;
    return await db.query('contacts', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database db = await instance.db;
    return await db.update('contacts', contact.toMap(),
        where: 'id = ?', whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    Database db = await instance.db;
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> initializeContacts() async {
    for (Contact contact in initialContacts) {
      await insertContact(contact);
    }
  }
}
