import "dart:io";

void main() {
  var boardData = BoardData();
  boardData.SetPosition(
      "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1");
  boardData.printBoard();

  boardData.SetPosition("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1");
  boardData.printBoard();

  boardData.SetPosition("rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2");
  boardData.printBoard();
}

class BoardData {
  List<List> board = [];
  List<Square> column = [];

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
  }

  void SetPosition(String fen) {
    int row = 7;
    int col = 0;
    bool done = false;

    var fenArray = fen.split('');

    fenArray.forEach((element) {
      if (!done) {
        switch (element) {
          case "/":
            row--;
            col = 0;
            if (row < 0) done = true;
            break;
          case " ":
            done = true;
            break;
          case 'K':
            board[row][col++].contents = piece['WhiteKing'];
            break;
          case 'Q':
            board[row][col++].contents = piece['WhiteQueen'];
            break;
          case 'B':
            board[row][col++].contents = piece['WhiteBishop'];
            break;
          case 'N':
            board[row][col++].contents = piece['WhiteKnight'];
            break;
          case 'R':
            board[row][col++].contents = piece['WhiteRook'];
            break;
          case 'P':
            board[row][col++].contents = piece['WhitePawn'];
            break;
          case 'k':
            board[row][col++].contents = piece['BlackKing'];
            break;
          case 'q':
            board[row][col++].contents = piece['BlackQueen'];
            break;
          case 'b':
            board[row][col++].contents = piece['BlackBishop'];
            break;
          case 'n':
            board[row][col++].contents = piece['BlackKnight'];
            break;
          case 'r':
            board[row][col++].contents = piece['BlackRook'];
            break;
          case 'p':
            board[row][col++].contents = piece['BlackPawn'];
            break;
          default: // numerics
            int x1 = 0;
            int x2 = int.parse(element);

            while (x1 < x2) {
              board[row][col++].contents = piece['Empty'];
              x1++;
            }
        }
        ;
      }
    });
  }

  printBoard() {
    print("---------------------------------");
    for (var y = 7; y >= 0; y--) {
      for (var x = 0; x < 8; x++) {
        stdout.write("| ${board[y][x].contents} ");
      }
      print("|");
      print("---------------------------------");
    }
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

    //print("Label: $_label $lightSquare");
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
