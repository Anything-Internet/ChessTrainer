class BoardData {
  List<List> boardDataArray = [];
  List<Square> column = [];

  String normalStartPosition =
      "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
  String playersTurn = "w";

  bool whiteCastleKingSide = false;
  bool whiteCastleQueenSide = false;
  bool blackCastleKingSide = false;
  bool blackCastleQueenSide = false;
  String enPassant = "-";
  int halfMoveClock = 0;
  int fullMoveNumber = 1;

  BoardData() {
    for (var col = 0; col < 8; col++) {
      column = []; // reset to build next row.

      for (var row = 0; row < 8; row++) {
        column.add(Square(col, row));
      }
      boardDataArray.add(column);
    }
    resetPosition();
  }

  move(String myMove) {
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

    makeMove(fromX, fromY, toX, toY);
  }

  makeMove(int fromX, int fromY, int toX, int toY) {
    boardDataArray[toX][toY].contents = boardDataArray[fromX][fromY].contents;

    boardDataArray[fromX][fromY].contents = ' ';
  }

  void resetPosition() {
    setPosition(normalStartPosition);
  }

  void setPosition(String fen) {
    int row = 7;
    int col = 0;

    var fenArray = fen.split(' ');
    var fenPos = fenArray[0].split('');

    for (var element in fenPos) {
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
          boardDataArray[row][col++].contents = element;
          break;

        default: // numerics
          int x1 = 0;
          int x2 = int.parse(element);

          while (x1 < x2) {
            boardDataArray[row][col++].contents = " ";
            x1++;
          }
      }
      ; // end switch
    }

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
    halfMoveClock = int.parse(fenArray[4]);
    fullMoveNumber = int.parse(fenArray[5]);
  }

  String get fen {
    var fenStr = "";

    for (int y = 7; y >= 0; y--) {
      for (int x = 0; x <= 7; x++) {
        if (boardDataArray[y][x].contents == ' ') {
          fenStr += " ";
        } else {
          fenStr += boardDataArray[y][x].contents;
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

    fenStr += " $playersTurn ";

    if (whiteCastleKingSide) fenStr += "K";
    if (whiteCastleQueenSide) fenStr += "Q";
    if (blackCastleKingSide) fenStr += "k";
    if (blackCastleQueenSide) fenStr += "q";

    fenStr += " $enPassant $halfMoveClock $fullMoveNumber";

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
