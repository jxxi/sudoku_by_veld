import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../logic/puzzle_repository.dart';
import '../models/cell_position.dart';
import '../models/game_state.dart';
import '../models/sudoku_cell.dart';

class GameStore {
  GameStore(this._prefs);

  final SharedPreferences _prefs;
  static const _savedGameKey = 'saved_game';

  bool get hasSavedGame => _prefs.containsKey(_savedGameKey);

  Future<void> save(GameState state) async {
    if (state.isComplete) {
      await clear();
      return;
    }

    final payload = {
      'puzzleId': state.puzzle.id,
      'elapsedSeconds': state.elapsedSeconds,
      'pencilMode': state.pencilMode,
      'startedAt': state.startedAt.toIso8601String(),
      'selected': state.selected == null
          ? null
          : {'row': state.selected!.row, 'col': state.selected!.col},
      'cells': [
        for (final row in state.cells)
          [
            for (final cell in row)
              {
                'value': cell.value,
                'isGiven': cell.isGiven,
                'notes': cell.notes.toList(),
                'isWrong': cell.isWrong,
              },
          ],
      ],
    };

    await _prefs.setString(_savedGameKey, jsonEncode(payload));
  }

  Future<GameState?> load() async {
    final raw = _prefs.getString(_savedGameKey);
    if (raw == null) return null;

    final json = jsonDecode(raw) as Map<String, dynamic>;
    final puzzleId = json['puzzleId'] as String;
    final puzzle = await PuzzleRepository.instance.byId(puzzleId);
    if (puzzle == null) {
      await clear();
      return null;
    }

    final cellGrid = (json['cells'] as List<dynamic>).map((row) {
      return (row as List<dynamic>).map((cellJson) {
        final cell = cellJson as Map<String, dynamic>;
        return SudokuCell(
          value: cell['value'] as int,
          isGiven: cell['isGiven'] as bool,
          notes: (cell['notes'] as List<dynamic>).cast<int>().toSet(),
          isWrong: cell['isWrong'] as bool? ?? false,
        );
      }).toList();
    }).toList();

    final selectedJson = json['selected'] as Map<String, dynamic>?;
    final selected = selectedJson == null
        ? null
        : CellPosition(
            selectedJson['row'] as int,
            selectedJson['col'] as int,
          );

    return GameState(
      puzzle: puzzle,
      cells: cellGrid,
      startedAt: DateTime.parse(json['startedAt'] as String),
      selected: selected,
      pencilMode: json['pencilMode'] as bool? ?? false,
      elapsedSeconds: json['elapsedSeconds'] as int? ?? 0,
    );
  }

  Future<void> clear() => _prefs.remove(_savedGameKey);
}
