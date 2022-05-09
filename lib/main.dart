import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

Container DrawBoard() {
  List<Row> board = [];
  List<Container> square = [];

  String boardStartPosition =
      "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
  BoardData boardData = BoardData();
  boardData.SetPosition(boardStartPosition);

  AssetImage whiteKingImg = AssetImage('assets/1x/whiteKingmdpi.png');
  AssetImage whiteQueenImg = AssetImage('assets/1x/whiteQueenmdpi.png');
  AssetImage whiteBishopImg = AssetImage('assets/1x/whiteBishopmdpi.png');
  AssetImage whiteKnightImg = AssetImage('assets/1x/whiteKnightmdpi.png');
  AssetImage whiteRookImg = AssetImage('assets/1x/whiteRookmdpi.png');
  AssetImage whitePawnImg = AssetImage('assets/1x/whitePawnmdpi.png');
  AssetImage blackKingImg = AssetImage('assets/1x/blackKingmdpi.png');
  AssetImage blackQueenImg = AssetImage('assets/1x/blackQueenmdpi.png');
  AssetImage blackBishopImg = AssetImage('assets/1x/blackBishopmdpi.png');
  AssetImage blackKnightImg = AssetImage('assets/1x/blackKnightmdpi.png');
  AssetImage blackRookImg = AssetImage('assets/1x/blackRookmdpi.png');
  AssetImage blackPawnImg = AssetImage('assets/1x/blackPawnmdpi.png');
  AssetImage emptyImg = AssetImage('assets/empty.png');

  int colA = "A".codeUnitAt(0);
  int colH = "H".codeUnitAt(0);

  // generate 64 containers
  // into 8 rows (8*8)
  int row = 7;

  while (row >= 0) {
    // build rows from A8 down to A1
    int col = colA;
    square = []; // reset list
    while (col <= colH) {
      late AssetImage thisPiece;
      String contents = boardData.board[row][col - colA].contents;

      if (contents == "K") thisPiece = whiteKingImg;
      if (contents == "Q") thisPiece = whiteQueenImg;
      if (contents == "R") thisPiece = whiteRookImg;
      if (contents == "B") thisPiece = whiteBishopImg;
      if (contents == "N") thisPiece = whiteKnightImg;
      if (contents == "P") thisPiece = whitePawnImg;

      if (contents == "k") thisPiece = blackKingImg;
      if (contents == "q") thisPiece = blackQueenImg;
      if (contents == "r") thisPiece = blackRookImg;
      if (contents == "b") thisPiece = blackBishopImg;
      if (contents == "n") thisPiece = blackKnightImg;
      if (contents == "p") thisPiece = blackPawnImg;

      if (contents == " ") thisPiece = emptyImg;

      Color color = appThemeData.lightSquare;
      if ((row + col) % 2 != 0) color = appThemeData.darkSquare;

      square.add(
        Container(
            alignment: Alignment.bottomCenter,
            height: appThemeData.squareHeight,
            width: appThemeData.squareWidth,
            color: color,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: thisPiece,
                  height: appThemeData.squareHeight,
                  width: appThemeData.squareWidth,
                ),
              ],
            )),
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

  return Container(
    child: Column(children: board),
  );
}

var appThemeData = AppThemeData();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    appThemeData.darkSquare = Color.fromRGBO(0x99, 0x99, 0xcc, 100);
    appThemeData.lightSquare = Color.fromRGBO(0xdd, 0xdd, 0xff, 100);
    appThemeData.squareHeight = 40;
    appThemeData.squareWidth = 40;

    return MaterialApp(
      theme: appThemeData.materialTheme,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Chess Trainer'),
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
