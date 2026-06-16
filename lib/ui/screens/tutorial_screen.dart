import 'package:flutter/material.dart';

import '../../logic/game_controller.dart';
import '../../services/haptics.dart';
import '../../logic/puzzle_repository.dart';
import '../../models/cell_position.dart';
import '../../models/game_state.dart';
import '../../storage/stats_store.dart';
import '../../theme/veld_colors.dart';
import '../grid/sudoku_grid.dart';
import '../widgets/number_pad.dart';
import '../tutorial/tutorial_steps.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key, required this.statsStore});

  final StatsStore statsStore;

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late GameController _controller;
  TutorialStep _step = TutorialStep.welcome;
  bool _loading = true;
  int _pencilNotesAdded = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final puzzle = await PuzzleRepository.instance.byId(tutorialPuzzleId);
    if (puzzle == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }
    _controller = GameController(GameState.fromPuzzle(puzzle));
    setState(() => _loading = false);
  }

  TutorialStepData get _data => dataForStep(_step);

  Future<void> _skip() async {
    await widget.statsStore.setTutorialCompleted(true);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _finish() async {
    await widget.statsStore.setTutorialCompleted(true);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Walkthrough complete'),
        content: const Text('Head home and start your first real puzzle.'),
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

  void _advance(TutorialStep next) {
    setState(() {
      _step = next;
      _pencilNotesAdded = 0;
      if (next == TutorialStep.mistake && _controller.state.pencilMode) {
        _controller.togglePencilMode();
      }
    });
  }

  void _onCellTap(CellPosition pos) {
    final data = _data;
    if (data.targetCell != null &&
        data.step != TutorialStep.seeHighlights &&
        pos != data.targetCell) {
      return;
    }

    setState(() => _controller.selectCell(pos));

    if (_step == TutorialStep.tapCell) {
      _advance(TutorialStep.enterDigit);
    } else if (_step == TutorialStep.seeHighlights) {
      if (pos != const CellPosition(0, 4)) return;
      _advance(TutorialStep.pencilMode);
    } else if (_step == TutorialStep.pencilMode && data.targetCell == pos) {
      // wait for pencil notes
    }
  }

  void _onDigit(int digit) {
    final data = _data;

    if (_step == TutorialStep.enterDigit) {
      if (digit != data.expectedDigit) return;
      _controller.inputDigit(digit);
      _advance(TutorialStep.seeHighlights);
      setState(() {});
      return;
    }

    if (_step == TutorialStep.pencilMode) {
      if (!_controller.state.pencilMode) return;
      if (_controller.state.selected != data.targetCell) return;
      if (digit != 2 && digit != 4) return;

      _controller.inputDigit(digit);
      _pencilNotesAdded++;
      if (_pencilNotesAdded >= 2) {
        _advance(TutorialStep.mistake);
      }
      setState(() {});
      return;
    }

    if (_step == TutorialStep.mistake) {
      if (_controller.state.pencilMode) return;
      if (digit != data.expectedDigit) return;
      if (_controller.state.selected != data.targetCell) return;
      _controller.inputDigit(digit);
      VeldHaptics.mistake();
      _advance(TutorialStep.done);
      setState(() {});
    }
  }

  void _onTogglePencil() {
    if (_step == TutorialStep.pencilMode ||
        _step == TutorialStep.mistake) {
      setState(_controller.togglePencilMode);
      if (_step == TutorialStep.mistake && !_controller.state.pencilMode) {
        // ready for wrong digit
      }
    }
  }

  bool get _showNumberPad =>
      _step == TutorialStep.enterDigit ||
      _step == TutorialStep.pencilMode ||
      _step == TutorialStep.mistake;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: VeldColors.sage)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Walkthrough'),
        actions: [
          TextButton(onPressed: _skip, child: const Text('Skip')),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SudokuGrid(
                state: _controller.state,
                onCellTap: _onCellTap,
                highlightCell: _data.targetCell,
              ),
              const SizedBox(height: 16),
              if (_showNumberPad)
                NumberPad(
                  pencilMode: _controller.state.pencilMode,
                  onDigit: _onDigit,
                  onErase: () => setState(_controller.clearSelected),
                  onTogglePencil: _onTogglePencil,
                  onHint: () {},
                  showHint: false,
                )
              else
                const SizedBox(height: 120),
              const SizedBox(height: 16),
              TutorialCoach(
                data: _data,
                onSkip: _skip,
                onNext: _step == TutorialStep.welcome
                    ? () => _advance(TutorialStep.tapCell)
                    : _step == TutorialStep.done
                        ? _finish
                        : () {},
                showNext:
                    _step == TutorialStep.welcome || _step == TutorialStep.done,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
