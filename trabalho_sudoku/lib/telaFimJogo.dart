import 'package:flutter/material.dart';
import 'package:trabalho_sudoku_2/menu.dart';

class telaFimJogo extends StatefulWidget {
  telaFimJogo(this._nomeJogador, this._ehVitoria);

  String _nomeJogador;
  bool _ehVitoria;
  @override
  State<telaFimJogo> createState() => _telaFimJogoState();
}

class _telaFimJogoState extends State<telaFimJogo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._ehVitoria ? "Vitória" : "Derrota"),
          automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
            child: Column(
              children: [
                Text(widget._ehVitoria ? "Parabéns ${widget._nomeJogador}!" : "Tente novamente ${widget._nomeJogador}"),
                Text(widget._ehVitoria ? "Você venceu!" : "Você perdeu!"),
                Text(" Todas informações foram salvas no Banco de Dados"),
                Text("Clique no ícone para recomeçar!"),
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Menu()));
                }
                  , icon: Icon(Icons.restart_alt,
                    size: 28)
                  ),
              ],
            )
        ),
      ),
    );
  }
}