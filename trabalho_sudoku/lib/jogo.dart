import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'package:trabalho_sudoku_2/Quadrado.dart';
import 'package:trabalho_sudoku_2/bancoDados.dart';
import 'package:trabalho_sudoku_2/telaFimJogo.dart';
import 'package:intl/intl.dart';
import 'package:trabalho_sudoku_2/validacoesSudoku.dart';



class Jogo extends StatefulWidget {
  Jogo(this.jogo, this.nomeJogador, this.idDificuldade);

  Sudoku jogo;
  String nomeJogador;
  int idDificuldade;

  @override
  State<Jogo> createState() => _JogoState();
}

class _JogoState extends State<Jogo> {
  var valorPressionado;
  var linhaSelecionada;
  var colunaSelecionada;
  BancoDados sudokuRepository = BancoDados();

  List<Widget> controleJogo = [];
  Map<int, List<Quadrado>> mapQuadrados = {};

  Widget criarCardJogo(linha, coluna) {
    return Container(
        color: mapQuadrados[linha]![coluna].cor,
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(mapQuadrados[linha]![coluna].valor == -1
                    ? "" : mapQuadrados[linha]![coluna].valor.toString()),
              ]),
        ));
  }


  void criarControles() {
    for (int i = 1; i <= 9; i++) {
      controleJogo.add(
        Flexible(
          child: ElevatedButton(
            onPressed: () {
              if(linhaSelecionada != null && colunaSelecionada != null){
                setState(() {
                  mapQuadrados[linhaSelecionada]![colunaSelecionada].valor = i;
                  colunaSelecionada = null;
                  linhaSelecionada = null;
                });
              }
            },
            child: Text(
              i.toString(),
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
            ),
          ),
        ),
      );
    }
    controleJogo.add(
      Flexible(
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.restart_alt,
              size: 28,
            ),
          )),
    );
  }

  void criarListaDosQuadrados() {
    for (int i = 0; i < 9; i++) {
      List<Quadrado> listaQuadrados = [];
      for (int j = 0; j < 9; j++) {
        listaQuadrados.add(Quadrado(
            widget.jogo.puzzle[(i * 9) + j],
            widget.jogo.puzzle[(i * 9) + j] == -1 ? Colors.white : Colors.grey));
      }
      mapQuadrados[i] = listaQuadrados;
    }
  }


  salvarDadosJogadas(bool ehVitoria) {
    final formatoBr = DateFormat('dd/MM/yyyy', 'pt_BR');
    final data =  formatoBr.format(DateTime.now());

    Map<String,dynamic> jogo = {
      'name' : widget.nomeJogador,
      'result': ehVitoria ? 1 : 0,
      'date':data ,
      'level': widget.idDificuldade,
    };

    sudokuRepository.inserirJogo(jogo);
  }

  @override
  void initState() {
    super.initState();
    criarControles();
    criarListaDosQuadrados();
  }

  @override
  Widget build(BuildContext context) {
    if (ValidacoesSudoku.validarTodosQuadradosPreenchidos(mapQuadrados, widget.jogo.solution)) {
      bool ehVitoria = ValidacoesSudoku.validarVitoriaDoUsuario(mapQuadrados, widget.jogo.solution);
      salvarDadosJogadas(ehVitoria);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => telaFimJogo(widget.nomeJogador, ehVitoria)));
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Sudoku Game"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Jogador: ${widget.nomeJogador}",
              style: TextStyle(fontSize: 25),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
                childAspectRatio: 1.40,
              ),
              itemCount: widget.jogo.puzzle.length,
              itemBuilder: (context, index) {
                int linha = index ~/ 9;
                int coluna = index % 9;

                bool fronteiraTopo = linha % 3 == 0;
                bool fronteiraBorda = (linha + 1) % 3 == 0;
                bool fronteiraEsquerda = coluna % 3 == 0;
                bool fronteiraDireita = (coluna + 1) % 3 == 0;

                bool selecionouQuadrado = linhaSelecionada == linha && colunaSelecionada == coluna;
                bool estaInserindoValor = mapQuadrados[linha]![coluna].valor != -1 && widget.jogo.puzzle[index] == -1;
                bool lugarValidado = estaInserindoValor && ValidacoesSudoku.validarJogada(linha, coluna, mapQuadrados[linha]![coluna].valor, mapQuadrados);

                if (estaInserindoValor && lugarValidado) {
                  mapQuadrados[linha]![coluna].cor = Colors.green;
                }
                else if (estaInserindoValor && !lugarValidado) {
                  mapQuadrados[linha]![coluna].cor = Colors.red;
                }

                return Container(
                  decoration: BoxDecoration(
                    border:
                    selecionouQuadrado ? Border.all(width: 2.15, color: Colors.black)
                        : Border(
                      top: fronteiraTopo
                          ? BorderSide(width: 1.5, color: Colors.black)
                          : BorderSide(width: 0.5, color: Colors.blueGrey),
                      bottom: fronteiraBorda
                          ? BorderSide(width: 1.5, color: Colors.black)
                          : BorderSide(width: 0.5, color: Colors.blueGrey),
                      left: fronteiraEsquerda
                          ? BorderSide(width: 1.5, color: Colors.black)
                          : BorderSide(width: 0.5, color: Colors.blueGrey),
                      right: fronteiraDireita
                          ? BorderSide(width: 1.5, color: Colors.black)
                          : BorderSide(width: 0.5, color: Colors.blueGrey),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (widget.jogo.puzzle[index] == -1) {
                        setState(() {
                          linhaSelecionada = linha;
                          colunaSelecionada = coluna;
                        });
                      }
                    },
                    child: criarCardJogo(linha, coluna),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: controleJogo,
          )
        ],
      ),
    );
  }
}
