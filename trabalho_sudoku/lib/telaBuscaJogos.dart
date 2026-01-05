import 'package:flutter/material.dart';
import 'package:trabalho_sudoku_2/bancoDados.dart';
import 'package:trabalho_sudoku_2/dificuldades.dart';

class TelaBuscaJogos extends StatefulWidget {
  const TelaBuscaJogos({super.key});

  @override
  State<TelaBuscaJogos> createState() => _TelaBuscaJogosState();
}

class _TelaBuscaJogosState extends State<TelaBuscaJogos> {
  final BancoDados sudokuRepository = BancoDados();
  List<Map<String, dynamic>> jogos = [];
  //Primeiro define um mapDificuldades
  //{ idDificuldade: boolean (true para apertado ou false para não apertado)
  List<Map<int,bool>> mapDificuldades = [];
  //Uma lista de booleano para o ToggleButtons
  List<bool> dificuldadesSelecionadas = [];

  @override
  void initState() {
    super.initState();
    carregarTodosJogos();
    //Inicializa o map com todos botões TRUE (apertados)
    Dificuldades.values.forEach((dificuldade) => mapDificuldades.add({dificuldade.idDificuldade : true}));
  }


  carregarTodosJogos() async {
    final data = await sudokuRepository.getTodosJogos();

    setState(() {
      jogos = data;
    });
  }

  carregarPorFiltro() async {
    final data = await sudokuRepository.getJogosPorFiltro(mapDificuldades);

    setState(() {
      jogos = data;
    });
}

  clickFiltro(int index) {
    mapDificuldades[index][mapDificuldades[index].keys.first] = !mapDificuldades[index][mapDificuldades[index].keys.first]!;
    carregarPorFiltro();
  }

  @override
  Widget build(BuildContext context) {
    //Pega o mapDificuldades e coloca o booleano armazenado para uma lista de booleana
    dificuldadesSelecionadas = mapDificuldades
        .map((e) => e.values.first)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Histórico dos Jogos')),
      body: Center(
        child: Column(
          children: [
            Text(
              'Filtre por dificuldade',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5,),
            ToggleButtons(
              direction: Axis.horizontal,
              isSelected: dificuldadesSelecionadas,
              onPressed: (int index) {
                setState(() {
                  clickFiltro(index);
                });
              },
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 90.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedColor: Colors.white,
              fillColor: Colors.blue,
              color: Colors.black,
              children: Dificuldades.values.map((dificuldade) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(dificuldade.name, style: TextStyle(fontSize: 15),)
                );
              }).toList(),

            ),
            SizedBox(height: 20,),
            Text(
              'Lista de Jogadores',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8,),
            jogos.isEmpty
                ? Center(child: Text('Nenhum registro encontrado.'))
                : ListView.builder(
              shrinkWrap: true,
              itemCount: jogos.length,
              itemBuilder: (context, index) {
                final jogo = jogos[index];
                return ListTile(
                  title: Text(jogo['name']),
                  subtitle: Text(
                      'Vitórias: ${jogo['QntdVitorias']} - Derrotas: ${jogo['QntdDerrotas']} - último jogo foi: ${jogo['DataMaisRecente']}'),
                );
              },
            ),
          ],
        )
      )
    );
  }
}
