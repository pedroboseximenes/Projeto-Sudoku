
import 'Quadrado.dart';

class ValidacoesSudoku{

  static bool validarJogada(int linha, int coluna, int valorNovo, Map<int, List<Quadrado>> mapQuadrados) {
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

      /*
      Incrementa da primeira linha do subgrupo até a terceira do subgrupo  dependendo do index do for */
      int linhaSubGrupo = (linhaInicialSubGrupo + (primeiraLinhaSubGrupo ? 0 : segundaLinhaSubGrupo ? 1 :  2));
      /*
      Incrementa da primeira coluna do subgrupo até a terceira do subgrupo dependendo do index do for
       */
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


  static bool validarVitoriaDoUsuario(Map<int, List<Quadrado>> mapQuadrados, List<int> solucao) {
    for (int index = 0; index < solucao.length; index++) {
      int linha = index ~/ 9;
      int coluna = index % 9;
      if (mapQuadrados[linha]![coluna].valor != solucao[index]) {
        return false;
      }
    }
    return true;
  }

  static bool validarTodosQuadradosPreenchidos(Map<int, List<Quadrado>> mapQuadrados, List<int> solucao) {
    for (int index = 0; index < solucao.length; index++) {
      int linha = index ~/ 9;
      int coluna = index % 9;
      if (mapQuadrados[linha]![coluna].valor == -1) {
        return false;
      }
    }
    return true;
  }
}