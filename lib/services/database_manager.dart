import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modele/redacteur.dart';

class DatabaseManager {
  static Database? _database;

  // TODO 1 : getter database qui initialise si besoin
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initialisation();
    return _database!;
  }

  // TODO 2 : méthode d'initialisation (openDatabase + onCreate)
  Future<Database> _initialisation() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'redacteurs.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE redacteurs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            prenom TEXT,
            email TEXT
          )
        ''');
      },
    );
  }

  // TODO 3 : getAllRedacteurs()
  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await database;
    final rows = await db.query('redacteurs');

    return rows.map((row) => Redacteur.fromMap(row)).toList();
  }

  // TODO 4 : insertRedacteur()
  Future<int> insertRedacteur(Redacteur redacteur) async {
    final db = await database;
    return db.insert(
      'redacteurs',
      redacteur.toMap(),
    );
  }

  // TODO 5 : updateRedacteur()
  Future<int> updateRedacteur(Redacteur redacteur) async {
    final db = await database;
    return db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  // TODO 6 : deleteRedacteur()
  Future<int> deleteRedacteur(int id) async {
    final db = await database;
    return db.delete(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}