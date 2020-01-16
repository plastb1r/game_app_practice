import 'package:game_app_practice/gameField.dart';
import 'package:flutter/material.dart';

enum gameState { runing, game_over }

final Map cellColors = {
  0: Color.fromARGB(20, 50, 0, 0),
  2: Color.fromARGB(40, 50, 0, 0),
  4: Color.fromARGB(60, 50, 0, 0),
  8: Color.fromARGB(80, 50, 0, 0),
  16: Color.fromARGB(100, 50, 0, 0),
  32: Color.fromARGB(120, 50, 0, 0),
  64: Color.fromARGB(140, 50, 0, 0),
  128: Color.fromARGB(160, 50, 0, 0),
  256: Color.fromARGB(180, 50, 0, 0),
  512: Color.fromARGB(200, 50, 0, 0),
  1024: Color.fromARGB(220, 50, 0, 0),
  2048: Color.fromARGB(240, 50, 0, 0),
};

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
    newGame();
    super.initState();
  }

  void newGame() {
    gameField = new GameField(sideLength: 4);
    game = gameState.runing;
    gameField.tryAddRandCell();
  }

  @override
  Widget build(BuildContext context) => Material(
        color: Color.fromARGB(255, 240, 240, 240),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanEnd: (details) {
            direction dir = resolveGesture(details.velocity.pixelsPerSecond);
            if (dir == direction.none) return;
            setState(() {
              gameField.move(dir);
              if (!gameField.tryAddRandCell()) game = gameState.game_over;
            });
          },
          child: Center(
            child: game == gameState.game_over
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Game Over!"),
                      SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () => setState(() => newGame()),
                        elevation: 5,
                        color: Colors.grey,
                        child: Text('New game'),
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

Widget gameCell(int value) => Padding(
      padding: EdgeInsets.all(5),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 60,
        width: 60,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: cellColors[value],
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(child: value == 0 ? Text("") : Text(value.toString())),
      ),
    );
