import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class BancoDados {
  _recoverDatabase() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final path = p.join(appDocumentsDir.path, "databases", "banco.db");


    //await databaseFactory.deleteDatabase(path);
    Database db = await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
            version: 2,
            onCreate: (db, version) async {
              String sql = """
          CREATE TABLE sudoku(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL,
              result INTEGER,
              date VARCHAR NOT NULL,
              level INTEGER
            );
          """;

              await db.execute(sql);
            }
        )
    );

    return db;

  }
  Future<int> inserirJogo(Map<String, dynamic> jogo) async {
    final db = await _recoverDatabase();
    return await db.insert('sudoku', jogo);
  }

  Future<List<Map<String, dynamic>>> getTodosJogos() async {
    final db = await _recoverDatabase();

    final result = await db.rawQuery('''
      SELECT
        name,
        MAX(date) AS DataMaisRecente, 
        COUNT(CASE WHEN result = 1 THEN 1 END) AS QntdVitorias,
        COUNT(CASE WHEN result = 0 THEN 1 END) AS QntdDerrotas
      FROM sudoku
      GROUP BY name
    ''');

    return result;
  }



  Future<List<Map<String, dynamic>>> getJogosPorFiltro(List<Map<int,bool>> dificuldadesEscolhidas) async {
    final db = await _recoverDatabase();

    List<int> niveisSelecionados = [];
    for (var mapa in dificuldadesEscolhidas) {
      mapa.forEach((key, value) {
        if (value == true) {
          niveisSelecionados.add(key);
        }
      });
    }

    final result = await db.rawQuery('''
      SELECT name, 
      MAX(date) AS DataMaisRecente, 
      COUNT(CASE WHEN result = 1 THEN 1 END) AS QntdVitorias, 
        COUNT(CASE WHEN result = 0 THEN 1 END) AS QntdDerrotas,
        level 
        FROM sudoku
         WHERE level IN (${niveisSelecionados.join(', ')})
         GROUP BY name
        ''');

    return result;
  }


}