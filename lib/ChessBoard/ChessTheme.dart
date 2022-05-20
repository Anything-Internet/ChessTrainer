import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class ChessTheme {
  String _chessPiecePath = "";
  String _boardTilesPath = "";

  late ImageProvider lightSquare;
  late ImageProvider darkSquare;

  Map chessPiece = {};

  Color lightSquareColor = const Color.fromRGBO(0xff, 0xff, 0xdd, 100);
  Color darkSquareColor = const Color.fromRGBO(0x33, 0x99, 0x00, 100);
  Color boardBorder = Colors.brown.shade700;

  Size _boardSquareSize = const Size(20, 20);
  Size _boardSize = const Size(200, 200);

  set boardSquareSize(Size boardSquareSize) {
    if (_boardSquareSize != boardSquareSize) {
      _boardSquareSize = boardSquareSize;
      rebuildAssets();
    }
  }

  Size get boardSquareSize {
    return _boardSquareSize;
  }

  set boardSize(Size boardSize) {
    _boardSize = boardSize;
    boardSquareSize = _boardSize / 8;
  }

  Size get boardSize {
    return _boardSize;
  }

  ChessTheme(String chessPiecePath, String boardTilesPath) {
    _chessPiecePath = chessPiecePath;
    _boardTilesPath = boardTilesPath;
    rebuildAssets();
  }

  rebuildAssets() {
    debugPrint("Rendering pieces to: ($_boardSquareSize x $_boardSquareSize)");

    chessPiece['K'] = renderPiece('${_chessPiecePath}whiteKing.svg');
    chessPiece['Q'] = renderPiece('${_chessPiecePath}whiteQueen.svg');
    chessPiece['B'] = renderPiece('${_chessPiecePath}whiteBishop.svg');
    chessPiece['N'] = renderPiece('${_chessPiecePath}whiteKnight.svg');
    chessPiece['R'] = renderPiece('${_chessPiecePath}whiteRook.svg');
    chessPiece['P'] = renderPiece('${_chessPiecePath}whitePawn.svg');
    chessPiece['k'] = renderPiece('${_chessPiecePath}blackKing.svg');
    chessPiece['q'] = renderPiece('${_chessPiecePath}blackQueen.svg');
    chessPiece['b'] = renderPiece('${_chessPiecePath}blackBishop.svg');
    chessPiece['n'] = renderPiece('${_chessPiecePath}blackKnight.svg');
    chessPiece['r'] = renderPiece('${_chessPiecePath}blackRook.svg');
    chessPiece['p'] = renderPiece('${_chessPiecePath}blackPawn.svg');
    chessPiece[' '] = renderPiece('${_chessPiecePath}nothing.png');

    darkSquare = renderPiece('${_boardTilesPath}darkSquare.png');
    lightSquare = renderPiece('${_boardTilesPath}lightSquare.png');
  }

  ImageProvider renderPiece(String thisPiece) {
    if (thisPiece.contains(".svg")) {
      return Svg(
        thisPiece,
        size: _boardSquareSize,
      );
    } else {
      return AssetImage(
        thisPiece,
      );
    }
  }
}
