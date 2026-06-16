import '../models/cell_position.dart';
import 'candidate_grid.dart';

abstract final class SudokuSolver {
  static bool solve(List<List<int>> board) {
    final empty = findNextEmpty(board);
    if (empty == null) return true;

    for (var value = 1; value <= 9; value++) {
      if (!_isValid(board, empty.row, empty.col, value)) continue;
      board[empty.row][empty.col] = value;
      if (solve(board)) return true;
      board[empty.row][empty.col] = 0;
    }
    return false;
  }

  static CellPosition? findRevealCell(List<List<int>> board, String solution) {
    for (var row = 0; row < 9; row++) {
      for (var col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          return CellPosition(row, col);
        }
      }
    }
    return null;
  }

  static int revealValue(String solution, CellPosition pos) {
    final index = pos.row * 9 + pos.col;
    return int.parse(solution[index]);
  }

  static bool _isValid(List<List<int>> board, int row, int col, int value) {
    for (var c = 0; c < 9; c++) {
      if (board[row][c] == value) return false;
    }
    for (var r = 0; r < 9; r++) {
      if (board[r][col] == value) return false;
    }
    final boxRow = (row ~/ 3) * 3;
    final boxCol = (col ~/ 3) * 3;
    for (var r = boxRow; r < boxRow + 3; r++) {
      for (var c = boxCol; c < boxCol + 3; c++) {
        if (board[r][c] == value) return false;
      }
    }
    return true;
  }
}
