import 'package:flutter/material.dart';
import 'boardData.dart';

class ChessTheme {
  late AssetImage whiteKing;
  late AssetImage whiteQueen;
  late AssetImage whiteRook;
  late AssetImage whiteBishop;
  late AssetImage whiteKnight;
  late AssetImage whitePawn;

  late AssetImage blackKing;
  late AssetImage blackQueen;
  late AssetImage blackRook;
  late AssetImage blackBishop;
  late AssetImage blackKnight;
  late AssetImage blackPawn;

  late AssetImage noPiece;
  late AssetImage lightSquare;
  late AssetImage darkSquare;

  ChessTheme(String chessPiecePath, String boardTilesPath) {
    whiteKing = AssetImage('${chessPiecePath}whiteKing.png');
    whiteQueen = AssetImage('${chessPiecePath}whiteQueen.png');
    whiteBishop = AssetImage('${chessPiecePath}whiteBishop.png');
    whiteKnight = AssetImage('${chessPiecePath}whiteKnight.png');
    whiteRook = AssetImage('${chessPiecePath}whiteRook.png');
    whitePawn = AssetImage('${chessPiecePath}whitePawn.png');
    blackKing = AssetImage('${chessPiecePath}blackKing.png');
    blackQueen = AssetImage('${chessPiecePath}blackQueen.png');
    blackBishop = AssetImage('${chessPiecePath}blackBishop.png');
    blackKnight = AssetImage('${chessPiecePath}blackKnight.png');
    blackRook = AssetImage('${chessPiecePath}blackRook.png');
    blackPawn = AssetImage('${chessPiecePath}blackPawn.png');
    noPiece = AssetImage('${chessPiecePath}nothing.png');
    darkSquare = AssetImage('${boardTilesPath}darkSquare.png');
    lightSquare = AssetImage('${boardTilesPath}lightSquare.png');
  }
}

class ChessBoard extends BoardData {
  late Size boardSquareSize;
  late ChessTheme chessTheme;

  ChessBoard(String chessPiecePath, String boardTilesPath) {
    chessTheme = ChessTheme(chessPiecePath, boardTilesPath);
    boardSquareSize = const Size(50, 50);
  }

  get turnColor {
    if (playersTurn == "b") {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  Column drawChessBoard() {
    List<Row> boardRows = [];
    List<Container> boardSquares = [];

    int colA = "A".codeUnitAt(0);
    int colH = "H".codeUnitAt(0);

    // generate 64 containers
    // into 8 rows (8*8)
    int row = 7;

    while (row >= 0) {
      // build rows from A8 down to A1
      int col = colA;
      boardSquares = []; // reset list
      while (col <= colH) {
        late AssetImage thisPiece;
        String contents = boardDataArray[row][col - colA].contents;

        if (contents == "K") thisPiece = chessTheme.whiteKing;
        if (contents == "Q") thisPiece = chessTheme.whiteQueen;
        if (contents == "R") thisPiece = chessTheme.whiteRook;
        if (contents == "B") thisPiece = chessTheme.whiteBishop;
        if (contents == "N") thisPiece = chessTheme.whiteKnight;
        if (contents == "P") thisPiece = chessTheme.whitePawn;

        if (contents == "k") thisPiece = chessTheme.blackKing;
        if (contents == "q") thisPiece = chessTheme.blackQueen;
        if (contents == "r") thisPiece = chessTheme.blackRook;
        if (contents == "b") thisPiece = chessTheme.blackBishop;
        if (contents == "n") thisPiece = chessTheme.blackKnight;
        if (contents == "p") thisPiece = chessTheme.blackPawn;

        if (contents == " ") thisPiece = chessTheme.noPiece;

        AssetImage squareBg = chessTheme.lightSquare;
        if ((row + col) % 2 != 0) squareBg = chessTheme.darkSquare;

        boardSquares.add(
          Container(
            width: boardSquareSize.width,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: squareBg,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Draggable(
                  feedback: Image(
                    image: thisPiece,
                    height: boardSquareSize.height * 1.25,
                    width: boardSquareSize.width * 1.25,
                  ),
                  data: [
                    contents,
                    row,
                    col,
                  ],
                  child: Image(
                    image: thisPiece,
                    height: boardSquareSize.height,
                    width: boardSquareSize.width,
                  ),
                ),
              ),
            ),
          ),
        );
        col++;
      }
      boardRows.add(
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: boardSquares,
        ),
      );
      row--;
    }

    return Column(children: boardRows);
  }
}
