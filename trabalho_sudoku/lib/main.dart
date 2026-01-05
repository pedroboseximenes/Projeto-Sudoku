import 'package:flutter/material.dart';
import 'package:trabalho_sudoku_2/menu.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(
      MaterialApp(
        title: 'Sudoku',
        debugShowCheckedModeBanner: false,
        home: Menu(),
      )
  );
}

