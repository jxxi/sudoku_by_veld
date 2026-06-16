import 'package:flutter/material.dart';

import '../../theme/veld_colors.dart';

class CompletionCelebration extends StatefulWidget {
  const CompletionCelebration({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<CompletionCelebration> createState() => _CompletionCelebrationState();
}

class _CompletionCelebrationState extends State<CompletionCelebration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.easeOut),
      ),
    );
    _controller.forward().then((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            color: Colors.black.withValues(alpha: 0.12 * _opacity.value),
            alignment: Alignment.center,
            child: Opacity(
              opacity: _opacity.value,
              child: Transform.scale(
                scale: 0.8 + (_scale.value * 0.2),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: VeldColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: VeldColors.sage, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: VeldColors.sage.withValues(alpha: 0.25),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.eco_outlined,
                        size: 48,
                        color: VeldColors.sage.withValues(
                          alpha: 0.6 + (_scale.value * 0.4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
