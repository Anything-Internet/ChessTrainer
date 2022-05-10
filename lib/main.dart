import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'boardData.dart';
import 'chessPuzzles.dart';

void main() {
  runApp(const MyApp());
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

Column drawChessBoard(BoardData boardData) {
  List<Row> board = [];
  List<Container> square = [];

  AssetImage whiteKingImg = const AssetImage('assets/1x/whiteKingmdpi.png');
  AssetImage whiteQueenImg = const AssetImage('assets/1x/whiteQueenmdpi.png');
  AssetImage whiteBishopImg = const AssetImage('assets/1x/whiteBishopmdpi.png');
  AssetImage whiteKnightImg = const AssetImage('assets/1x/whiteKnightmdpi.png');
  AssetImage whiteRookImg = const AssetImage('assets/1x/whiteRookmdpi.png');
  AssetImage whitePawnImg = const AssetImage('assets/1x/whitePawnmdpi.png');
  AssetImage blackKingImg = const AssetImage('assets/1x/blackKingmdpi.png');
  AssetImage blackQueenImg = const AssetImage('assets/1x/blackQueenmdpi.png');
  AssetImage blackBishopImg = const AssetImage('assets/1x/blackBishopmdpi.png');
  AssetImage blackKnightImg = const AssetImage('assets/1x/blackKnightmdpi.png');
  AssetImage blackRookImg = const AssetImage('assets/1x/blackRookmdpi.png');
  AssetImage blackPawnImg = const AssetImage('assets/1x/blackPawnmdpi.png');
  AssetImage emptyImg = const AssetImage('assets/empty.png');

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

  return Column(children: board);
}

var appThemeData = AppThemeData();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BoardData boardData = BoardData();
  ChessPuzzles chessPuzzles = ChessPuzzles();

  String boardStartPosition =
      "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
  String puzzleFile = "assets/puzzles.csv";

  _MyAppState() {
    DesktopWindow.setWindowSize(Size(700,1000));

    boardData.SetPosition(boardStartPosition);
    chessPuzzles.loadPuzzles(puzzleFile);
  }

  void _onClick(String Pressed) {
    setState(() {
      if (Pressed == 'Next') boardData.SetPosition(chessPuzzles.getNextPuzzle());
      if (Pressed == 'Stop') boardData.SetPosition(boardStartPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    appThemeData.darkSquare = const Color.fromRGBO(0x99, 0x99, 0xcc, 100);
    appThemeData.lightSquare = const Color.fromRGBO(0xdd, 0xdd, 0xff, 100);
    appThemeData.squareHeight = 40;
    appThemeData.squareWidth = 40;
    Color turnColor = Colors.white;

    if(boardData.playersTurn == "b") turnColor = Colors.black;

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
                  children:  [
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: turnColor,
                        shape: BoxShape.circle,
                      ),),
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
              drawChessBoard(boardData),
            ],
          ),
        ),
        persistentFooterButtons: <Widget>[
          TextButton(
              onPressed: () => _onClick('Next'),
              child: const Text('New Puzzle')),
          TextButton(
              onPressed: () => _onClick('Stop'),
              child: const Text('Reset')),
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _onClick('Settings')),
        ],
      ),
    );
  }
}

// Future testWindowFunctions() async {
//   Size size = await DesktopWindow.getWindowSize();
//   print(size);
//   await DesktopWindow.setWindowSize(Size(700,1000));
//
//   await DesktopWindow.setMinWindowSize(Size(700,800));
//   await DesktopWindow.setMaxWindowSize(Size(800,800));
//
//   await DesktopWindow.resetMaxWindowSize();
//   await DesktopWindow.toggleFullScreen();
//   bool isFullScreen = await DesktopWindow.getFullScreen();
//   await DesktopWindow.setFullScreen(true);
//   await DesktopWindow.setFullScreen(false);
// }
