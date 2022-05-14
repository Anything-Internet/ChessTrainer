import "dart:io";

class BoardData {
  List<List> board = [];
  List<Square> column = [];

  String normalStartPosition =
  "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
  String playersTurn = "w";

  bool whiteCastleKingSide = false;
  bool whiteCastleQueenSide = false;
  bool blackCastleKingSide = false;
  bool blackCastleQueenSide = false;
  String enPassant = "-";
  int HalfMoveClock = 0;
  int FullMoveNumber = 1;

  Map piece = {
    "WhiteKing": "\u2654",
    "WhiteQueen": "\u2655",
    "WhiteRook": "\u2656",
    "WhiteBishop": "\u2657",
    "WhiteKnight": "\u2658",
    "WhitePawn": "\u2659",
    "BlackKing": "\u265A",
    "BlackQueen": "\u265B",
    "BlackRook": "\u265C",
    "BlackBishop": "\u265D",
    "BlackKnight": "\u265E",
    "BlackPawn": "\u265F",
    "Empty": " ",
  };

  BoardData() {
    for (var col = 0; col < 8; col++) {
      column = []; // reset to build next row.

      for (var row = 0; row < 8; row++) {
        column.add(Square(col, row));
      }
      board.add(column);
    }
    resetPosition();
  }

  Move(String myMove) {
    // remove optional spaces
    myMove = myMove.replaceAll(' ', '');
    myMove = myMove.toUpperCase();

    List<String> parms = myMove.split("");

    // ERROR CHECKING
    if (parms.length != 4) return;

    if (("ABCDEFGH".contains(parms[0]) == false) ||
        ("12345678".contains(parms[1]) == false) ||
        ("ABCDEFGH".contains(parms[2]) == false) ||
        ("12345678".contains(parms[3]) == false)) {
      return;
    }

    int fromY = parms[0].codeUnits.first - 'A'.codeUnits.first;
    int fromX = int.parse(parms[1]) - 1;
    int toY = parms[2].codeUnits.first - 'A'.codeUnits.first;
    int toX = int.parse(parms[3]) - 1;

    MakeMove(fromX, fromY, toX, toY);
  }

  MakeMove(int fromX, int fromY, int toX, int toY) {
    board[toX][toY].contents = board[fromX][fromY].contents;

    board[fromX][fromY].contents = piece['Empty'];
  }

  void resetPosition() {
    SetPosition(normalStartPosition);
  }
  void SetPosition(String fen) {
    int row = 7;
    int col = 0;

    var fenArray = fen.split(' ');
    var fenPos = fenArray[0].split('');

    fenPos.forEach((element) {
      switch (element) {
        case "/":
          row--;
          col = 0;
          break;

        case 'K':
        case 'Q':
        case 'B':
        case 'N':
        case 'R':
        case 'P':
        case 'k':
        case 'q':
        case 'b':
        case 'n':
        case 'r':
        case 'p':
          board[row][col++].contents = element;
          break;

        default: // numerics
          int x1 = 0;
          int x2 = int.parse(element);

          while (x1 < x2) {
            board[row][col++].contents = " ";
            x1++;
          }
      }
      ; // end switch
    });

    if (fenArray.length != 6) return;

    if (fenArray[1] == "w") {
      playersTurn = "w";
    } else {
      playersTurn = "b";
    }

    whiteCastleKingSide = whiteCastleQueenSide =
        blackCastleKingSide = blackCastleQueenSide = false;

    if (fenArray[2].contains("K")) whiteCastleKingSide = true;
    if (fenArray[2].contains("Q")) whiteCastleQueenSide = true;
    if (fenArray[2].contains("k")) blackCastleKingSide = true;
    if (fenArray[2].contains("q")) blackCastleQueenSide = true;

    enPassant = fenArray[3];
    HalfMoveClock = int.parse(fenArray[4]);
    FullMoveNumber = int.parse(fenArray[5]);
  }

  printBoard() {
    print("   ---------------------------------");
    for (var y = 7; y >= 0; y--) {
      stdout.write(" ${y + 1} ");
      for (var x = 0; x < 8; x++) {
        stdout.write("| ");
        if (board[y][x].contents == "K") stdout.write(piece['WhiteKing']);
        if (board[y][x].contents == "Q") stdout.write(piece['WhiteQueen']);
        if (board[y][x].contents == "B") stdout.write(piece['WhiteBishop']);
        if (board[y][x].contents == "N") stdout.write(piece['WhiteKnight']);
        if (board[y][x].contents == "R") stdout.write(piece['WhiteRook']);
        if (board[y][x].contents == "P") stdout.write(piece['WhitePawn']);

        if (board[y][x].contents == "k") stdout.write(piece['BlackKing']);
        if (board[y][x].contents == "q") stdout.write(piece['BlackQueen']);
        if (board[y][x].contents == "b") stdout.write(piece['BlackBishop']);
        if (board[y][x].contents == "n") stdout.write(piece['BlackKnight']);
        if (board[y][x].contents == "r") stdout.write(piece['BlackRook']);
        if (board[y][x].contents == "p") stdout.write(piece['BlackPawn']);
        if (board[y][x].contents == " ") stdout.write(piece['Empty']);

        stdout.write(" ");
      }
      print("|");
      print("   ---------------------------------");
    }
    print("     A   B   C   D   E   F   G   H  \n");

    stdout.write("Turn:${playersTurn} ");

    stdout.write("CA:");
    if (whiteCastleKingSide) stdout.write("K");
    if (whiteCastleQueenSide) stdout.write("Q");
    if (blackCastleKingSide) stdout.write("k");
    if (blackCastleQueenSide) stdout.write("q");
    stdout.write(" EP:$enPassant");
    stdout.write(" MV:$HalfMoveClock/$FullMoveNumber");
    print("");
  }

  String get fen {
    // rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
    var fenStr = "";

    for (int y = 7; y >= 0; y--) {
      for (int x = 0; x <= 7; x++) {
        if (board[y][x].contents == ' ') {
          fenStr += " ";
        } else {
          fenStr += board[y][x].contents;
        }
      }
      if (y > 0) fenStr += "/";
      fenStr = fenStr.replaceAll("        ", "8");
      fenStr = fenStr.replaceAll("       ", "7");
      fenStr = fenStr.replaceAll("      ", "6");
      fenStr = fenStr.replaceAll("     ", "5");
      fenStr = fenStr.replaceAll("    ", "4");
      fenStr = fenStr.replaceAll("   ", "3");
      fenStr = fenStr.replaceAll("  ", "2");
      fenStr = fenStr.replaceAll(" ", "1");
    }

    fenStr += " ${playersTurn} ";

    if (whiteCastleKingSide) fenStr += "K";
    if (whiteCastleQueenSide) fenStr += "Q";
    if (blackCastleKingSide) fenStr += "k";
    if (blackCastleQueenSide) fenStr += "q";

    fenStr += " ${enPassant} ${HalfMoveClock} ${FullMoveNumber}";

    return fenStr;
  }
}

class Square {
  int _rowIndex = 0; // 0-7
  int _colIndex = 0; // 0-7
  String _label = "";
  String? contents = " ";
  bool lightSquare = true;

  Square(int colIndex, int rowIndex) {
    _rowIndex = rowIndex;
    _colIndex = colIndex;
    _label = col + row;

    if ((rowIndex + colIndex) % 2 == 0) lightSquare = false;
  }

  String get row {
    return (String.fromCharCode('1'.codeUnitAt(0) + _rowIndex));
  }

  String get col {
    return (String.fromCharCode('A'.codeUnitAt(0) + _colIndex));
  }

  int get rowIndex {
    return _rowIndex;
  }

  int get colIndex {
    return _colIndex;
  }

  String get label {
    return _label;
  }
}
