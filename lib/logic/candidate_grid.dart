import '../models/cell_position.dart';
import '../models/sudoku_cell.dart';

abstract final class CandidateGrid {
  static List<List<Set<int>>> fromBoard(List<List<int>> board) {
    final candidates = List.generate(9, (_) => List.generate(9, (_) => <int>{}));

    for (var row = 0; row < 9; row++) {
      for (var col = 0; col < 9; col++) {
        if (board[row][col] != 0) {
          candidates[row][col] = {};
          continue;
        }
        candidates[row][col] = _possibleValues(board, row, col);
      }
    }

    return candidates;
  }

  static Set<int> _possibleValues(List<List<int>> board, int row, int col) {
    final used = <int>{};
    for (var c = 0; c < 9; c++) {
      final v = board[row][c];
      if (v != 0) used.add(v);
    }
    for (var r = 0; r < 9; r++) {
      final v = board[r][col];
      if (v != 0) used.add(v);
    }
    final boxRow = (row ~/ 3) * 3;
    final boxCol = (col ~/ 3) * 3;
    for (var r = boxRow; r < boxRow + 3; r++) {
      for (var c = boxCol; c < boxCol + 3; c++) {
        final v = board[r][c];
        if (v != 0) used.add(v);
      }
    }
    return {for (var n = 1; n <= 9; n++) if (!used.contains(n)) n};
  }
}

List<List<int>> boardFromCells(List<List<SudokuCell>> cells) {
  return List.generate(9, (row) {
    return List.generate(9, (col) => cells[row][col].value);
  });
}

CellPosition? findNextEmpty(List<List<int>> board) {
  for (var row = 0; row < 9; row++) {
    for (var col = 0; col < 9; col++) {
      if (board[row][col] == 0) return CellPosition(row, col);
    }
  }
  return null;
}
