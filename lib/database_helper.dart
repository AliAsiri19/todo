import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import './data.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  // instance from this class
  DatabaseHelper._singletonInstance();

  // call it one time only
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._singletonInstance();
    }
    return _databaseHelper;
  }

  String databaseName = 'todo_db.db'; // database name
  String tableName = 'todo_table'; // table name
  //ng columns
  String col_name_id = 'id';
  String col_name_body = 'body';
  String col_name_isCompleted = 'isCompleted';

  // type of sortig
  static String _sorting = 'DESC';

  // flip sorting type when call .
  String flipSorting() {
    if (_sorting == 'DESC') {
      _sorting = 'ASC';
    }else{
      _sorting = "DESC";
    }
    return _sorting;
  }

  // initialize path /open database , create if not created yet.
  Future<Database> initializeDatebase() async {
    // where the mobile may store data.
    Directory directory = await getApplicationDocumentsDirectory();
    // create complete path using directory and path for database .
    String _path = '${directory.path}${databaseName}';
    // open if found , create if not.
    Database todo_database =
        await openDatabase(_path, version: 1, onCreate: _createDatabase);
    return todo_database; // return database opened to caller.
  }

  // Create table of _todo data call by initilizeDatebase if database need table .
  void _createDatabase(Database db, int version) {
    db.execute('CREATE TABLE $tableName ('
        '$col_name_id INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$col_name_body TEXT,'
        '$col_name_isCompleted INTEGER)');
  }

  // Database getter , use to insert/update and delete.
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatebase();
    }
    return _database;
  }

  // Database operations return a List of maps / every map contain item data.
  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    // get database handler
    Database db = await database;
    // query to read all items
    Future<List<Map<String, dynamic>>> result =
        db.rawQuery('SELECT * FROM $tableName ORDER BY $col_name_id $_sorting');
    return result;
  }

  // add new item
  Future<int> addNewTodoItem(Todo item) async {
    Database db = await database;
    return await db.insert(tableName, item.toMap());
  }

  // update one item
  Future<int> updateOldTodoItem(Todo item) async {
    Database db = await database;
    return await db.update(
      tableName,
      item.toMap(),
      where: '$col_name_id=?',
      whereArgs: [item.id]
    );
  }

  // delete one item
  Future<int> deleteTodoItem(int item_Id_tod_Delete) async {
    Database db = await database;
    return await db.rawDelete('DELETE FROM $tableName WHERE $col_name_id = $item_Id_tod_Delete');
  }

  // return all table items as list of Todo
  Future<List<Todo>> getListOfTodo() async{
    List<Map<String,dynamic>> listMaps = await getTodoMapList();
    List<Todo> todoList = List<Todo>();
    listMaps.forEach((item){
        todoList.add(Todo.fromMapObject(item));
    });
    return todoList;
  }

} // ****** End of DatabaseHelper class ********
