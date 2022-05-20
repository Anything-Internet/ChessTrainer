import 'package:chesstrainer/main.dart';
import 'package:flutter/material.dart';
import 'BoardData.dart';
import 'ChessTheme.dart';

ChessTheme chessTheme =
    ChessTheme(appData.chessPiecePath, appData.boardTilesPath);
BoardData boardData = BoardData();

class ChessBoard extends StatefulWidget {
  const ChessBoard({Key? key}) : super(key: key);

  @override
  createState() => _ChessBoardState();

  get turnColor {
    if (boardData.playersTurn == "b") {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  void setPosition(String fen) {
    boardData.setPosition(fen);
  }

  void resetPosition() {
    boardData.resetPosition();
  }
}

class _ChessBoardState extends State<ChessBoard> {
  _ChessBoardState();

  final List<Widget> squares = [];

  @override
  void initState() {
    super.initState();
    drawBoard();
  }

  Widget drawBoard() {
    for (var row = 7; row >= 0; row--) {
      for (var col = 0; col < 8; col++) {
        String contents = boardData.boardDataArray[row][col].contents;
        squares.add(
          BuildSquare(
            contents: contents,
            row: row,
            col: col,
          ),
        );
      }
    }
    return (squares[0]);
  }

  resize() {
    final mediaQueryData = MediaQuery.of(context);
    Size maxSize = mediaQueryData.size;
    double max =
        (maxSize.width > maxSize.height) ? maxSize.height : maxSize.width;
    max = max * 0.65; // patch for Windows app to fit.

    chessTheme.boardSize = Size(max, max);
  }

  @override
  Widget build(BuildContext context) {
    resize();
    return Container(
      width: chessTheme.boardSize.width,
      padding: const EdgeInsets.all(10),
      color: chessTheme.boardBorder,
      alignment: Alignment.topLeft,
      constraints: BoxConstraints(
        maxHeight: chessTheme.boardSize.height,
        maxWidth: chessTheme.boardSize.width,
      ),
      child: GridView.count(
          shrinkWrap: true, crossAxisCount: 8, children: squares),
    );
  }
}

class BuildSquare extends StatefulWidget {
  const BuildSquare({
    Key? key,
    required this.contents,
    required this.row,
    required this.col,
  }) : super(key: key);

  final String contents;
  final int row;
  final int col;

  @override
  createState() => _BuildSquareState(contents: contents, row: row, col: col);
}

class _BuildSquareState extends State<BuildSquare> {
  _BuildSquareState({
    required this.contents,
    required this.row,
    required this.col,
  });

  String contents;
  int row;
  int col;

  catchGesture({row, col}) {
    debugPrint("Gesture: $row $col");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ({contents, row, col});

    ImageProvider thisPiece = chessTheme.chessPiece[contents];
    ImageProvider noPiece = chessTheme.chessPiece[" "];

    ImageProvider squareBg = chessTheme.lightSquare;
    Color squareBgColor = chessTheme.lightSquareColor;

    if ((row + col) % 2 != 0) {
      squareBg = chessTheme.darkSquare;
      squareBgColor = chessTheme.darkSquareColor;
    }

    return GestureDetector(
      //onTap: catchGesture(row: row, col: col),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            //color: squareBgColor,
            image: DecorationImage(
              image: squareBg,
              fit: BoxFit.cover,
            ),
            shape: BoxShape.rectangle,
          ),
          child: Draggable(
            data: [
              contents,
              row,
              col,
            ],
            feedback: Image(
              image: thisPiece,
            ),
            childWhenDragging: Image(
              image: noPiece,
            ),
            child: Image(
              image: thisPiece,
            ),
          ),
        ),
      ),
    );
  }
}
