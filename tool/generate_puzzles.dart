import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:sudoku_by_veld/logic/puzzle_validation.dart';

/// Generates curated Sudoku packs by clue-count difficulty.
///
/// Usage: dart run tool/generate_puzzles.dart [countPerTier]
void main(List<String> args) {
  final count = args.isEmpty ? 200 : int.parse(args.first);
  final random = Random(42);
  final puzzles = <Map<String, String>>[];

  final tiers = {
    'easy': (40, 46),
    'medium': (32, 39),
    'hard': (28, 31),
    'expert': (24, 27),
    'diabolical': (17, 23),
  };

  for (final entry in tiers.entries) {
    final (minClues, maxClues) = entry.value;
    var made = 0;
    var attempts = 0;

    while (made < count && attempts < count * 200) {
      attempts++;
      final solved = _generateSolved(random);
      final givens = _carvePuzzle(solved, minClues, maxClues, random);
      if (givens == null) continue;

      made++;
      final id = '${entry.key}-${made.toString().padLeft(3, '0')}';
      final error = PuzzleValidation.validate(
        id: id,
        givens: givens,
        solution: solved,
      );
      if (error != null) {
        made--;
        continue;
      }

      puzzles.add({
        'id': id,
        'difficulty': entry.key,
        'givens': givens,
        'solution': solved,
      });
      stdout.write('\r${entry.key}: $made / $count');
    }
    stdout.writeln();
    if (made < count) {
      stderr.writeln('Warning: only generated $made ${entry.key} puzzles.');
    }
  }

  final output = {'puzzles': puzzles};
  final file = File('assets/puzzles/puzzles.json');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(output));
  stdout.writeln('Wrote ${puzzles.length} puzzles to ${file.path}');
  stdout.writeln('Run: flutter test test/puzzle_pack_test.dart');
}

String _generateSolved(Random random) {
  final board = List.generate(9, (_) => List.filled(9, 0));
  _fillBoard(board, random);
  return _flatten(board);
}

bool _fillBoard(List<List<int>> board, Random random) {
  for (var row = 0; row < 9; row++) {
    for (var col = 0; col < 9; col++) {
      if (board[row][col] != 0) continue;
      final digits = List.generate(9, (i) => i + 1)..shuffle(random);
      for (final digit in digits) {
        if (!_canPlace(board, row, col, digit)) continue;
        board[row][col] = digit;
        if (_fillBoard(board, random)) return true;
        board[row][col] = 0;
      }
      return false;
    }
  }
  return true;
}

String? _carvePuzzle(
  String solved,
  int minClues,
  int maxClues,
  Random random,
) {
  final board = List.generate(9, (row) {
    return List.generate(9, (col) => int.parse(solved[row * 9 + col]));
  });

  final target = minClues + random.nextInt(maxClues - minClues + 1);
  final positions = List.generate(81, (i) => i)..shuffle(random);

  for (final index in positions) {
    if (_clueCount(board) <= target) break;

    final row = index ~/ 9;
    final col = index % 9;
    if (board[row][col] == 0) continue;

    final backup = board[row][col];
    board[row][col] = 0;
    if (_countSolutions(_copyBoard(board), 0) != 1) {
      board[row][col] = backup;
    }
  }

  final clueCount = _clueCount(board);
  if (clueCount < minClues || clueCount > maxClues) return null;
  return _flatten(board);
}

int _clueCount(List<List<int>> board) {
  var count = 0;
  for (final row in board) {
    for (final cell in row) {
      if (cell != 0) count++;
    }
  }
  return count;
}

List<List<int>> _copyBoard(List<List<int>> board) {
  return board.map((row) => List<int>.from(row)).toList();
}

int _countSolutions(List<List<int>> board, int found) {
  if (found > 1) return found;

  final empty = _findEmpty(board);
  if (empty == null) return found + 1;

  final (row, col) = empty;
  for (var digit = 1; digit <= 9; digit++) {
    if (!_canPlace(board, row, col, digit)) continue;
    board[row][col] = digit;
    found = _countSolutions(board, found);
    board[row][col] = 0;
    if (found > 1) return found;
  }
  return found;
}

(int, int)? _findEmpty(List<List<int>> board) {
  for (var row = 0; row < 9; row++) {
    for (var col = 0; col < 9; col++) {
      if (board[row][col] == 0) return (row, col);
    }
  }
  return null;
}

bool _canPlace(List<List<int>> board, int row, int col, int value) {
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

String _flatten(List<List<int>> board) {
  final buffer = StringBuffer();
  for (final row in board) {
    for (final cell in row) {
      buffer.write(cell);
    }
  }
  return buffer.toString();
}
