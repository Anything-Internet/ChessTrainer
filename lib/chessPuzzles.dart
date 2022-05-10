import "dart:math";
import "package:flutter/services.dart";

main() {
  String puzzleFile = "assets/puzzles.csv";
  ChessPuzzles chessPuzzles = ChessPuzzles();
  chessPuzzles.Load(puzzleFile);

  List<String> fen = chessPuzzles.GetFenArray();

  for (var x = 0; x < 5; x++) {
    print(chessPuzzles.NextPuzzle());
  }
}

class ChessPuzzles {
  List<Puzzle> puzzles = [];
  var rnd = Random();

  // input file must be in assets
  Load (String inputFile) async {
    if (inputFile == "")  return;

    String rawData = await rootBundle.loadString(inputFile);
    List<String> DefaultData = await rawData.split("\r\n");

    int cnt = 0;
    DefaultData.forEach((l) {
      List<String> ln = l.split(",");
      if(ln.length == 2) {
        puzzles.add(new Puzzle(ln[0], ln[1]));
        cnt++;
      }
    });
    print("Loading $cnt positions into Puzzles[${puzzles.length}]");
  }

  List<String> GetFenArray() {
    List<String> fens = [];
    for (var p in puzzles) {
      fens.add(p.fen);
    }
    return fens;
  }

  String NextPuzzle() {
    int size = puzzles.length;
    int x = rnd.nextInt(size - 1);

    print("Loading puzzle[$x]: ${puzzles[x].fen}");
    return puzzles[x].fen;
  }
}

class Puzzle {
  String fen = "";
  String solution = "";

  Puzzle(String fen, String solution) {
    this.fen = fen;
    this.solution = solution;
  }
}
