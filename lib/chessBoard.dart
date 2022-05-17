import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'boardData.dart';

class ChessTheme {
  late String whiteKing;
  late String whiteQueen;
  late String whiteRook;
  late String whiteBishop;
  late String whiteKnight;
  late String whitePawn;

  late String blackKing;
  late String blackQueen;
  late String blackRook;
  late String blackBishop;
  late String blackKnight;
  late String blackPawn;

  late String noPiece;
  late String lightSquare;
  late String darkSquare;

  Color lightSquareColor = const Color.fromRGBO(0xff, 0xff, 0xdd, 100);
  Color darkSquareColor = const Color.fromRGBO(0x33, 0x99, 0x00, 100);

  ChessTheme(String chessPiecePath, String boardTilesPath) {
    whiteKing = '${chessPiecePath}whiteKing.svg';
    whiteQueen = '${chessPiecePath}whiteQueen.svg';
    whiteBishop = '${chessPiecePath}whiteBishop.svg';
    whiteKnight = '${chessPiecePath}whiteKnight.svg';
    whiteRook = '${chessPiecePath}whiteRook.svg';
    whitePawn = '${chessPiecePath}whitePawn.svg';
    blackKing = '${chessPiecePath}blackKing.svg';
    blackQueen = '${chessPiecePath}blackQueen.svg';
    blackBishop = '${chessPiecePath}blackBishop.svg';
    blackKnight = '${chessPiecePath}blackKnight.svg';
    blackRook = '${chessPiecePath}blackRook.svg';
    blackPawn = '${chessPiecePath}blackPawn.svg';
    noPiece = '${chessPiecePath}nothing.svg';

    darkSquare = '${boardTilesPath}darkSquare.png';
    lightSquare = '${boardTilesPath}lightSquare.png';
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
        late String thisPiece;
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

        String squareBg = chessTheme.lightSquare;
        Color squareBgColor = chessTheme.lightSquareColor;

        if ((row + col) % 2 != 0) {
          squareBg = chessTheme.darkSquare;
          squareBgColor = chessTheme.darkSquareColor;
        }
        debugPrint("Tile: $squareBg");

        boardSquares.add(
          Container(
            width: boardSquareSize.width,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: squareBgColor,
                  image: DecorationImage(
                    image: AssetImage(squareBg),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: Draggable(
                  feedback: Image(
                    image: Svg(
                      thisPiece,
                      size: boardSquareSize,
                    ),
                  ),
                  data: [
                    contents,
                    row,
                    col,
                  ],
                  child: Image(
                    image: Svg(
                      thisPiece,
                      size: boardSquareSize,
                    ),
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
