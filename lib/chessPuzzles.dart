import "dart:math";
import 'package:flutter/cupertino.dart';
import "package:flutter/services.dart";

main() {
  String puzzleFile = "assets/puzzles.csv";
  ChessPuzzles chessPuzzles = ChessPuzzles();
  chessPuzzles.loadPuzzles(puzzleFile);

  for (var x = 0; x < 5; x++) {
    debugPrint(chessPuzzles.getNextPuzzle());
  }
}

class ChessPuzzles {
  List<Puzzle> puzzles = [];
  var rnd = Random();

  // input file must be in assets
  loadPuzzles (String inputFile) async {
    if (inputFile == "")  return;

    String fileData = await rootBundle.loadString(inputFile);
    List<String> fileRows = fileData.split("\r\n");

    int cnt = 0;
    for (var line in fileRows) {
      List<String> lineFields = line.split(",");
      if(lineFields.length == 2) {
        puzzles.add(Puzzle(lineFields[0], lineFields[1]));
        cnt++;
      }
      if(lineFields.length == 1) {
        puzzles.add(Puzzle(lineFields[0], ""));
        cnt++;
      }
    }
    debugPrint("Loading $cnt positions into Puzzles[${puzzles.length}]");
  }

  List<String> getFenArray() {
    List<String> fens = [];
    for (var p in puzzles) {
      fens.add(p.fen);
    }
    return fens;
  }

  String getNextPuzzle() {
    int size = puzzles.length;
    int x = rnd.nextInt(size - 1);

    debugPrint("Loading puzzle[$x]: ${puzzles[x].fen}");
    return puzzles[x].fen;
  }
}

class Puzzle {
  String fen = "";
  String solution = "";

  Puzzle(this.fen, this.solution);
}
