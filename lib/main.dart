import 'package:flutter/material.dart';
import 'package:chesstrainer/ChessBoard/ChessBoard.dart';
import 'ChessPuzzles.dart';
//import 'package:mongo_dart/mongo_dart.dart';

void main() {
  runApp(const MyApp());
}

class AppData {
  String commonPath = "assets/";
  String puzzlePath = "assets/chessPuzzles/";
  String chessPiecePath = "assets/chessThemes/pieces/set2/";
  String boardTilesPath = "assets/chessThemes/board/set0/";

  late String puzzleFile;

  AppData() {
    puzzleFile = '${puzzlePath}puzzles.csv';
  }

  ThemeData get materialTheme {
    return ThemeData(
      primaryColor: Colors.black,
    );
  }
}

var appData = AppData();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ChessBoard chessBoard = const ChessBoard();
  ChessPuzzles chessPuzzles = ChessPuzzles();
  int count = 0;

  _MyAppState() {
    //DesktopWindow.setWindowSize(const Size(700, 1200));
    //chessBoard.boardSquareSize = Size(20,20);
    chessBoard.resetPosition();
    chessPuzzles.loadPuzzles(appData.puzzleFile);
  }

  void _onClick(String pressed) {
    setState(() {
      if (pressed == 'Next') {
        chessBoard.setPosition(chessPuzzles.getNextPuzzle());
      }
      if (pressed == 'Stop') {
        chessBoard.resetPosition();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appData.materialTheme,
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
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: chessBoard.turnColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Text(
                      "Player 1",
                      textScaleFactor: 1.5,
                    ),
                    const Text(
                      "Player 2",
                      textScaleFactor: 1.5,
                    ),
                  ],
                ),
              ),
              Row(children: const [
                SizedBox(
                  height: 10,
                ),
              ]),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ChessBoard(key: ValueKey(count++)),
                    ],
                  ),
                ],
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "FEN: ${boardData.fen}",
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: <Widget>[
          TextButton(
              onPressed: () => _onClick('Next'),
              child: const Text('New Puzzle')),
          TextButton(
              onPressed: () => _onClick('Stop'), child: const Text('Reset')),
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _onClick('Settings')),
        ],
      ),
    );
  }
}
