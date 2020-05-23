import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'entity/base_entity.dart';

class DBController {
  static final _instance = DBController._internal();
  Database database;

  List<String> _tableCreationQueries;

  factory DBController() {
    return _instance;
  }

  DBController._internal();

  ///get the existing DB connection or create a new one
  Future<Database> getDB() async {
    if (database == null || !database.isOpen) {
      await createDB();
      return Future.value(database);
    } else {
      return Future.value(database);
    }
  }

  Future<void> createDB() async {
    Database database = await openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'food_delivery.db'),
      onCreate: (db, version) {},
      onOpen: (db) {},
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    // Run the CREATE TABLE statement on the database.
    await _createDBTables(_tableCreationQueries, database);
    this.database = database;
    return Future.value();
  }

  ///provide all your entity class objects here to create table before use this DB connection.
  void configureDBEntities(List<BaseEntity> entities) async {
    _tableCreationQueries = List();
    for (BaseEntity entity in entities) {
      _tableCreationQueries.add(entity.createTable());
    }
    createDB();
  }

  ///create database tables with given queries
  Future<void> _createDBTables(List<String> dbQueries, Database db) async {
    if (dbQueries.isInvalid()) return Future.value();
    await db.transaction((transaction) async {
      for (String query in dbQueries) {
        await transaction.execute(query);
      }
    });
    return Future.value();
  }
}
