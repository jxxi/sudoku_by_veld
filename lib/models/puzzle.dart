import 'difficulty.dart';

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
    return Puzzle(
      id: json['id'] as String,
      difficulty: Difficulty.fromKey(json['difficulty'] as String),
      givens: json['givens'] as String,
      solution: json['solution'] as String,
    );
  }
}
