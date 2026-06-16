import 'difficulty.dart';
import '../logic/puzzle_validation.dart';

class Puzzle {
  const Puzzle({
    required this.id,
    required this.difficulty,
    required this.givens,
    required this.solution,
  });

  final String id;
  final Difficulty difficulty;
  final String givens;
  final String solution;

  factory Puzzle.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final givens = PuzzleValidation.digitsOnly(json['givens'] as String);
    final solution = PuzzleValidation.digitsOnly(json['solution'] as String);
    final error = PuzzleValidation.validate(
      id: id,
      givens: givens,
      solution: solution,
    );
    if (error != null) {
      throw FormatException(error);
    }
    return Puzzle(
      id: id,
      difficulty: Difficulty.fromKey(json['difficulty'] as String),
      givens: givens,
      solution: solution,
    );
  }
}
