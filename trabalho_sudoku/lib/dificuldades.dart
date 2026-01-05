import 'package:sudoku_dart/sudoku_dart.dart';

enum Dificuldades {
  FACIL(0 ,'fácil', Level.easy),
  MEDIO(1, 'médio', Level.medium),
  DIFICIL(2, 'difícil', Level.hard),
  EXTREMO(3, 'extremo', Level.expert);

  final String _textoDificuldade;
  final Level _level;
  final int _idDificuldade;

  get level {
    return _level;
  }

  get idDificuldade {
    return _idDificuldade;
  }

  get textoDificuldade {
    return _textoDificuldade;
  }

  const Dificuldades(this._idDificuldade, this._textoDificuldade, this._level);
}