import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'package:trabalho_sudoku/jogo.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

enum Dificuldades {
  FACIL('fácil', Level.easy),
  MEDIO('médio', Level.medium),
  DIFICIL('difícil', Level.hard),
  EXTREMO('extremo', Level.expert);

  final String _textoDificuldade;
  final Level _level;

  get level {
    return _level;
  }

  get textoDificuldade {
    return _textoDificuldade;
  }

  const Dificuldades(this._textoDificuldade, this._level);
}

class _MenuState extends State<Menu> {
  TextEditingController _nomeController = TextEditingController();
  Dificuldades? _dificuldade;

  void showToastMessage(String message) => Fluttertoast.showToast(msg: message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sudoku"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),   
        child: Center( 
        child: Column(
          children: [
            TextField(
              obscureText: false,
              keyboardType: TextInputType.text,
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'), 
            ),
            SizedBox(
              height: 50,
            ),
            Text("Escolha a dificuldade"),
            ...Dificuldades.values.map((dificuldade) {
              return RadioListTile<Dificuldades>(
                title: Text(dificuldade.textoDificuldade),
                value: dificuldade,
                groupValue: _dificuldade,
                onChanged: (Dificuldades? value) {
                  setState(() {
                    _dificuldade = value;
                  });
                },
              );
            }).toList(),
            ElevatedButton(onPressed: () {
              if(_nomeController.text.isEmpty || _dificuldade == null) {
                return showToastMessage("Nome ou dificuldade vazios!");
              } else {
                Sudoku sudokuGame = Sudoku.generate(_dificuldade!._level);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Jogo(sudokuGame, _nomeController.text)));
              }
            }, child: const Text("Jogar"))
          ],
        ),
      ),
      ),
    );
  }
}
