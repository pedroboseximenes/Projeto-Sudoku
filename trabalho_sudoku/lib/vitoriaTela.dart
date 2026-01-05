import 'package:flutter/material.dart';
import 'package:trabalho_sudoku/menu.dart';

class Vitoriatela extends StatefulWidget {
  Vitoriatela(this._nomeJogador);

  String _nomeJogador;
  @override
  State<Vitoriatela> createState() => _VitoriatelaState();
}

class _VitoriatelaState extends State<Vitoriatela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vitória"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Text("Parabéns ${widget._nomeJogador}"),
              Text("Clique no ícone para recomeçar!"),
              IconButton(onPressed: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context) => Menu()));
            }
              , icon: Icon(Icons.restart_alt, size: 28,),)
          ],
          )
        ),
      ),
    );
  }
}