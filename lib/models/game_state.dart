import '../models/cell_position.dart';
import '../models/difficulty.dart';
import '../models/puzzle.dart';
import '../models/sudoku_cell.dart';
import '../logic/sudoku_validator.dart';

class GameState {
  GameState({
    required this.puzzle,
    required this.cells,
    required this.startedAt,
    this.selected,
    this.pencilMode = false,
    this.elapsedSeconds = 0,
    this.isPaused = false,
    this.isComplete = false,
  });

  final Puzzle puzzle;
  final List<List<SudokuCell>> cells;
  final CellPosition? selected;
  final bool pencilMode;
  final DateTime startedAt;
  final int elapsedSeconds;
  final bool isPaused;
  final bool isComplete;

  Difficulty get difficulty => puzzle.difficulty;

  int? get selectedValue {
    final pos = selected;
    if (pos == null) return null;
    final value = cells[pos.row][pos.col].value;
    return value == 0 ? null : value;
  }

  factory GameState.fromPuzzle(Puzzle puzzle) {
    final cells = List.generate(9, (row) {
      return List.generate(9, (col) {
        final index = row * 9 + col;
        final digit = int.parse(puzzle.givens[index]);
        return SudokuCell(value: digit, isGiven: digit != 0);
      });
    });

    return GameState(
      puzzle: puzzle,
      cells: cells,
      startedAt: DateTime.now(),
    );
  }

  GameState copyWith({
    List<List<SudokuCell>>? cells,
    CellPosition? selected,
    bool clearSelection = false,
    bool? pencilMode,
    int? elapsedSeconds,
    bool? isPaused,
    bool? isComplete,
  }) {
    return GameState(
      puzzle: puzzle,
      cells: cells ?? this.cells,
      selected: clearSelection ? null : (selected ?? this.selected),
      pencilMode: pencilMode ?? this.pencilMode,
      startedAt: startedAt,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isPaused: isPaused ?? this.isPaused,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  GameState withValidatedCells() {
    final validated = SudokuValidator.applyMistakes(cells, puzzle.solution);
    final complete = SudokuValidator.isSolved(validated, puzzle.solution);
    return copyWith(cells: validated, isComplete: complete);
  }
}
