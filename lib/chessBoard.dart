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
    noPiece = AssetImage(chessPiecePath + 'nothing.png');
    darkSquare = AssetImage(boardTilesPath + 'darkSquare.png');
    lightSquare = AssetImage(boardTilesPath + 'lightSquare.png');
  }
}

class ChessBoard {
  late Size boardSquareSize;
  late ChessTheme chessTheme;
  late String normalStartPosition;
  late BoardData boardData;
  // create data
  // load theme

  ChessBoard(String chessPiecePath, String boardTilesPath) {
    boardData = BoardData();
    chessTheme = ChessTheme(chessPiecePath, boardTilesPath);
    boardSquareSize = Size(50, 50);
  }

  get turnColor {
    if (boardData.playersTurn == "b") return Colors.black;
    else return Colors.white;
  }

  Column drawChessBoard() {
    List<Row> board = [];
    List<Container> square = [];

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

        square.add(
          Container(
            width: boardSquareSize.width,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: squareBg,
                    //opacity: 0.10,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Draggable(
                  child: Image(
                    image: thisPiece,
                    height: boardSquareSize.height,
                    width: boardSquareSize.width,
                  ),
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
}
