import 'package:game_app_practice/gameField.dart';
import 'package:flutter/material.dart';

enum gameState { runing, game_over }

class Game extends StatefulWidget {
  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  gameState game;
  GameField gameField;

  @override
  void initState() {
    gameField = new GameField(sideLength: 4);
    game = gameState.runing;
    gameField.tryAddRandCell();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Material(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanEnd: (details) {
            direction dir = resolveGesture(details.velocity.pixelsPerSecond);
            setState(() {
              gameField.move(dir);
              if (gameField.tryAddRandCell()) game = gameState.game_over;
            });
          },
          child: Center(
            child: game == gameState.game_over
                ? Column(
                    children: <Widget>[
                      Text("Game Over!"),
                      SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () {
                          initState();
                        },
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          gameCell(gameField.getValue(0)),
                          gameCell(gameField.getValue(1)),
                          gameCell(gameField.getValue(2)),
                          gameCell(gameField.getValue(3)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          gameCell(gameField.getValue(4)),
                          gameCell(gameField.getValue(5)),
                          gameCell(gameField.getValue(6)),
                          gameCell(gameField.getValue(7)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          gameCell(gameField.getValue(8)),
                          gameCell(gameField.getValue(9)),
                          gameCell(gameField.getValue(10)),
                          gameCell(gameField.getValue(11)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          gameCell(gameField.getValue(12)),
                          gameCell(gameField.getValue(13)),
                          gameCell(gameField.getValue(14)),
                          gameCell(gameField.getValue(15)),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      );
}

resolveGesture(Offset velocity) {
  print("${velocity.dx} ${velocity.dy}");

  if (velocity.dx.abs() < 100 && velocity.dy.abs() < 100) return direction.none;

  if (velocity.dx.abs() > velocity.dy.abs()) {
    if (velocity.dx > 0) {
      print("right");
      return direction.right;
    } else {
      print("left");
      return direction.left;
    }
  }
  if (velocity.dx.abs() < velocity.dy.abs()) {
    if (velocity.dy < 0) {
      print("up");
      return direction.up;
    } else {
      print("down");
      return direction.down;
    }
  }
}

Widget gameCell(int value) => Container(
      height: 50,
      width: 50,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Center(child: value == 0 ? Text("") : Text(value.toString())),
    );
