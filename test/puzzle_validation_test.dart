import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_by_veld/logic/puzzle_validation.dart';
import 'package:sudoku_by_veld/models/puzzle.dart';
import 'package:sudoku_by_veld/ui/tutorial/tutorial_puzzle.dart';

void main() {
  late String validGivens;
  late String validSolution;

  setUpAll(() {
    final file = File('assets/puzzles/puzzles.json');
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final first =
        (json['puzzles'] as List<dynamic>).first as Map<String, dynamic>;
    validGivens = PuzzleValidation.digitsOnly(first['givens'] as String);
    validSolution = PuzzleValidation.digitsOnly(first['solution'] as String);
  });

  group('TutorialPuzzle', () {
    test('walkthrough puzzle is valid', () {
      final puzzle = TutorialPuzzle.build();
      expect(
        PuzzleValidation.validate(
          id: puzzle.id,
          givens: puzzle.givens,
          solution: puzzle.solution,
        ),
        isNull,
      );
    });
  });

  group('PuzzleValidation', () {
    test('accepts first pack puzzle', () {
      expect(
        PuzzleValidation.validate(
          id: 'pack-001',
          givens: validGivens,
          solution: validSolution,
        ),
        isNull,
      );
    });

    test('rejects givens with wrong length', () {
      final error = PuzzleValidation.validate(
        id: 'bad',
        givens: validGivens.substring(0, 78),
        solution: validSolution,
      );
      expect(error, contains('givens must be 81 digits'));
    });

    test('rejects givens that disagree with solution', () {
      final badGivens = validGivens.replaceFirst('5', '9');
      final error = PuzzleValidation.validate(
        id: 'bad',
        givens: badGivens,
        solution: validSolution,
      );
      expect(error, contains('conflict with solution'));
    });

    test('rejects invalid completed solution', () {
      final badSolution = List.filled(81, '1').join();
      const emptyGivens =
          '000000000000000000000000000000000000000000000000000000000000000000000000000000000';
      final error = PuzzleValidation.validate(
        id: 'bad',
        givens: emptyGivens,
        solution: badSolution,
      );
      expect(error, contains('not a valid completed Sudoku'));
    });
  });

  group('Puzzle.fromJson', () {
    test('parses valid json', () {
      final puzzle = Puzzle.fromJson({
        'id': 'pack-001',
        'difficulty': 'easy',
        'givens': validGivens,
        'solution': validSolution,
      });
      expect(puzzle.givens.length, 81);
      expect(puzzle.solution.length, 81);
    });

    test('throws on short givens', () {
      expect(
        () => Puzzle.fromJson({
          'id': 'bad',
          'difficulty': 'easy',
          'givens': validGivens.substring(0, 78),
          'solution': validSolution,
        }),
        throwsFormatException,
      );
    });
  });
}
