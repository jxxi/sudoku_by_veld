import 'dart:convert';
import 'dart:io';

import 'package:sudoku_by_veld/logic/puzzle_validation.dart';

/// CI-friendly validator for the puzzle pack.
///
/// Usage: dart run tool/validate_puzzles.dart
void main() {
  final file = File('assets/puzzles/puzzles.json');
  if (!file.existsSync()) {
    stderr.writeln('Missing ${file.path}');
    exitCode = 1;
    return;
  }

  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final puzzles = json['puzzles'] as List<dynamic>;
  var ok = true;

  for (final item in puzzles) {
    final map = item as Map<String, dynamic>;
    final id = map['id'] as String;
    final givens = PuzzleValidation.digitsOnly(map['givens'] as String);
    final solution = PuzzleValidation.digitsOnly(map['solution'] as String);
    final error = PuzzleValidation.validate(
      id: id,
      givens: givens,
      solution: solution,
    );
    if (error != null) {
      ok = false;
      stderr.writeln(error);
    }
  }

  if (ok) {
    stdout.writeln('All ${puzzles.length} puzzles valid.');
  } else {
    exitCode = 1;
  }
}
