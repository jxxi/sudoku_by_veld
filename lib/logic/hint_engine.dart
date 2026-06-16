import '../models/cell_position.dart';
import '../models/sudoku_cell.dart';
import 'candidate_grid.dart';

enum HintType { strategy, reveal }

class StrategyHint {
  const StrategyHint({
    required this.technique,
    required this.explanation,
    required this.primaryCells,
    required this.secondaryCells,
    this.placement,
  });

  final String technique;
  final String explanation;
  final List<CellPosition> primaryCells;
  final List<CellPosition> secondaryCells;
  final ({CellPosition cell, int value})? placement;
}

abstract final class HintEngine {
  static StrategyHint? findStrategyHint(List<List<SudokuCell>> cells) {
    final board = boardFromCells(cells);
    final candidates = CandidateGrid.fromBoard(board);

    final naked = _findNakedSingle(candidates);
    if (naked != null) return naked;

    return _findHiddenSingle(board, candidates);
  }

  static StrategyHint? _findNakedSingle(List<List<Set<int>>> candidates) {
    for (var row = 0; row < 9; row++) {
      for (var col = 0; col < 9; col++) {
        final options = candidates[row][col];
        if (options.length == 1) {
          final value = options.first;
          return StrategyHint(
            technique: 'Naked Single',
            explanation:
                'This cell can only be $value — every other number is ruled out by its row, column, or box.',
            primaryCells: [CellPosition(row, col)],
            secondaryCells: _houseCells(row, col),
            placement: (cell: CellPosition(row, col), value: value),
          );
        }
      }
    }
    return null;
  }

  static StrategyHint? _findHiddenSingle(
    List<List<int>> board,
    List<List<Set<int>>> candidates,
  ) {
    for (var row = 0; row < 9; row++) {
      final rowHint = _hiddenSingleInRow(board, candidates, row);
      if (rowHint != null) return rowHint;
    }
    for (var col = 0; col < 9; col++) {
      final colHint = _hiddenSingleInCol(board, candidates, col);
      if (colHint != null) return colHint;
    }
    for (var box = 0; box < 9; box++) {
      final boxHint = _hiddenSingleInBox(board, candidates, box);
      if (boxHint != null) return boxHint;
    }
    return null;
  }

  static StrategyHint? _hiddenSingleInRow(
    List<List<int>> board,
    List<List<Set<int>>> candidates,
    int row,
  ) {
    for (var digit = 1; digit <= 9; digit++) {
      CellPosition? target;
      for (var col = 0; col < 9; col++) {
        if (board[row][col] != 0) continue;
        if (!candidates[row][col].contains(digit)) continue;
        if (target != null) {
          target = null;
          break;
        }
        target = CellPosition(row, col);
      }
      if (target != null) {
        return StrategyHint(
          technique: 'Hidden Single',
          explanation:
              'In this row, $digit can only go in one cell — it is hidden among other candidates.',
          primaryCells: [target],
          secondaryCells: [
            for (var col = 0; col < 9; col++) CellPosition(target.row, col),
          ],
          placement: (cell: target, value: digit),
        );
      }
    }
    return null;
  }

  static StrategyHint? _hiddenSingleInCol(
    List<List<int>> board,
    List<List<Set<int>>> candidates,
    int col,
  ) {
    for (var digit = 1; digit <= 9; digit++) {
      CellPosition? target;
      for (var row = 0; row < 9; row++) {
        if (board[row][col] != 0) continue;
        if (!candidates[row][col].contains(digit)) continue;
        if (target != null) {
          target = null;
          break;
        }
        target = CellPosition(row, col);
      }
      if (target != null) {
        return StrategyHint(
          technique: 'Hidden Single',
          explanation:
              'In this column, $digit can only go in one cell — look where the column intersects its box.',
          primaryCells: [target],
          secondaryCells: [
            for (var row = 0; row < 9; row++) CellPosition(row, target.col),
          ],
          placement: (cell: target, value: digit),
        );
      }
    }
    return null;
  }

  static StrategyHint? _hiddenSingleInBox(
    List<List<int>> board,
    List<List<Set<int>>> candidates,
    int boxIndex,
  ) {
    final boxRow = (boxIndex ~/ 3) * 3;
    final boxCol = (boxIndex % 3) * 3;

    for (var digit = 1; digit <= 9; digit++) {
      CellPosition? target;
      for (var row = boxRow; row < boxRow + 3; row++) {
        for (var col = boxCol; col < boxCol + 3; col++) {
          if (board[row][col] != 0) continue;
          if (!candidates[row][col].contains(digit)) continue;
          if (target != null) {
            target = null;
            break;
          }
          target = CellPosition(row, col);
        }
      }
      if (target != null) {
        return StrategyHint(
          technique: 'Hidden Single',
          explanation:
              'In this box, $digit can only fit in one spot even though the cell has multiple pencil marks.',
          primaryCells: [target],
          secondaryCells: _boxCells(boxRow, boxCol),
          placement: (cell: target, value: digit),
        );
      }
    }
    return null;
  }

  static List<CellPosition> _houseCells(int row, int col) {
    final cells = <CellPosition>{};
    for (var c = 0; c < 9; c++) {
      cells.add(CellPosition(row, c));
    }
    for (var r = 0; r < 9; r++) {
      cells.add(CellPosition(r, col));
    }
    final boxRow = (row ~/ 3) * 3;
    final boxCol = (col ~/ 3) * 3;
    cells.addAll(_boxCells(boxRow, boxCol));
    return cells.toList();
  }

  static List<CellPosition> _boxCells(int boxRow, int boxCol) {
    return [
      for (var row = boxRow; row < boxRow + 3; row++)
        for (var col = boxCol; col < boxCol + 3; col++)
          CellPosition(row, col),
    ];
  }
}
