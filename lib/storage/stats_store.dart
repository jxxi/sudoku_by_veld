import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/difficulty.dart';

class DifficultyStats {
  const DifficultyStats({this.bestSeconds, this.completed = 0});

  final int? bestSeconds;
  final int completed;

  DifficultyStats copyWith({int? bestSeconds, int? completed}) {
    return DifficultyStats(
      bestSeconds: bestSeconds ?? this.bestSeconds,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() => {
        'bestSeconds': bestSeconds,
        'completed': completed,
      };

  factory DifficultyStats.fromJson(Map<String, dynamic> json) {
    return DifficultyStats(
      bestSeconds: json['bestSeconds'] as int?,
      completed: json['completed'] as int? ?? 0,
    );
  }
}

class StatsStore {
  StatsStore(this._prefs);

  final SharedPreferences _prefs;

  static const _statsKey = 'difficulty_stats';
  static const _tutorialCompletedKey = 'tutorial_completed';
  static const _tipJarKey = 'tip_jar_purchased';
  static const _showTimerKey = 'show_timer_during_game';
  static const _mistakeFeedbackKey = 'show_mistake_feedback';
  static const _puzzleIndexPrefix = 'puzzle_index_';

  Map<Difficulty, DifficultyStats> loadStats() {
    final raw = _prefs.getString(_statsKey);
    if (raw == null) {
      return {for (final d in Difficulty.values) d: const DifficultyStats()};
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return {
      for (final difficulty in Difficulty.values)
        difficulty: DifficultyStats.fromJson(
          decoded[difficulty.name] as Map<String, dynamic>? ?? {},
        ),
    };
  }

  Future<void> recordWin(Difficulty difficulty, int seconds) async {
    final stats = loadStats();
    final current = stats[difficulty] ?? const DifficultyStats();
    final best = current.bestSeconds;
    final newBest = best == null ? seconds : (seconds < best ? seconds : best);

    stats[difficulty] = current.copyWith(
      bestSeconds: newBest,
      completed: current.completed + 1,
    );

    await _prefs.setString(
      _statsKey,
      jsonEncode({
        for (final entry in stats.entries) entry.key.name: entry.value.toJson(),
      }),
    );
  }

  bool get tutorialCompleted => _prefs.getBool(_tutorialCompletedKey) ?? false;

  Future<void> setTutorialCompleted(bool value) =>
      _prefs.setBool(_tutorialCompletedKey, value);

  bool get tipJarPurchased => _prefs.getBool(_tipJarKey) ?? false;

  Future<void> setTipJarPurchased(bool value) =>
      _prefs.setBool(_tipJarKey, value);

  bool get showTimerDuringGame => _prefs.getBool(_showTimerKey) ?? true;

  Future<void> setShowTimerDuringGame(bool value) =>
      _prefs.setBool(_showTimerKey, value);

  bool get showMistakeFeedback => _prefs.getBool(_mistakeFeedbackKey) ?? true;

  Future<void> setShowMistakeFeedback(bool value) =>
      _prefs.setBool(_mistakeFeedbackKey, value);

  int puzzleIndex(Difficulty difficulty) =>
      _prefs.getInt('$_puzzleIndexPrefix${difficulty.name}') ?? 0;

  Future<void> setPuzzleIndex(Difficulty difficulty, int index) =>
      _prefs.setInt('$_puzzleIndexPrefix${difficulty.name}', index);
}
