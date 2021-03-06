import 'dart:math';

import 'package:flutter/foundation.dart';

enum direction { up, right, down, left, horizontal, vertical, none }

class GameField {
  List _field;
  int _sideLength;

  int get numOfCell => _sideLength * _sideLength;
  int getValue(int num) => _field[num];

  GameField({@required int sideLength}) {
    _sideLength = sideLength;
    _field = new List.generate(numOfCell, (_) => 0);
  }

  bool tryAddRandCell() {
    if (!_field.contains(0)) return false;

    Random rnd = Random();
    int index = rnd.nextInt(numOfCell);
    while (_field[index] != 0) {
      index = rnd.nextInt(numOfCell);
    }
    _field[index] = 2;

    return true;
  }

  void move(direction dir) {
    _shake(dir);
    for (var i = 0; i < _sideLength; i++) {
      List line = getLine(i, dir);
      for (var j = 0; j < _sideLength - 1; j++) {
        if (line[j] == line[j + 1] && line[j] != 0) {
          line[j] *= 2;
          line[j + 1] = 0;
        }
      }
      setLine(i, dir, line);
    }
    _shake(dir);
  }

  void _shake(direction dir) {
    for (var i = 0; i < _sideLength; i++) {
      List line = getLine(i, _lineType(dir));
      line.sort((a, b) {
        if (a == 0 && b != 0) {
          return 1;
        }
        return -1;
      });

      if (_isReversed(dir))
        setLine(i, _lineType(dir), line.reversed.toList());
      else
        setLine(i, _lineType(dir), line);
    }
  }

  List getLine(int index, direction dir) {
    if (_lineType(dir) == direction.horizontal) {
      return _field.sublist(
          index * _sideLength, index * _sideLength + _sideLength);
    }
    if (_lineType(dir) == direction.vertical) {
      List column = [];
      for (var i = 0, j = index; i < _sideLength; i++, j += _sideLength) {
        column.add(_field[j]);
      }
      return column;
    }
    return [];
  }

  void setLine(int index, direction dir, List line) {
    if (_lineType(dir) == direction.horizontal) {
      _field.replaceRange(
          index * _sideLength, index * _sideLength + _sideLength, line);
    }
    if (_lineType(dir) == direction.vertical) {
      for (var i = 0, j = index; i < _sideLength; i++, j += _sideLength) {
        _field[j] = line[i];
      }
    }
  }

  bool _isReversed(direction dir) =>
      dir == direction.right || dir == direction.down ? true : false;

  direction _lineType(direction dir) =>
      dir == direction.left || dir == direction.right || dir==direction.horizontal
          ? direction.horizontal
          : dir == direction.down || dir == direction.up || dir == direction.vertical
              ? direction.vertical
              : direction.none;
}
