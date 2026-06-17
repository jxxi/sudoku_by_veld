import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_by_veld/logic/completed_digits.dart';
import 'package:sudoku_by_veld/models/game_state.dart';
import 'package:sudoku_by_veld/models/sudoku_cell.dart';
import 'package:sudoku_by_veld/ui/tutorial/tutorial_puzzle.dart';

void main() {
  test('completed digit when all nine are correct on the board', () {
    final puzzle = TutorialPuzzle.build();
    final cells = List.generate(9, (row) {
      return List.generate(9, (col) {
        final index = row * 9 + col;
        final value = int.parse(puzzle.solution[index]);
        return SudokuCell(value: value, isGiven: true);
      });
    });

    final state = GameState(
      puzzle: puzzle,
      cells: cells,
      startedAt: DateTime.now(),
    );

    expect(CompletedDigits.onBoard(state), {1, 2, 3, 4, 5, 6, 7, 8, 9});
  });

  test('ignores wrong placements toward completion', () {
    final puzzle = TutorialPuzzle.build();
    final cells = List.generate(9, (row) {
      return List.generate(9, (col) {
        final index = row * 9 + col;
        final correct = int.parse(puzzle.solution[index]);
        if (correct == 1) {
          return SudokuCell(
            value: 9,
            isGiven: false,
            isWrong: true,
          );
        }
        return SudokuCell(value: correct, isGiven: true);
      });
    });

    final state = GameState(
      puzzle: puzzle,
      cells: cells,
      startedAt: DateTime.now(),
    );

    expect(CompletedDigits.onBoard(state), isNot(contains(1)));
  });
}
