import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'boardData.dart';

void main() {
  runApp(MyApp());
}

class AppThemeData {
  final BorderRadius borderRadius = BorderRadius.circular(8);

  Color darkSquare = Colors.amber;
  Color lightSquare = Colors.white;

  double squareWidth = 50;
  double squareHeight = 50;

  ThemeData get materialTheme {
    return ThemeData(
      primaryColor: Colors.deepPurple,
    );
  }
}


class Square {
  String label = "Hello";
}
class BoardSetup {
  List position = [<Square>[]];

  BoardSetup () {
    position.add([]);
    position[0].add([]);
    position[0][0].label = "";

    print(position);
  }
}

Container DrawBoard() {
  List<Row> board = [];
  List<Container> square = [];

  String boardStartPosition = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
  BoardData boardData = BoardData();
  boardData.SetPosition(boardStartPosition);

  String label = "";
  int colA = "A".codeUnitAt(0);
  int colH = "H".codeUnitAt(0);

  // generate 64 containers
  // into 8 rows (8*8)
  int row = 7;
  int col = colA;

  while (row >= 0) {
    // build rows from A8 down to A1
    int col = colA;
    square = []; // reset list
    while (col <= colH) {
      // label - A1 - A8, B1 - B8, etc.
      // String label = String.fromCharCode(col).toString() + (row + 1).toString();
      String contents = boardData.board[row][col-colA].contents;

      Color color = appThemeData.lightSquare;
      if ((row + col) % 2 != 0) color = appThemeData.darkSquare;

      square.add(
        Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.fromLTRB(0,0,0,0),
          height: appThemeData.squareHeight,
          width: appThemeData.squareWidth,
          color: color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(contents, textScaleFactor: 2,),
          ],
          )
        ),
      );
      col++;
    }
    board.add(
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: square,
      ),
    );
    row--;
  }

  // set pieces

  return Container(
    //margin: const EdgeInsets.all(1.0),
    //padding: const EdgeInsets.all(10.0),
   // width: appThemeData.squareWidth * 9,
    //alignment: Alignment.center,
    // decoration: BoxDecoration(
    //   border: Border.all(color: Colors.blueAccent),
    // ),
    child: Column(children: board),
  );
}

var appThemeData = AppThemeData();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var rowCnt = 3;

    double boxWidth = double.infinity;

    appThemeData.darkSquare = Color.fromRGBO(0x99, 0x99, 0xcc, 100);
    appThemeData.lightSquare = Color.fromRGBO(0xdd, 0xdd, 0xff, 100);
    appThemeData.squareHeight = 40;
    appThemeData.squareWidth = 40;

    return MaterialApp(
      theme: appThemeData.materialTheme,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Chess'),
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Player 1",
                      textScaleFactor: 1.5,
                    ),
                    Text(
                      "Player 2",
                      textScaleFactor: 1.5,
                    ),
                  ],
                ),
              ),
              DrawBoard(),
            ],
          ),
        ),
      ),
    );
  }
}
