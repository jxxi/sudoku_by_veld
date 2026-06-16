import 'package:flutter/material.dart';

import '../../models/difficulty.dart';
import '../../models/game_state.dart';
import '../../models/puzzle.dart';
import '../grid/sudoku_grid.dart';
import '../tutorial/tutorial_puzzle.dart';

/// Decorative partial grid for the home screen — not interactive.
class HomePuzzlePreview extends StatelessWidget {
  const HomePuzzlePreview({super.key});

  static const _givens =
      '530070000600195000098000060800060003409008001700020006000601008401905000803000079';

  static final GameState _state = GameState.fromPuzzle(
    Puzzle(
      id: 'home-preview',
      difficulty: Difficulty.easy,
      givens: _givens,
      solution: TutorialPuzzle.solution,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 270),
        child: IgnorePointer(
          child: SudokuGrid(
            state: _state,
            onCellTap: (_) {},
          ),
        ),
      ),
    );
  }
}
