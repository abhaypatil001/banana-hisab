import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart' as models;
import '../models/party.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'banana_hisab.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        party TEXT NOT NULL,
        date TEXT NOT NULL,
        gross_weight REAL,
        rate REAL,
        patti_mode TEXT,
        patti_rate REAL,
        patti_weight REAL,
        net_weight REAL,
        danda_rate REAL,
        danda_weight REAL,
        net_weight_danda REAL,
        amount REAL,
        commission REAL,
        majuri REAL,
        total REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE parties (
        id TEXT PRIMARY KEY,
        name TEXT UNIQUE NOT NULL,
        phone TEXT,
        color_index INTEGER,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  // Transaction operations
  Future<void> insertTransaction(models.Transaction transaction) async {
    final db = await database;
    await db.insert('transactions', transaction.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<models.Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => models.Transaction.fromMap(maps[i]));
  }

  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTransaction(models.Transaction transaction) async {
    final db = await database;
    await db.update('transactions', transaction.toMap(), where: 'id = ?', whereArgs: [transaction.id]);
  }

  // Party operations
  Future<void> insertParty(Party party) async {
    final db = await database;
    await db.insert('parties', party.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Party>> getParties() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('parties', orderBy: 'name ASC');
    return List.generate(maps.length, (i) => Party.fromMap(maps[i]));
  }

  Future<Party?> getPartyByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('parties', where: 'name = ?', whereArgs: [name]);
    if (maps.isEmpty) return null;
    return Party.fromMap(maps.first);
  }

  // Settings operations
  Future<void> saveSetting(String key, String value) async {
    final db = await database;
    await db.insert('settings', {'key': key, 'value': value}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('settings', where: 'key = ?', whereArgs: [key]);
    if (maps.isEmpty) return null;
    return maps.first['value'] as String;
  }

  Future<Map<String, String>> getAllSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('settings');
    return Map.fromEntries(maps.map((m) => MapEntry(m['key'] as String, m['value'] as String)));
  }

  // Clear all data
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('transactions');
    await db.delete('parties');
  }
}
