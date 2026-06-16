import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_by_veld/models/difficulty.dart';
import 'package:sudoku_by_veld/logic/puzzle_validation.dart';
import 'package:sudoku_by_veld/models/puzzle.dart';

void main() {
  test('pack includes every difficulty tier', () {
    final file = File('assets/puzzles/puzzles.json');
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final puzzles = json['puzzles'] as List<dynamic>;
    final tiers = puzzles
        .map((p) => (p as Map<String, dynamic>)['difficulty'] as String)
        .toSet();

    for (final difficulty in Difficulty.values) {
      expect(
        tiers,
        contains(difficulty.name),
        reason: 'missing ${difficulty.name} puzzles',
      );
    }
  });

  test('assets/puzzles/puzzles.json contains only valid puzzles', () {
    final file = File('assets/puzzles/puzzles.json');
    expect(file.existsSync(), isTrue, reason: 'puzzle pack asset missing');

    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final puzzles = json['puzzles'] as List<dynamic>;
    expect(puzzles, isNotEmpty);

    for (final item in puzzles) {
      final map = item as Map<String, dynamic>;
      final id = map['id'] as String;
      final givens = PuzzleValidation.digitsOnly(map['givens'] as String);
      final solution = PuzzleValidation.digitsOnly(map['solution'] as String);

      expect(
        PuzzleValidation.validate(id: id, givens: givens, solution: solution),
        isNull,
        reason: 'puzzle $id failed validation',
      );

      expect(() => Puzzle.fromJson(map), returnsNormally);
    }
  });
}
