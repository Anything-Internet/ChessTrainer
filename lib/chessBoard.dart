import 'package:chesstrainer/main.dart';
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
  Color boardBorder =  Colors.brown.shade700;

  Size _boardSquareSize = Size(20, 20);
  Size _boardSize = Size(200, 200);

  set boardSquareSize(Size boardSquareSize) {
    _boardSquareSize = boardSquareSize;
  }

  Size get boardSquareSize {
    return _boardSquareSize;
  }

  // set boardSize(Size boardSize) { _boardSize = boardSize;}
  set boardSize(Size boardSize) {
    _boardSize = boardSize;
  }

  Size get boardSize {
    return _boardSize;
  }

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

ChessTheme chessTheme =
    ChessTheme(appData.chessPiecePath, appData.boardTilesPath);
BoardData boardData = BoardData();

class ChessBoard extends StatefulWidget {
  ChessBoard({Key? key}) : super(key: key);

  @override
  _ChessBoardState createState() => _ChessBoardState();

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
    boardData.refresh = refresh;
    drawBoard();
  }

  refresh() {
    debugPrint("setState/refresh invoked");
    debugPrint("FEN: ${boardData.fen}");
    setState(() {
      boardData = boardData;
      chessTheme = chessTheme;
      //drawBoard();
    });
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    drawBoard();
    debugPrint("didUpdateWiget: called()");
    debugPrint("FEN: ${boardData.fen}");
  }

  Widget drawBoard() {
    for (var row = 7; row >= 0; row--) {
      for (var col = 0; col < 8; col++) {
        String contents = boardData.boardDataArray[row][col].contents;
        squares.add(buildSquare(
          contents: contents,
          row: row,
          col: col,
        ));
      }
    }
    return (squares[0]);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    Size maxSize = mediaQueryData.size;
    double max =
        (maxSize.width > maxSize.height) ? maxSize.height : maxSize.width;
    max = max * 0.6;
    chessTheme.boardSize = Size(max, max);
    chessTheme.boardSquareSize = Size(max / 8, max / 8);

    return Container(
      width: maxSize.width,
      padding: EdgeInsets.all(10),
      color: chessTheme.boardBorder,
      alignment: Alignment.topLeft,
      constraints: BoxConstraints(
        maxHeight: max,
        maxWidth: max,
      ),
      child: GridView.count(
          shrinkWrap: true, crossAxisCount: 8, children: squares),
    );
  }
}

class buildSquare extends StatelessWidget {
  buildSquare({
    Key? key,
    this.contents,
    this.row,
    this.col,
  }) : super(key: key);

  var contents;
  var row;
  var col;

  @override
  Widget build(BuildContext context) {
    ({this.contents, this.row, this.col});
    // ({Key key, this.x, this.y}) : super(key: key);

    return square();
  }

  square() {
    String thisPiece = chessTheme.noPiece;

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

    return Container(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            //color: squareBgColor,
            image: DecorationImage(
              image: AssetImage(squareBg),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.rectangle,
          ),
          child: Draggable(
            //onDragCompleted: super._onClick(),
            feedback: Image(
              image: Svg(
                thisPiece,
                size: chessTheme.boardSquareSize,
              ),
            ),
            data: [
              contents,
              row,
              col,
            ],
            childWhenDragging: Image(
              image: Svg(
                chessTheme.noPiece,
              ),
            ),
            child: Image(
              image: Svg(
                thisPiece,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
