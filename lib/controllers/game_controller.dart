import 'package:get/get.dart';
import 'package:gravityguy/services/database.dart';
import 'package:sqflite/sqflite.dart';

class GameController extends GetxController {
  var score = 0.0.obs;

  Database? db;

  List<Map<dynamic, dynamic>>? scores;
  
  insert() async {
    db = await DatabaseHelper.instance.database;

    Map<String, dynamic> row = {
      DatabaseHelper.columnScore : score.value.floor(),
    };
    await db!.insert(DatabaseHelper.table, row);

    _getData();

    //await db!.delete(DatabaseHelper.table);
  }

  _getData() async {
    scores = await db!.query(DatabaseHelper.table, orderBy: 'score DESC');
    print(scores);
  }
}
