import '../models/cell_position.dart';
import '../models/sudoku_cell.dart';

abstract final class SudokuValidator {
  static bool isSolved(List<List<SudokuCell>> cells, String solution) {
    for (var row = 0; row < 9; row++) {
      for (var col = 0; col < 9; col++) {
        final index = row * 9 + col;
        final expected = int.parse(solution[index]);
        if (cells[row][col].value != expected) return false;
      }
    }
    return true;
  }

  static List<List<SudokuCell>> applyMistakes(
    List<List<SudokuCell>> cells,
    String solution,
  ) {
    return List.generate(9, (row) {
      return List.generate(9, (col) {
        final cell = cells[row][col];
        if (cell.isGiven || cell.isEmpty) {
          return cell.copyWith(isWrong: false);
        }
        final index = row * 9 + col;
        final expected = int.parse(solution[index]);
        return cell.copyWith(isWrong: cell.value != expected);
      });
    });
  }

  static bool hasConflict(
    List<List<SudokuCell>> cells,
    CellPosition pos,
    int value,
  ) {
    if (value == 0) return false;

    for (var col = 0; col < 9; col++) {
      if (col != pos.col && cells[pos.row][col].value == value) return true;
    }
    for (var row = 0; row < 9; row++) {
      if (row != pos.row && cells[row][pos.col].value == value) return true;
    }

    final boxRow = pos.boxRow * 3;
    final boxCol = pos.boxCol * 3;
    for (var row = boxRow; row < boxRow + 3; row++) {
      for (var col = boxCol; col < boxCol + 3; col++) {
        if (row == pos.row && col == pos.col) continue;
        if (cells[row][col].value == value) return true;
      }
    }

    return false;
  }
}
