import 'package:news/src/resources/repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';

class NewsDbProvider implements Source, Cache {
  Database db;

  // To  call the Init function in the newsDbProvider instance
  NewsDbProvider() {
    init();
  }

  // Todo: implement fetchTopIds
  @override
  Future<List<int>> fetchTopIds() {
    return null;
  }

  // async in constructor is not allowedConstructor
  // example: NewsDbProvider()async{}

  void init() async {
    // Folder reference
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // We then join the Folder Reference and items.db, which is the actual Save Path
    final path = join(documentsDirectory.path, "items1.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        // Create a new table in the Db
        newDb.execute(
          // Multi-line Strings
          """
            CREATE TABLE Items
              (
                id INTEGER PRIMARY KEY,
                type TEXT,
                by TEXT,
                time INTEGER,
                text TEXT,
                parent INTEGER,
                kids BLOB,
                dead INTEGER,
                deleted INTEGER,
                url TEXT,
                score INTEGER,
                title TEXT,
                descendants INTEGER
              )
          """,
        );
      },
    );
  }

  Future<ItemModel> fetchItem(int id) async {
    // Db Table Query
    final maps = await db.query(
      "Items",
      columns: null,
      where: "id = ?", // ?, is replaced by whereArgs
      whereArgs: [id],
    );

    // if we found at least 1 result in our maps:
    if (maps.length > 0) {
      // return an Item Model
      // we cannot simply reuse the ItemModel class that's why I created another Constructor (ItemModel.fromDb)
      return ItemModel.fromDb(maps.first);
    }

    // otherwise
    return null;
  }

  // We are not waiting for the db.insert to be completed before doing anything else
  // this is the reason why we are not making the function, async.
  Future<int> addItem(ItemModel item) {
    return db.insert(
      "Items",
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> clear() {
    return db.delete('Items');
  }
}

final newsDbProvider = NewsDbProvider();
