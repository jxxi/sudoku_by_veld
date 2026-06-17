import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_by_veld/models/game_state.dart';
import 'package:sudoku_by_veld/models/puzzle.dart';
import 'package:sudoku_by_veld/models/sudoku_cell.dart';
import 'package:sudoku_by_veld/storage/game_store.dart';

void main() {
  late Puzzle puzzle;

  setUpAll(() {
    final file = File('assets/puzzles/puzzles.json');
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    puzzle = Puzzle.fromJson(
      (json['puzzles'] as List<dynamic>).first as Map<String, dynamic>,
    );
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('peekSummary is null when nothing is saved', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = GameStore(prefs);

    expect(store.hasSavedGame, isFalse);
    expect(store.peekSummary(), isNull);
  });

  test('save and peekSummary persist metadata', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = GameStore(prefs);
    final state = GameState.fromPuzzle(puzzle).copyWith(elapsedSeconds: 125);

    await store.save(state);

    expect(store.hasSavedGame, isTrue);
    final summary = store.peekSummary();
    expect(summary?.puzzleId, puzzle.id);
    expect(summary?.difficulty, puzzle.difficulty);
    expect(summary?.elapsedSeconds, 125);
  });

  test('clear removes saved game', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = GameStore(prefs);
    await store.save(GameState.fromPuzzle(puzzle));

    await store.clear();

    expect(store.hasSavedGame, isFalse);
    expect(store.peekSummary(), isNull);
  });

  test('save clears storage when puzzle is complete', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = GameStore(prefs);
    final cells = List.generate(9, (row) {
      return List.generate(9, (col) {
        final index = row * 9 + col;
        final value = int.parse(puzzle.solution[index]);
        return SudokuCell(value: value, isGiven: true);
      });
    });
    final complete = GameState(
      puzzle: puzzle,
      cells: cells,
      startedAt: DateTime.now(),
      isComplete: true,
    );

    await store.save(complete);

    expect(store.hasSavedGame, isFalse);
  });
}
