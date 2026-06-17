import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/difficulty.dart';
import '../models/puzzle.dart';
import '../services/app_logger.dart';
import '../storage/stats_store.dart';

class PuzzleRepository {
  PuzzleRepository._();

  static final PuzzleRepository instance = PuzzleRepository._();

  List<Puzzle>? _cache;

  Future<List<Puzzle>> loadAll() async {
    if (_cache != null) return _cache!;

    try {
      final raw = await rootBundle.loadString('assets/puzzles/puzzles.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final list = <Puzzle>[];
      for (final item in json['puzzles'] as List<dynamic>) {
        try {
          list.add(Puzzle.fromJson(item as Map<String, dynamic>));
        } catch (error, stackTrace) {
          AppLogger.warn('Skipping invalid puzzle entry', error, stackTrace);
        }
      }

      if (list.isEmpty) {
        throw StateError('No valid puzzles in assets/puzzles/puzzles.json');
      }

      _cache = list;
      AppLogger.info('Loaded ${list.length} puzzles');
      return list;
    } catch (error, stackTrace) {
      AppLogger.error('Failed to load puzzle pack', error, stackTrace);
      rethrow;
    }
  }

  Future<Puzzle?> byId(String id) async {
    final puzzles = await loadAll();
    for (final puzzle in puzzles) {
      if (puzzle.id == id) return puzzle;
    }
    return null;
  }

  Future<Puzzle> nextForDifficulty(
    Difficulty difficulty, {
    required StatsStore statsStore,
    bool advanceIndex = true,
  }) async {
    final puzzles = await loadAll();
    final filtered = puzzles.where((p) => p.difficulty == difficulty).toList();
    if (filtered.isEmpty) {
      throw StateError('No puzzles for ${difficulty.label}');
    }

    final index = statsStore.puzzleIndex(difficulty) % filtered.length;
    if (advanceIndex) {
      await statsStore.setPuzzleIndex(difficulty, index + 1);
    }
    return filtered[index];
  }
}
