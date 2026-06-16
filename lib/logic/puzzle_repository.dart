import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/difficulty.dart';
import '../models/puzzle.dart';

class PuzzleRepository {
  PuzzleRepository._();

  static final PuzzleRepository instance = PuzzleRepository._();

  List<Puzzle>? _cache;

  Future<List<Puzzle>> loadAll() async {
    if (_cache != null) return _cache!;

    final raw = await rootBundle.loadString('assets/puzzles/puzzles.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final list = (json['puzzles'] as List<dynamic>)
        .map((item) => Puzzle.fromJson(item as Map<String, dynamic>))
        .toList();

    _cache = list;
    return list;
  }

  Future<Puzzle> nextForDifficulty(Difficulty difficulty) async {
    final puzzles = await loadAll();
    final filtered = puzzles.where((p) => p.difficulty == difficulty).toList();
    if (filtered.isEmpty) {
      throw StateError('No puzzles for ${difficulty.label}');
    }
    return filtered.first;
  }
}
