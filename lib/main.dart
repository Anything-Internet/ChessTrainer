import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'boardData.dart';
import 'chessPuzzles.dart';

void main() {
  runApp(const MyApp());
}

class AppThemeData {
  String commonPath = "assets/";
  String puzzlePath = "assets/";
  String chessPiecePath = "assets/set2_1x/images/";
  String boardTilesPath = "assets/set2_1x/images/";

  String normalStartPosition =
      "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";

  late double squareWidth;
  late double squareHeight;
  late Color darkSquare;
  late Color lightSquare;
  late Color themeColor;

  late AssetImage whiteKing;
  late AssetImage whiteQueen;
  late AssetImage whiteBishop;
  late AssetImage whiteKnight;
  late AssetImage whiteRook;
  late AssetImage whitePawn;
  late AssetImage blackKing;
  late AssetImage blackQueen;
  late AssetImage blackBishop;
  late AssetImage blackKnight;
  late AssetImage blackRook;
  late AssetImage blackPawn;
  late AssetImage noPiece;
  late AssetImage tilePattern;
  late String puzzleFile;

  AppThemeData() {
    squareHeight = squareWidth = 45;
    themeColor = Colors.deepPurple;
    darkSquare = const Color.fromRGBO(0x99, 0x99, 0xcc, 100);
    lightSquare = const Color.fromRGBO(0xee, 0xee, 0xff, 100);
    loadAssets();
  }

  ThemeData get materialTheme {
    return ThemeData(
      primaryColor: themeColor,
    );
  }

  loadAssets() {
    whiteKing = AssetImage(chessPiecePath + 'whiteKing.png');
    whiteQueen = AssetImage(chessPiecePath + 'whiteQueen.png');
    whiteBishop = AssetImage(chessPiecePath + 'whiteBishop.png');
    whiteKnight = AssetImage(chessPiecePath + 'whiteKnight.png');
    whiteRook = AssetImage(chessPiecePath + 'whiteRook.png');
    whitePawn = AssetImage(chessPiecePath + 'whitePawn.png');
    blackKing = AssetImage(chessPiecePath + 'blackKing.png');
    blackQueen = AssetImage(chessPiecePath + 'blackQueen.png');
    blackBishop = AssetImage(chessPiecePath + 'blackBishop.png');
    blackKnight = AssetImage(chessPiecePath + 'blackKnight.png');
    blackRook = AssetImage(chessPiecePath + 'blackRook.png');
    blackPawn = AssetImage(chessPiecePath + 'blackPawn.png');

    noPiece = AssetImage(commonPath + 'empty.png');
    tilePattern = AssetImage(boardTilesPath + 'woodTile.png');

    puzzleFile = puzzlePath + 'puzzles.csv';
  }
}

Column drawChessBoard(BoardData boardData) {
  List<Row> board = [];
  List<Container> square = [];
  // Key and Size of the Text widget
  final _widgetKey = GlobalKey();
  //Size? _widgetSize = _widgetKey.currentContext!.size;
  //appThemeData.squareWidth = (_widgetSize?.width as double) / 10;

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

      if (contents == "K") thisPiece = appThemeData.whiteKing;
      if (contents == "Q") thisPiece = appThemeData.whiteQueen;
      if (contents == "R") thisPiece = appThemeData.whiteRook;
      if (contents == "B") thisPiece = appThemeData.whiteBishop;
      if (contents == "N") thisPiece = appThemeData.whiteKnight;
      if (contents == "P") thisPiece = appThemeData.whitePawn;

      if (contents == "k") thisPiece = appThemeData.blackKing;
      if (contents == "q") thisPiece = appThemeData.blackQueen;
      if (contents == "r") thisPiece = appThemeData.blackRook;
      if (contents == "b") thisPiece = appThemeData.blackBishop;
      if (contents == "n") thisPiece = appThemeData.blackKnight;
      if (contents == "p") thisPiece = appThemeData.blackPawn;

      if (contents == " ") thisPiece = appThemeData.noPiece;

      Color color = appThemeData.lightSquare;
      if ((row + col) % 2 != 0) color = appThemeData.darkSquare;

      square.add(
        Container(
          width: appThemeData.squareHeight,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: appThemeData.tilePattern,
                  opacity: 0.10,
                  fit: BoxFit.cover,
                ),

                //backgroundBlendMode: BlendMode.hardLight,
                gradient: RadialGradient(
                  radius: 0.9,
                  colors: [
                    color.withOpacity(0.3),
                    color,
                  ],
                ),
              ),
              child: Draggable(
                child: Image(
                  image: thisPiece,
                  height: appThemeData.squareHeight,
                  width: appThemeData.squareWidth,
                ),
                feedback: Image(
                  image: thisPiece,
                  height: appThemeData.squareHeight * 1.25,
                  width: appThemeData.squareWidth * 1.25,
                ),
                data: [
                  contents,
                  row,
                  col,
                ],
              ),
            ),
          ),
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

  _MyAppState() {
    DesktopWindow.setWindowSize(const Size(700, 1200));

    boardData.SetPosition(appThemeData.normalStartPosition);
    chessPuzzles.loadPuzzles(appThemeData.puzzleFile);
  }

  void _onClick(String pressed) {
    setState(() {
      if (pressed == 'Next') {
        boardData.SetPosition(chessPuzzles.getNextPuzzle());
      }
      if (pressed == 'Stop') {
        boardData.SetPosition(appThemeData.normalStartPosition);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color turnColor = Colors.white;
    if (boardData.playersTurn == "b") turnColor = Colors.black;

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
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: turnColor,
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
              drawChessBoard(boardData),
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
