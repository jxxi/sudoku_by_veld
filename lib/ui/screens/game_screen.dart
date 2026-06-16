import 'dart:async';

import 'package:flutter/material.dart';

import '../../logic/candidate_grid.dart';
import '../../logic/game_controller.dart';
import '../../logic/hint_engine.dart';
import '../../logic/puzzle_repository.dart';
import '../../logic/sudoku_solver.dart';
import '../../models/difficulty.dart';
import '../../models/game_state.dart';
import '../../services/haptics.dart';
import '../../storage/game_store.dart';
import '../../storage/stats_store.dart';
import '../../theme/veld_colors.dart';
import '../grid/sudoku_grid.dart';
import '../widgets/completion_celebration.dart';
import '../widgets/number_pad.dart';
import '../widgets/stat_row.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.statsStore,
    required this.gameStore,
    required this.onCompleted,
    this.difficulty,
    this.resumedState,
  });

  final StatsStore statsStore;
  final GameStore gameStore;
  final VoidCallback onCompleted;
  final Difficulty? difficulty;
  final GameState? resumedState;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late GameController _controller;
  StrategyHint? _activeHint;
  Timer? _timer;
  bool _loading = true;
  bool _showCelebration = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPuzzle();
  }

  Future<void> _loadPuzzle() async {
    if (widget.resumedState != null) {
      _controller = GameController(widget.resumedState!);
    } else {
      final puzzle = await PuzzleRepository.instance.nextForDifficulty(
        widget.difficulty!,
        statsStore: widget.statsStore,
      );
      await widget.gameStore.clear();
      _controller = GameController(GameState.fromPuzzle(puzzle));
    }

    _startTimer();
    setState(() => _loading = false);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _controller.state.isComplete) return;
      _controller.tick(_controller.state.elapsedSeconds + 1);
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _persist();
    }
  }

  Future<void> _persist() async {
    if (_loading || _controller.state.isComplete) return;
    await widget.gameStore.save(_controller.state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _persist();
    super.dispose();
  }

  Future<void> _onCompleted() async {
    _timer?.cancel();
    VeldHaptics.success();
    setState(() => _showCelebration = true);
  }

  Future<void> _afterCelebration() async {
    await widget.gameStore.clear();
    await widget.statsStore.recordWin(
      _controller.state.difficulty,
      _controller.state.elapsedSeconds,
    );
    widget.onCompleted();
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Puzzle complete'),
        content: Text(
          'Time: ${formatElapsed(_controller.state.elapsedSeconds)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  Future<bool> _confirmLeave() async {
    if (_controller.state.isComplete) return true;

    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave puzzle?'),
        content: const Text('Your progress is saved — you can continue from home.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  Future<void> _showHintSheet() async {
    final choice = await showModalBottomSheet<HintType>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Choose a hint', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Strategy teaches a pattern. Reveal fills one cell.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.pop(context, HintType.strategy),
                  child: const Text('Strategy'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, HintType.reveal),
                  child: const Text('Reveal cell'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (choice == null || !mounted) return;

    if (choice == HintType.strategy) {
      final hint = HintEngine.findStrategyHint(_controller.state.cells);
      if (hint == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No simple pattern found right now — try Reveal cell or keep scanning.',
            ),
          ),
        );
        return;
      }
      setState(() => _activeHint = hint);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(hint.technique),
          content: Text(hint.explanation),
          actions: [
            if (hint.placement != null)
              TextButton(
                onPressed: () {
                  final placement = hint.placement!;
                  _controller.applyReveal(placement.cell, placement.value);
                  setState(() => _activeHint = null);
                  Navigator.pop(context);
                  _afterMove();
                },
                child: const Text('Apply'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ],
        ),
      );
      return;
    }

    final board = boardFromCells(_controller.state.cells);
    final pos = SudokuSolver.findRevealCell(
      board,
      _controller.state.puzzle.solution,
    );
    if (pos == null) return;
    final value =
        SudokuSolver.revealValue(_controller.state.puzzle.solution, pos);
    _controller.applyReveal(pos, value);
    setState(() => _activeHint = null);
    _afterMove();
  }

  void _afterMove() {
    setState(() {});
    _persist();
    if (_controller.state.isComplete) {
      _onCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: VeldColors.sage)),
      );
    }

    final state = _controller.state;
    final showTimer = widget.statsStore.showTimerDuringGame;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final leave = await _confirmLeave();
        if (leave && context.mounted) {
          await _persist();
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(state.difficulty.label),
              actions: [
                if (showTimer)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Text(
                        formatElapsed(state.elapsedSeconds),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SudokuGrid(
                      state: state,
                      strategyHint: _activeHint,
                      onCellTap: (pos) {
                        setState(() {
                          _activeHint = null;
                          _controller.selectCell(pos);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    NumberPad(
                      pencilMode: state.pencilMode,
                      onDigit: (digit) {
                        final pencil = _controller.state.pencilMode;
                        setState(() {
                          _activeHint = null;
                          _controller.inputDigit(digit);
                        });
                        if (!pencil) {
                          final pos = _controller.state.selected;
                          if (pos != null &&
                              _controller.state.cells[pos.row][pos.col]
                                  .isWrong) {
                            VeldHaptics.mistake();
                          }
                        }
                        _afterMove();
                      },
                      onErase: () {
                        setState(() {
                          _activeHint = null;
                          _controller.clearSelected();
                        });
                        _persist();
                      },
                      onTogglePencil: () {
                        setState(_controller.togglePencilMode);
                      },
                      onHint: _showHintSheet,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showCelebration)
            Positioned.fill(
              child: CompletionCelebration(
                onFinished: () {
                  setState(() => _showCelebration = false);
                  _afterCelebration();
                },
              ),
            ),
        ],
      ),
    );
  }
}
