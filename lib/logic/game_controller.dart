import '../models/cell_position.dart';
import '../models/game_state.dart';
import '../models/sudoku_cell.dart';

class GameController {
  GameController(this.state);

  GameState state;

  void selectCell(CellPosition pos) {
    state = state.copyWith(selected: pos);
  }

  void togglePencilMode() {
    state = state.copyWith(pencilMode: !state.pencilMode);
  }

  void clearSelected() {
    final pos = state.selected;
    if (pos == null) return;

    final cell = state.cells[pos.row][pos.col];
    if (cell.isGiven) return;

    final cells = _cloneCells(state.cells);
    if (state.pencilMode || cell.value == 0) {
      cells[pos.row][pos.col] = cell.copyWith(notes: {}, isWrong: false);
    } else {
      cells[pos.row][pos.col] = cell.copyWith(
        value: 0,
        clearNotes: true,
        isWrong: false,
      );
    }

    state = state.copyWith(cells: cells).withValidatedCells();
  }

  void inputDigit(int digit) {
    final pos = state.selected;
    if (pos == null) return;

    final cell = state.cells[pos.row][pos.col];
    if (cell.isGiven) return;

    final cells = _cloneCells(state.cells);

    if (state.pencilMode) {
      final notes = Set<int>.from(cell.notes);
      if (notes.contains(digit)) {
        notes.remove(digit);
      } else {
        notes.add(digit);
      }
      cells[pos.row][pos.col] = cell.copyWith(notes: notes, value: 0);
    } else {
      cells[pos.row][pos.col] = cell.copyWith(
        value: digit,
        clearNotes: true,
      );
    }

    state = state.copyWith(cells: cells).withValidatedCells();
  }

  void applyReveal(CellPosition pos, int value) {
    final cell = state.cells[pos.row][pos.col];
    if (cell.isGiven) return;

    final cells = _cloneCells(state.cells);
    cells[pos.row][pos.col] = cell.copyWith(
      value: value,
      clearNotes: true,
      isWrong: false,
    );
    state = state.copyWith(
      cells: cells,
      selected: pos,
    ).withValidatedCells();
  }

  void tick(int seconds) {
    if (state.isComplete || state.isPaused) return;
    state = state.copyWith(elapsedSeconds: seconds);
  }

  List<List<SudokuCell>> _cloneCells(List<List<SudokuCell>> source) {
    return List.generate(9, (row) {
      return List.generate(9, (col) {
        final cell = source[row][col];
        return cell.copyWith(notes: Set<int>.from(cell.notes));
      });
    });
  }
}
