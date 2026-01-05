import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'package:trabalho_sudoku/Quadrado.dart';
import 'package:trabalho_sudoku/vitoriaTela.dart';

class Jogo extends StatefulWidget {
  Jogo(this.jogo, this.nomeJogador);

  Sudoku jogo;
  String nomeJogador;

  @override
  State<Jogo> createState() => _JogoState();
}

class _JogoState extends State<Jogo> {
  var valorPressionado;
  var linhaSelecionada;
  var colunaSelecionada;

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
                    ? ""
                    : mapQuadrados[linha]![coluna].valor.toString()),
              ]),
        ));
  }

  bool validarJogada(linha, coluna, valorNovo) {
    int linhaInicialSubGrupo = (linha ~/ 3) * 3;
    int colunaInicialSubGrupo = (coluna ~/ 3) * 3;

    for (var chave in mapQuadrados.keys) {
      if (coluna != chave && mapQuadrados[linha]![chave].valor == valorNovo) {
        return false;
      }
      if (linha != chave && mapQuadrados[chave]![coluna].valor == valorNovo) {
        return false;
      }
      //Verificar se em qual linha se encontra
      bool primeiraLinhaSubGrupo = chave >= 0 && chave < 3;
      bool segundaLinhaSubGrupo = chave >= 3 && chave < 6;
      bool terceiraLinhaSubGrupo = chave >= 6 && chave < 9;

      //Incrementa da primeira linha do subgrupo até a terceira do subgrupo  dependendo do index do for
      int linhaSubGrupo = (linhaInicialSubGrupo + (primeiraLinhaSubGrupo ? 0 : segundaLinhaSubGrupo ? 1 :  2));
      //Incrementa da primeira coluna do subgrupo até a terceira do subgrupo dependendo do index do for
      int colunaSubGrupo = (colunaInicialSubGrupo + (chave % 3));
    /*
      Verificar se está em alguma das linhas do subgrupo E se está verificando um item diferente do inserido 
      E verifica se os valores são iguais
     */
      if ((primeiraLinhaSubGrupo || segundaLinhaSubGrupo || terceiraLinhaSubGrupo) &&
            (linha != linhaSubGrupo || coluna != colunaSubGrupo) &&
          mapQuadrados[linhaSubGrupo]![colunaSubGrupo].valor == valorNovo) {
        return false;
      }
    }
    return true;
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
                  color: Colors.black), // Estilize o texto conforme desejado
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

  validarVitoriaDoUsuario() {
    for (int index = 0; index < widget.jogo.solution.length; index++) {
      int linha = index ~/ 9;
      int coluna = index % 9;
      if (mapQuadrados[linha]![coluna].valor == -1 || mapQuadrados[linha]![coluna].valor != widget.jogo.solution[index]) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    criarControles();
    criarListaDosQuadrados();
  }

  @override
  Widget build(BuildContext context) {
    if (validarVitoriaDoUsuario()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Vitoriatela(widget.nomeJogador)));
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
                bool lugarValidado = estaInserindoValor && validarJogada(linha, coluna, mapQuadrados[linha]![coluna].valor);

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
