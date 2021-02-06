import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for moor to know about the generated code
part 'database.g.dart';

// This will make moor generate a class called "Category" to represent a row in this table.
// By default, "Categorie" would have been used because it only strips away the trailing "s"
// in the table name.
@DataClassName("Category")
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().customConstraint('UNIQUE')();
}

// this will generate a table called "todos" for us. The rows of that table will
// be represented by a class called "Todo".
class Channels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  TextColumn get image => text().withLength(min: 0, max: 2083)();
  TextColumn get link => text().withLength(min: 0, max: 2083)();
  TextColumn get subscribers => text().withLength(min: 0, max: 255)();
  IntColumn get likes => integer()();
  BoolColumn get isLike => boolean()();
  IntColumn get categoryId =>
      integer().customConstraint('NOT NULL REFERENCES categories (id)')();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [Categories, Channels])
class MyDatabase extends _$MyDatabase {
  // we tell the database where to store the data with this constructor
  MyDatabase() : super(_openConnection());

  // loads all todo entries
  Future<List<Category>> get allCategoryEntries => select(categories).get();

  Future updateCategory(Category entry) {
    return update(categories).replace(entry);
  }

  // returns the generated id
  Future<int> addCategory(Category entry) {
    return into(categories).insert(entry);
  }

  Future deleteCategory(Category entry) {
    return (delete(categories)..where((t) => t.id.equals(entry.id))).go();
  }

  // loads all todo entries
  Future<List<Channel>> get allChannelEntries => select(channels).get();

  Future updateChannel(Channel entry) {
    return update(channels).replace(entry);
  }

  // returns the generated id
  Future<int> addChannel(Channel entry) {
    return into(channels).insert(entry);
  }

  Future deleteChannel(Channel entry) {
    return (delete(channels)..where((t) => t.id.equals(entry.id))).go();
  }

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}
